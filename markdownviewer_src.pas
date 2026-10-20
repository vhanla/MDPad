{
  MDPad v1.1
  by vhanla
  -----------------
  This is a desktop version of ShowDown port to javascript

  Initial release
  2012-06-06
  +Everything in executable, no external html files

  Changelog:
  - 2026-10-01 v1.3.7
    - Actually porting to Linux
  - 2018-09-23 v1.3.6
    - Workaround to borderstyle changing in order to restore WebViewer

  - 2018-09-22 v1.3.5
    - Migrated code to FreePascal
    - Replaced BCEditor with ATSynEdit
    - Alternative HTML rendering using HTMLViewer CrossPlatform HTML 4.01 compliant
    - Kept ActiveX MSHTML as main rendering on Windows

  - 2017-09-30 v1.3.4
    - Updated BCEditor
  - 2016-07-07 v1.3.3
    - Added support for custom theme, css and markdown syntax
  - 2016-07-06 v1.3.2
    - Fixed erronous method to load markdown files to the new engines
    - Fixed error of wordwrap bceditor show (F7) if document was hidden before
    and in different width size
    // let's disable wordwrap first, otherwise BCEditor will raise error
    // it might have to do with resizing width while wordwrap, weird
    - Fixed incorrect initialization of textBuffer := BCEditor1.Text; since on
    FormCreate wasn't considered, hence Closing, New o Opening was showing that
    editor was modified

  - 2016-07-02 v1.3.1
    Added Native Markdown processor thanks to
    Delphi-Markdown - Pavel Stugel

  - 2016-07-01 v1.3
    Replaced Memo with BCEdit to offer syntax highlighting
    Overrided TBCEditor procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; X, Y: Integer); override;
    to make popup menu work, like notepad's, but no IME and RTL option available on this editor
  - 2013-05-19 v1.2
    Added more other engines to render MD
    MarkdownJS and Marked but needs updating Pagedown

  - 2012-06-10 v1.1
    Renamed to MDPad since MarkDownPad already exists :(
    Status bar
    Wordwrap
    Sync Editor with Preview
    Save to ini
    Fixed arrow navitagion on twebbrowser
    UTF-8 Encoding support to tmemo
    Division by zero bug fixed for sync
    Left trying to improve preview time, automatically swtich to slow delay mode if bigger text opened,
    not optimized for pasting on new editions. yet :P
    Saves window size
    html preview zoom

  - 2012-06-08
    Fixed onfocus event to focus webbrowser after returning to this app it lost focus
    Added find text option, not well done yet

  - 2012-06-07
    Initial release
}
{$MODE DELPHI}
{$MODESWITCH ANONYMOUSFUNCTIONS} // Necesario en FPC 3.3.1 para procedimientos anónimos
unit markdownviewer_src;

interface

uses
  SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  Menus, ExtCtrls, ComCtrls, Buttons, LCLType,
  {$IFDEF MSWINDOWS}
  Windows, Messages, ActiveXContainer, MSHTML_4_0_TLB, SHDocVw_1_1_TLB,
  {$ENDIF}
  Generics.Collections, SyncObjs,
  MyWiki.MarkdownConverter, MyWiki.WikiConverter, MyWiki.Header,
  markdownprocessor, ATSynEdit, ATSynEdit_Commands,
  ATStringProc,
    ATSynEdit_Adapter_EControl,
    ATSynEdit_Carets,
    ATSynEdit_Bookmarks,
    ATSynEdit_Export_HTML,
    ATSynEdit_Globals,
  mdoptions, mdformat, mddialogs, IniFiles,
  ec_SyntAnal,
  ec_proc_lexer,
  HtmlView, HtmlGlobals,
  // THtmlViewer keeps a name -> section map of the rendered HTML (the one an
  // in-page link jump uses). The scroll sync reads the Y a heading was drawn at
  // from it, since the viewer has no source-line map of its own.
  HTMLSubs, HTMLUn2,
  // Markdown4D: alternative preview backend. It parses the markdown itself and
  // draws it on a canvas (no HTML, no browser), so it needs none of the
  // engine/HTML plumbing above.
  Markdown4D,
  Markdown4D.Defines,
  // The outline of a Markdown4D-parsed document (captions, levels, anchors and
  // source lines) and the pipeline that renders its HTML with those anchors
  // written as ids, so the table of contents and the preview agree.
  Markdown4D.Toc,
  Markdown4D.Pipeline,
  Markdown4D.Extensions.Interfaces,
  // Where a scroll offset keeps a source line in view (the same helper the
  // library's own editors use to follow an editor without yanking the preview).
  Markdown4D.Editor.PreviewScroll,
  Markdown4D.Ast.Interfaces,
  Markdown4D.Theme,
  // TSyntaxTokenKind: the palette the canvas colors code with, which the editor
  // borrows for its own token colors (see SetLexerPalette).
  Markdown4D.Highlighter.Interfaces,
  Markdown4D.Layout.Interfaces,
  Markdown4D.Layout.Engine,
  Markdown4D.Layout.Renderer,
  Markdown4D.Layout.DisplayList,
  Markdown4D.Lcl.ImageDecoder,
  Markdown4D.Lcl.MathFont,
  Markdown4D.Lcl.Painter,
  Markdown4D.Lcl.Viewer,
  // IsMonospaceFamilyName: whether the editor's font may be pinned on code
  // blocks (see EditorCodeFontName).
  Markdown4D.Viewer.Shared;

{$IFDEF MSWINDOWS}
type
  { TWebBrowser }

  TWebBrowser = class(SHDocVw_1_1_TLB.TEvsWebBrowser)
    procedure CNChar(var Message: TWMChar);message CN_CHAR;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;
{$ENDIF}
type

  { Declaramos un hilo específico para la conversión }

  { TConversionThread }

  TConversionThread = class(TThread)
  private
    FMarkdown: string;
    FRequestID: Int64;
    FEngine: Integer;
    FHtmlResult: string;
    FHeaders: TObjectList<THeaderItem>;
    // Procedimiento que se sincronizará con la UI principal
    procedure SyncUpdateUI;
  protected
    procedure Execute; override;
  public
    constructor Create(const AMarkdown: string; ARequestID: Int64;
      AEngine: Integer);
    destructor Destroy; override;
  end;

type
  Comodin=class(TControl); //for scrolling

// Which palette the editor and every preview backend draw with. System follows
// the desktop's preference (Light when it cannot be told); Custom reads the
// theme files next to the exe -- Theme.json for the editor (BCEditor's theme
// format, the one this app has always shipped), style.css for the HTML preview
// and, when present, Md4dTheme.json for the canvas one.
type
  TAppTheme = (atSYSTEM, atLIGHT, atDARK, atCUSTOM);

// One color the custom Theme.json asks for, before the EControl format names
// are known (the lexer library is loaded later, in FormCreate). FontColor is
// clNone when the entry names a color without a foreground -- a background-only
// editor color, say -- and HasBg tells an absent Background from clNone.
type
  TThemeOverride = record
    Name: string;       // a BCEditor theme key or element name
    FontColor: TColor;
    BgColor: TColor;
    HasBg: Boolean;
    Style: TFontStyles;
    HasStyle: Boolean;
  end;
  TThemeOverrides = array of TThemeOverride;

// The editor's formatting commands. One enum feeds the context menu items, the
// format bar buttons and the keyboard, so the three cannot drift apart (the
// Tag of a menu item and of a speed button is the value).
type
  TMdCommand = (mcBold, mcItalic, mcStrike, mcCode, mcCodeBlock,
    mcHeading, mcQuote, mcList, mcOrdered, mcTask,
    mcLink, mcImage, mcTable, mcRule, mcCompleteWord);

  { TForm1 }

  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Pageconfig1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    Splitter2: TSplitter;
    Tree: TTreeView;
    View1: TMenuItem;
    EditorandResult1: TMenuItem;
    Editoronly1: TMenuItem;
    Resultonly1: TMenuItem;
    FullScreen1: TMenuItem;
    N5: TMenuItem;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    PrintPreview1: TMenuItem;
    TrackBar1: TTrackBar;
    tmrHiddenElements: TTimer;
    Preferences1: TMenuItem;
    N4: TMenuItem;
    Registerfilestoopenwith1: TMenuItem;
    Edit1: TMenuItem;
    SelectAll1: TMenuItem;
    FontDialog1: TFontDialog;
    Format1: TMenuItem;
    Font1: TMenuItem;
    N6: TMenuItem;
    Undo1: TMenuItem;
    N7: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    N8: TMenuItem;
    Helponline1: TMenuItem;
    ExportHTML1: TMenuItem;
    tmrKeyEvent: TTimer;
    FindDialog1: TFindDialog;
    N9: TMenuItem;
    Find1: TMenuItem;
    Waitafewsecondsbeforeupdatingthepreview1: TMenuItem;
    StatusBar1: TStatusBar;
    Wordwrap1: TMenuItem;
    Statusbar2: TMenuItem;
    mnuViewTree: TMenuItem;
    N10: TMenuItem;
    N12: TMenuItem;
    PreviewHtml1: TMenuItem;
    PreviewMarkdown4D1: TMenuItem;
    PreviewIE1: TMenuItem;
    Loadremoteimages1: TMenuItem;
    tmrScrollSyncer: TTimer;
    Synceditwithpreview1: TMenuItem;
    Engines1: TMenuItem;
    engPageDown: TMenuItem;
    engMarkDownJS: TMenuItem;
    engMarked: TMenuItem;
    engShowDown: TMenuItem;
    engMarkdownit: TMenuItem;
    engNative: TMenuItem;
    engMarkdown4DNative: TMenuItem;
    mnuSyntax: TMenuItem;
    mnuTheme: TMenuItem;
    mnuThemeSystem: TMenuItem;
    mnuThemeLight: TMenuItem;
    mnuThemeDark: TMenuItem;
    mnuThemeCustom: TMenuItem;
    mnuCSS: TMenuItem;
    mnuRecent: TMenuItem;
    mnuEditor: TMenuItem;
    mnuEditorOptions: TMenuItem;
    mnuEditorSep: TMenuItem;
    mnuEditorGutter: TMenuItem;
    mnuEditorRuler: TMenuItem;
    mnuEditorMinimap: TMenuItem;
    mnuEditorUnprinted: TMenuItem;
    mnuEditorWrap: TMenuItem;
    mnuEditorFormatBar: TMenuItem;
    mnuEditorSmartEnter: TMenuItem;
    mnuEditorSep2: TMenuItem;
    mnuEditorFont: TMenuItem;
    mnuPrefOptions: TMenuItem;
    mnuPrefSep: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    {$IFDEF MSWINDOWS}
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;pDisp:IDispatch;var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant;var Cancel:WordBool);
    {$ENDIF}
    procedure FullScreen1Click(Sender: TObject);

    procedure EditorandResult1Click(Sender: TObject);
    procedure Editoronly1Click(Sender: TObject);
    procedure Resultonly1Click(Sender: TObject);
    procedure Pageconfig1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure tmrHiddenElementsTimer(Sender: TObject);
    procedure Registerfilestoopenwith1Click(Sender: TObject);
    {$IFDEF MSWINDOWS}
    procedure WebBrowser1DocumentComplete(Sender: TObject;pDisp:IDispatch;var URL:OleVariant);
    {$ENDIF}
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure SelectAll1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Helponline1Click(Sender: TObject);
    procedure ExportHTML1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure tmrKeyEventTimer(Sender: TObject);
    procedure Waitafewsecondsbeforeupdatingthepreview1Click(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    procedure mnuViewTreeClick(Sender: TObject);
    procedure ApplyTreeVisible(AVisible: Boolean);
    procedure RefreshTree;
    procedure Wordwrap1Click(Sender: TObject);

    procedure tmrScrollSyncerTimer(Sender: TObject);
    procedure Synceditwithpreview1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BCEditor1Change(Sender: TObject);
    procedure BCEditor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BCEditor1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure ToggleEngine(Sender: TObject);
    procedure TogglePreview(Sender: TObject);
    procedure mnuSyntaxClick(Sender: TObject);
    procedure mnuThemeSelect(Sender: TObject);
    procedure mnuCSSClick(Sender: TObject);
    procedure mnuRecentClick(Sender: TObject);
    procedure mnuRecentClearClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuEditorToggleClick(Sender: TObject);
    procedure Loadremoteimages1Click(Sender: TObject);
    procedure BCEditor1CaretChanged(Sender: TObject);
    procedure EditorPopupClick(Sender: TObject);
    procedure PreviewHotSpotClick(Sender: TObject; const SRC: ThtString; var Handled: Boolean);
  private
    TrackBar1_Position:integer;
    SelectedEngine: Integer;
    SelectedPreview: Integer; // pvHTML / pvMARKDOWN4D / pvIE
// Which palette the editor and the previews are painted with (see
    // ApplyTheme). Saved as "theme" the moment it is picked, like the engine
    // and the preview backend.
    SelectedTheme: TAppTheme;
    // The canvas theme built from Md4dTheme.json when the custom theme is on.
    // The viewer borrows the theme it is given (it only frees the presets it
    // creates itself), so this is what frees it.
    FCanvasTheme: TMarkdownTheme;

    // Recent files: full paths, most recent first, capped by FMRULimit. The
    // File > Open recent submenu is built from it (see RebuildRecentMenu).
    FMRU: TStringList;
    FMRULimit: Integer;

    // What the editor's options are (mdoptions.pas). The Options dialog edits
    // this record, LoadINI/SaveINI store it and ApplyEditorOptions is the only
    // place that writes it into BCEditor1 -- so the quick toggles in the Editor
    // menu, the dialog and a hand edited settings.ini cannot disagree.
    FEditorOpts: TEditorOptions;

    // Markdown inline editing (mdformat.pas for the text engine, mddialogs.pas
    // for link/image/table). The format bar is the visible half of the same
    // commands the context menu and the shortcuts run; it is hidden by default
    // (FEditorOpts.ShowFormatBar) so it never takes room on its own.
    FFormatBar: TPanel;
    FFormatButtons: array of TSpeedButton;
    // Word completion state: the document's words, the typed prefix, and the
    // candidate the editor currently holds, so Ctrl+Space again cycles past it
    // instead of starting over.
    FComplWords: TMdStringArray;
    FComplPrefix: UnicodeString;
    FComplLast: UnicodeString;
    FComplStart: Integer;
    FComplCaret: Integer;
    FComplIndex: Integer;
    FComplActive: Boolean;
    // The image dialog's "copy into assets/" answer, remembered for the session.
    FImageCopyToAssets: Boolean;
    // Whether ApplyChromeColors painted the app dark (the dialogs and the
    // canvas ask before they pick their own palette).
    FThemeDark: Boolean;
    // View > Table of contents. The tree is the table of contents and is filled
    // on every render; while it is hidden the fill is skipped entirely (see
    // UpdateTOC/RefreshTree) and it is rebuilt once when shown again.
    FTreeVisible: Boolean;

    FCurrentRequestID: Int64; // A unique, increment ID for each conversion request
    FActiveTaskCount: Integer; // this will be a thread-safe counter of tasks running in order to wait them before closing our application (rare, for bigger markdowns maybe will be useful)
    FWorker: TConversionThread; // último worker lanzado (nil cuando termina, ver ConversionTerminated)
    FShuttingDown: Boolean; // True durante FormDestroy: los workers no deben tocar la UI

    // Scroll sync state. Both panes follow each other and whichever one the user
    // moved since the last tick drives the other, so these remember where each
    // pane was left (see tmrScrollSyncerTimer). FSyncEditorLine = -1 means "the
    // editor is authoritative again" (a new document or a re-render happened).
    FSyncEditorLine: Integer;
    FSyncCaretLine: Integer;
    FSyncPreviewPos: Integer;
    // The HTML preview has no source-line map, so its headings are used as
    // anchor points: the engine reports the line each heading was written on and
    // the viewer reports the exact Y it was drawn at. Lines between two headings
    // are interpolated over their own stretch, so a picture or a table shifts
    // only its own section instead of the whole mapping.
    FSyncAnchorRange: Integer; // VScrollBarRange the anchors below were measured at
    FSyncAnchorLine: array of Integer; // heading source lines, ascending
    FSyncAnchorY: array of Integer; // their Y in the HTML preview
    FHeaders: TObjectList<THeaderItem>; // headings of the HTML currently previewed
    // The canvas viewer parses only once it has a viewport width, which it is
    // given *after* the render that switched the backend to it: the outline read
    // at that moment is empty, so the tick adopts it again as soon as the viewer
    // has laid the document out. LayoutCount moves on every relayout (resize, an
    // arriving image), which is exactly when the outline can have grown.
    FCanvasLayoutCount: Integer;
    { Private declarations }
    function UsingJsEngine: Boolean;
    function UsingIE: Boolean;
    function UsingMarkdown4D: Boolean;
    function ActivePreview: TWinControl;
    function PreviewHtmlBody: string;
    // Scroll sync: the mapping never guesses, it asks the renderer.
    function PreviewScrollPos: Integer;
    procedure SetEditorTopLine(ALine: Integer);
    procedure SyncEditorToPreview;
    procedure SyncPreviewToEditor;
    procedure InvalidateScrollSync;
    // The HTML preview's anchor points (headings) and the lookups over them.
    procedure AdoptHeaders(AList: TObjectList<THeaderItem>);
    // The canvas backend has no worker to report headings: it parses the
    // document itself, so its own outline is where the heading list and the
    // table of contents come from there.
    procedure AdoptCanvasOutline;
    procedure InvalidateHtmlAnchors;
    procedure EnsureHtmlAnchors;
    procedure BuildHtmlAnchors;
    procedure AddHtmlAnchor(ALine, AY: Integer);
    function HtmlLineToY(ALine: Integer; out AY: Integer): Boolean;
    function HtmlYToLine(AY: Integer; out ALine: Integer): Boolean;
    // The document's table of contents. It cannot come from EControl: lib.lxl's
    // Markdown lexer declares no tree rules at all (only Bash, C and PHP have
    // them), so the code tree would be empty for a markdown document. The
    // headings are the ones the engine rendered -- the same list the HTML
    // preview's anchors are built from -- so an entry is exactly a heading of
    // the preview, on the line it was written.
    procedure UpdateTOC;
    procedure ClearTOC;
    function TocMatchesHeaders: Boolean;
    // A click on an entry goes to that line in both panes (JumpToSourceLine),
    // using the TATRangeInCodeTree each node carries, the type EControl's own
    // nodes used -- so the tree keeps following the caret as it did.
    procedure TreeClick(Sender: TObject);
    procedure JumpToSourceLine(ALine: Integer);
    // Images the document names relative to itself have to resolve next to the
    // document, not relative to wherever MDPad was started from.
    procedure ApplyPreviewBaseFolder;
    // Mirrors the "Load remote images" menu item into the canvas viewer and
    // makes its images change accordingly.
    procedure ApplyRemoteImagesSetting(Reload: Boolean);
    procedure ApplyViewMode;

    // Theming. ApplyTheme paints every surface with the picked palette: the
    // editor (its own colors and the EControl token colors), the table of
    // contents and the window chrome, and whichever preview backend is on
    // duty. The pick is written to settings.ini at the moment it is made, so a
    // killed process still starts with the theme the user last chose.
    procedure ApplyTheme(AReloadPreview: Boolean);
    procedure UpdateThemeInMenu;
    // Turns the EControl lexer (and with it the token colors, folding and the
    // code tree) on or off in the editor, following mnuSyntax.Checked.
    procedure ApplySyntaxEnabled;
    function LexerForCurrentFile: TecSyntAnalyzer;
    // Builds the HTML preview's style sheet (the theme's base sheet plus the
    // user's style.css when "Enable Custom Style" is on) and the document head
    // it is baked into. Also feeds PreviewCSS, which the JS engines use.
    procedure RefreshPreviewStyle(ADark: Boolean);
    procedure ApplyCanvasTheme(ADark: Boolean);
    // The editor's font when it can be used for code, '' when it cannot.
    function EditorCodeFontName: string;
    procedure ApplyChromeColors(ADark: Boolean);
    // Reads Theme.json (BCEditor's theme format, the one this app has always
    // shipped) into name -> color entries; ADark is what its editor background
    // asks the rest of the app to be.
    procedure LoadCustomTheme(out ADark: Boolean; out AOverrides: TThemeOverrides);
    // Leaves the panes in the order tree | tree splitter | editor | editor
    // splitter | viewer by writing their Lefts, which is what the align pass
    // sorts the alLeft controls by. The view-mode handlers own the widths,
    // visibility and aligns; this only hands the pass the order.
    procedure ArrangePanes;

    // Markdown editing helpers. Every command changes the document through
    // ApplyMdEdit, which replaces one range in one undo step and restores the
    // selection the engine asked for.
    function EditorSelection(out AStart, AEnd: Integer): Boolean;
    procedure ApplyMdEdit(const AEdit: TMdEdit);
    procedure MdExecute(ACommand: TMdCommand);
    procedure MdCommandClick(Sender: TObject);
    procedure MdInsertLinkCommand;
    procedure MdInsertImageCommand;
    procedure MdInsertTableCommand;
    procedure MdCompleteWord;
    function AddMdMenuItem(AParent: TMenuItem; const ACaption: string;
      ACommand: TMdCommand; AShortCut: TShortCut): TMenuItem;
    procedure BuildFormatBar;
    procedure ApplyFormatBarTheme;
    function ThemeIsDark: Boolean;

    procedure UpdateCaretStatus;

    procedure PrintHtmlViewer;
    procedure PrintMarkdown4D;
    procedure PerformConversion;
    procedure ConversionTerminated(Sender: TObject);
    procedure ToggleFullScreen;
    procedure OpenMDFile(const fn: string);
    procedure OnFocus(Sender: TObject);
    procedure UpdateResult;
//    procedure ScrollWheel(var Msg: TMessage);
    procedure SyncScrolling;

    procedure SaveINI;
    procedure LoadINI;
    procedure RebuildRecentMenu;
    procedure AddToMRU(const AFile: string);
    procedure RemoveFromMRU(const AFile: string);
    function CanOpenAnotherFile: Boolean;
    function GutterBandVisible(ATag: Integer): Boolean;
    procedure SetGutterBandVisible(ATag: Integer; AValue: Boolean);
    procedure CaptureEditorOptions;
    procedure ApplyEditorOptions;
    procedure LoadEditorOptions(ini: TIniFile);
    procedure SaveEditorOptions(ini: TIniFile);
    procedure UpdateEditorMenuChecks;
    function BuildPreviewList: TIdCaptionArray;
    function BuildEngineList: TIdCaptionArray;

    procedure UpdateEngineInMenu;
    procedure LoadEngine(const DefaultText: string = '');

    procedure UpdatePreviewInMenu;
    procedure PreviewLinkClick(const Sender: TObject; const Url: UnicodeString);

    procedure EditorChangeCaretPos(Sender: TObject);
    procedure AdapterParseDone(Sender: TObject; ATime: integer);

    {$IFDEF MSWINDOWS}
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    {$ENDIF}
    //procedure WMContextMenu(var message: TWMContextMenu); message WM_CONTEXTMENU;
  public
    { Public declarations }
  end;

    
const
  mdPAGEDOWN = 1;
  mdMARKDOWNJS = 2;
  mdMARKED = 3;
  mdSHOWDOWN = 4;
  mdMARKDOWNIT = 5;
  mdNATIVE = 6;
  // Markdown4D's own parser + HTML renderer (its Core units, no browser and no
  // MyWiki involved). Native like mdNATIVE — same role, independent
  // CommonMark/GFM implementation.
  mdMARKDOWN4D = 7;
// Which control renders the preview. Independent from SelectedEngine: the JS
// engines force the IE backend on Windows, everything else honours this.
const
  pvHTML = 1;      // THtmlViewer, fed by the HTML the native engine produces
  pvMARKDOWN4D = 2; // TMarkdownViewer, parses and draws the markdown itself
  pvIE = 3;        // ActiveX WebBrowser (Windows only, JS engines)
const
  DELAYTIME = 10;
var
  Form1: TForm1;
  BCEditor1: TATSynEdit;
  Manager: TecSyntaxManager;
  Adapter: TATAdapterEControl;
  PreviewHtml: THtmlViewer;
  PreviewMd4D: TMarkdownViewer;
  EditorPopup: TPopupMenu;
  {$IFDEF MSWINDOWS}
  BrowserContainer: TActiveXContainer;
  Browser: TWebBrowser;
  {$ENDIF}
  PrevWindowState: TWindowState;
  CurrentFile: string;
  // The style sheet head the JS engines are loaded with (see
  // RefreshPreviewStyle). It ends in </head> because HEADER opens the tag.
  PreviewCSS: string;
  // The whole document head the native HTML preview is rendered into: the
  // theme's sheet, the custom one when enabled, </head><body>. SyncUpdateUI
  // (in the worker) puts the engine's HTML after it.
  PreviewHtmlHead: string;
  textBuffer: widestring;
  //para mantener el aspecto al redimensionar
  ViewersRatio: integer;

  ReadingFromExplorer: Boolean=False;
  ReloadingEngine: Boolean=False;
  Tryingtoclose: Boolean = False;

  SyncPercentage: integer;
  FSelPos: Integer;//for find dialog, 0-based string offset, -1 = find first
  TDelay: Integer=DELAYTIME; //10 seconds before update changes
  needtodelay: boolean = false; //when bigger files are opened we force to slow down
  LastPreviewBody: string; //last HTML rendered by the native engine (used by Export)
  PreviewBaseFontSize: Integer; //THtmlViewer.DefFontSize at startup, zoom scales it
  {$IFDEF MSWINDOWS}
  // URLMON para quitar el feo sonido al iniciar cada enlace
  const
    SET_FEATURE_ON_PROCESS = $00000002;
    FEATURE_DISABLE_NAVIGATION_SOUNDS = 21;
  function CoInternetSetFeatureEnabled(FeatureEntry: DWORD; dwFlags: DWORD; fEnable: BOOL): HRESULT; stdcall; external 'urlmon.dll';
  {$ENDIF}


{$include pagedown.inc}

implementation
uses {$IFDEF MSWINDOWS}activex, registry,{$ENDIF} LCLIntf, Printers, PrintersDlgs, Types, Math,
  // TATEditorColors, the editor's palette record (see SetEditorPalette).
  ATSynEdit_Colors,
  // TecSyntaxFormat: the per-token colors of a lexer (see SetLexerFormat).
  ec_Syntax_Format,
  // Theme.json / Md4dTheme.json are JSON; the desktop's light/dark preference
  // is read from a helper process on Unix.
  System.JSON, Process;
{$R *.lfm}

// ---------------------------------------------------------------------------
// Theming helpers
//
// Colors travel as strings in the custom theme file (BCEditor's $00RRGGBB
// format, or Delphi's cl* names) and as $AARRGGBB in Markdown4D's palette,
// while LCL's TColor is $00BBGGRR: everything is converted here, at the edge,
// so the rest of the theming code only deals with TColor.
// ---------------------------------------------------------------------------

function ThemeColorFromString(const S: string): TColor;
var
  Txt: string;
  Value: Int64;
  ColorValue: LongInt;
begin
  Result := clNone;
  Txt := Trim(S);
  if Txt = '' then
    Exit;
  if Txt[1] = '$' then
  begin
    Value := StrToInt64Def('$' + Copy(Txt, 2, MaxInt), -1);
    if Value < 0 then
      Exit;
    Result := RGB((Value shr 16) and $FF, (Value shr 8) and $FF, Value and $FF);
  end
  else if IdentToColor(Txt, ColorValue) then
    Result := TColor(ColorValue);
end;

function ArgbToLclColor(C: TLayoutColor): TColor;
begin
  Result := RGB((C shr 16) and $FF, (C shr 8) and $FF, C and $FF);
end;

// Perceived brightness, 0..255: what decides whether the custom theme's own
// background asks the rest of the app to be light or dark.
function ColorLuminance(C: TColor): Integer;
var
  R, G, B: Integer;
begin
  C := ColorToRGB(C);
  R := C and $FF;
  G := (C shr 8) and $FF;
  B := (C shr 16) and $FF;
  Result := (R * 299 + G * 587 + B * 114) div 1000;
end;

function ThemeToName(ATheme: TAppTheme): string;
begin
  case ATheme of
    atLIGHT: Result := 'light';
    atDARK: Result := 'dark';
    atCUSTOM: Result := 'custom';
  else
    Result := 'system';
  end;
end;

function ThemePresetOf(ADark: Boolean): TMarkdownThemePreset;
begin
  if ADark then
    Result := TMarkdownThemePreset.Dark
  else
    Result := TMarkdownThemePreset.Light;
end;

function IsMarkdownLexer(An: TecSyntAnalyzer): Boolean;
begin
  Result := Assigned(An) and (An.LexerName = 'Markdown');
end;

// Runs a short helper program and returns its standard output. False when it is
// not installed or fails. Used to ask the desktop about its light/dark
// preference; the output is tiny, so the pipe cannot fill up behind
// poWaitOnExit.
function RunHelper(const ACommand: string; const AArgs: array of string;
  out AOutput: string): Boolean;
var
  P: TProcess;
  I: Integer;
  Buffer: array[0..1023] of Char;
  Count: LongInt;
begin
  AOutput := '';
  Result := False;
  P := TProcess.Create(nil);
  try
    try
      P.Executable := ACommand;
      P.Parameters.Clear;
      for I := 0 to High(AArgs) do
        P.Parameters.Add(AArgs[I]);
      P.Options := [poUsePipes, poWaitOnExit, poStderrToOutPut];
      P.Execute;
      repeat
        Count := P.Output.Read(Buffer, SizeOf(Buffer));
        if Count > 0 then
          AOutput := AOutput + Copy(Buffer, 1, Count);
      until Count <= 0;
      Result := True;
    except
      // a missing helper must not take the app down
      Result := False;
    end;
  finally
    P.Free;
  end;
end;

// Whether the desktop asks for a dark UI. Windows has a registry key, macOS the
// AppleInterfaceStyle default, and the Linux desktops expose it through
// gsettings (GNOME, and everything that follows its settings) or GTK_THEME. No
// answer means Light: a wrong guess is worse than the conservative one.
function SystemPrefersDark: Boolean;
var
  Output: string;
  {$IFDEF MSWINDOWS}
  Reg: TRegistry;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := False;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
      Result := Reg.ReadInteger('AppsUseLightTheme') = 0;
  finally
    Reg.Free;
  end;
  {$ELSE}
  Result := False;
  {$IFDEF DARWIN}
  if RunHelper('defaults', ['read', '-g', 'AppleInterfaceStyle'], Output) then
    if Pos('dark', LowerCase(Output)) > 0 then
      Exit(True);
  {$ENDIF}
  // GTK_THEME=Adwaita:dark is what a dark desktop exports to its children.
  if Pos('dark', LowerCase(GetEnvironmentVariable('GTK_THEME'))) > 0 then
    Exit(True);
  if RunHelper('gsettings', ['get', 'org.gnome.desktop.interface', 'color-scheme'], Output) then
    if Pos('dark', LowerCase(Output)) > 0 then
      Exit(True);
  if RunHelper('gsettings', ['get', 'org.gnome.desktop.interface', 'gtk-theme'], Output) then
    if Pos('dark', LowerCase(Output)) > 0 then
      Exit(True);
  {$ENDIF}
end;

// JSON navigation for the custom theme file. vcl-compat's System.JSON is the
// implementation Markdown4D already links, so there is no second JSON library
// in the binary.
function JsonChildObject(const AObj: TJSONObject; const AName: string): TJSONObject;
var
  V: TJSONValue;
begin
  Result := nil;
  if not Assigned(AObj) then
    Exit;
  V := AObj.GetValue(AName);
  if V is TJSONObject then
    Result := TJSONObject(V);
end;

function JsonChildArray(const AObj: TJSONObject; const AName: string): TJSONArray;
var
  V: TJSONValue;
begin
  Result := nil;
  if not Assigned(AObj) then
    Exit;
  V := AObj.GetValue(AName);
  if V is TJSONArray then
    Result := TJSONArray(V);
end;

function JsonText(const AObj: TJSONObject; const AName: string): string;
var
  V: TJSONValue;
begin
  Result := '';
  if not Assigned(AObj) then
    Exit;
  V := AObj.GetValue(AName);
  if V is TJSONString then
    Result := UTF8Encode(TJSONString(V).Value);
end;

// The editor's own colors: GitHub's light/dark palette, the one the previews
// are drawn with, so the editor and the rendered page read as one surface.
procedure SetEditorPalette(var C: TATEditorColors; ADark: Boolean);
begin
  C.Init;
  if ADark then
  begin
    C.TextFont := RGB($E6, $ED, $F3);
    C.TextBG := RGB($0D, $11, $17);
    C.TextSelFont := RGB($E6, $ED, $F3);
    C.TextSelBG := RGB($26, $4F, $78);
    C.TextDisabledFont := RGB($6E, $76, $81);
    C.TextDisabledBG := RGB($16, $1B, $22);
    C.Caret := RGB($E6, $ED, $F3);
    C.GutterFont := RGB($6E, $76, $81);
    C.GutterBG := RGB($0D, $11, $17);
    C.GutterCaretFont := RGB($E6, $ED, $F3);
    C.GutterCaretBG := RGB($16, $1B, $22);
    C.GutterFoldLine := RGB($3D, $44, $4D);
    C.GutterFoldLine2 := RGB($58, $A6, $FF);
    C.GutterFoldBG := RGB($16, $1B, $22);
    C.GutterSeparatorBG := RGB($30, $36, $3D);
    C.CurrentLineBG := RGB($16, $1B, $22);
    C.CurrentLineBG2 := clNone;
    C.BookmarkBG := RGB($3A, $32, $0F);
    C.BookmarkIcon := RGB($D2, $A8, $FF);
    C.RulerBG := RGB($0D, $11, $17);
    C.RulerFont := RGB($6E, $76, $81);
    C.MarginRight := RGB($30, $36, $3D);
    C.MarginCaret := RGB($FF, $D3, $3D);
    C.MarginUser := RGB($7E, $E7, $87);
    C.IndentVertLines := RGB($2A, $30, $38);
    C.UnprintedFont := RGB($6E, $76, $81);
    C.UnprintedBG := RGB($16, $1B, $22);
    C.UnprintedHexFont := RGB($58, $A6, $FF);
    C.MarkedLinesBG := RGB($2A, $2A, $1A);
    C.Links := RGB($58, $A6, $FF);
    C.LockedBG := RGB($16, $1B, $22);
    C.BorderLine := RGB($3D, $44, $4D);
    C.BorderLineFocused := RGB($58, $A6, $FF);
    C.BorderParentBG := RGB($0D, $11, $17);
    C.BlockStaple := RGB($3D, $44, $4D);
    C.BlockSepLine := RGB($3D, $44, $4D);
    C.TextHintFont := RGB($6E, $76, $81);
    C.StateChanged := RGB($D2, $A8, $FF);
    C.StateAdded := RGB($7E, $E7, $87);
    C.StateSaved := RGB($6E, $76, $81);
    C.ComboboxArrow := RGB($C9, $D1, $D9);
    C.ComboboxArrowBG := RGB($16, $1B, $22);
  end
  else
  begin
    C.TextFont := RGB($1F, $23, $28);
    C.TextBG := RGB($FF, $FF, $FF);
    C.TextSelFont := RGB($1F, $23, $28);
    C.TextSelBG := RGB($B6, $D7, $FF);
    C.TextDisabledFont := RGB($8C, $95, $9F);
    C.TextDisabledBG := RGB($F6, $F8, $FA);
    C.Caret := RGB($1F, $23, $28);
    C.GutterFont := RGB($8C, $95, $9F);
    C.GutterBG := RGB($F6, $F8, $FA);
    C.GutterCaretFont := RGB($1F, $23, $28);
    C.GutterCaretBG := RGB($E6, $EA, $EF);
    C.GutterFoldLine := RGB($D0, $D7, $DE);
    C.GutterFoldLine2 := RGB($09, $69, $DA);
    C.GutterFoldBG := RGB($E6, $EA, $EF);
    C.GutterSeparatorBG := RGB($D0, $D7, $DE);
    C.CurrentLineBG := RGB($F6, $F8, $FA);
    C.CurrentLineBG2 := clNone;
    C.BookmarkBG := RGB($FF, $F8, $C5);
    C.BookmarkIcon := RGB($9A, $67, $00);
    C.RulerBG := RGB($F6, $F8, $FA);
    C.RulerFont := RGB($8C, $95, $9F);
    C.MarginRight := RGB($D0, $D7, $DE);
    C.MarginCaret := RGB($2D, $A4, $2D);
    C.MarginUser := RGB($BF, $87, $00);
    C.IndentVertLines := RGB($D8, $DE, $E4);
    C.UnprintedFont := RGB($A0, $A8, $B0);
    C.UnprintedBG := RGB($F0, $F2, $F5);
    C.UnprintedHexFont := RGB($6E, $76, $81);
    C.MarkedLinesBG := RGB($FF, $F8, $C5);
    C.Links := RGB($09, $69, $DA);
    C.LockedBG := RGB($F6, $F8, $FA);
    C.BorderLine := RGB($D0, $D7, $DE);
    C.BorderLineFocused := RGB($09, $69, $DA);
    C.BorderParentBG := RGB($FF, $FF, $FF);
    C.BlockStaple := RGB($D0, $D7, $DE);
    C.BlockSepLine := RGB($D0, $D7, $DE);
    C.TextHintFont := RGB($8C, $95, $9F);
    C.StateChanged := RGB($82, $50, $DF);
    C.StateAdded := RGB($1A, $7F, $37);
    C.StateSaved := RGB($8C, $95, $9F);
    C.ComboboxArrow := RGB($1F, $23, $28);
    C.ComboboxArrowBG := RGB($F6, $F8, $FA);
  end;
end;

// Sets one EControl format by name in every analyzer that has it. The lexers
// are one library (lib.lxl) and their formats are what the adapter paints with,
// so this is the editor's syntax theme.
procedure SetLexerFormat(AManager: TecSyntaxManager; const AName: string;
  AFontColor, ABgColor: TColor; ASetBg: Boolean;
  const AStyle: TFontStyles; ASetStyle: Boolean);
var
  I, J: Integer;
  An: TecSyntAnalyzer;
  Fmt: TecSyntaxFormat;
begin
  if not Assigned(AManager) then
    Exit;
  for I := 0 to AManager.AnalyzerCount - 1 do
  begin
    An := AManager.Analyzers[I];
    for J := 0 to An.Formats.Count - 1 do
    begin
      Fmt := An.Formats[J];
      if not SameText(Fmt.DisplayName, AName) then
        Continue;
      if AFontColor <> clNone then
        Fmt.Font.Color := AFontColor;
      if ASetBg then
        Fmt.BgColor := ABgColor;
      if ASetStyle then
        Fmt.Font.Style := AStyle;
    end;
  end;
end;

// Paints the editor's syntax with the palette the Markdown4D canvas colors the
// same tokens with, so a fenced code block looks the same on both sides. The
// first group is the Markdown lexer's own set (lib.lxl's SyntAnal67), the
// second the names the lexers it embeds use for the code inside fences.
procedure SetLexerPalette(AManager: TecSyntaxManager; ADark: Boolean);
var
  Theme: TMarkdownTheme;
  Plain, Keyword, StrLit, NumLit, Comment, Directive, Entity, Tag,
    AttrName, Link, CodeBg, QuoteFg: TColor;
  I, J: Integer;
  Fmt: TecSyntaxFormat;
begin
  if not Assigned(AManager) then
    Exit;

  Theme := TMarkdownTheme.CreatePreset(ThemePresetOf(ADark));
  try
    Plain := ArgbToLclColor(Theme.TextColor);
    Keyword := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.Keyword]);
    StrLit := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.StringLiteral]);
    NumLit := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.NumberLiteral]);
    Comment := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.Comment]);
    Directive := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.Directive]);
    Entity := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.Entity]);
    Tag := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.TagName]);
    AttrName := ArgbToLclColor(Theme.TokenColors[TSyntaxTokenKind.AttributeName]);
    Link := ArgbToLclColor(Theme.LinkColor);
    CodeBg := ArgbToLclColor(Theme.CodeBackgroundColor);
    QuoteFg := ArgbToLclColor(Theme.BlockQuoteTextColor);
  finally
    Theme.Free;
  end;

  // The Markdown lexer. Every background is written (clNone where the token has
  // none) so the light pastel blocks lib.lxl ships do not survive into dark.
  SetLexerFormat(AManager, 'Heading', Keyword, clNone, True, [fsBold], True);
  SetLexerFormat(AManager, 'Comment', Comment, clNone, True, [], True);
  SetLexerFormat(AManager, 'Quote', QuoteFg, clNone, True, [], True);
  SetLexerFormat(AManager, 'Text', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'Codeblock', Plain, CodeBg, True, [], True);
  SetLexerFormat(AManager, 'Block', Plain, CodeBg, True, [], True);
  SetLexerFormat(AManager, 'Link', Link, clNone, True, [], True);
  SetLexerFormat(AManager, 'Image', Link, clNone, True, [], True);
  SetLexerFormat(AManager, 'Reference', Entity, clNone, True, [], True);
  SetLexerFormat(AManager, 'Footnote', Entity, clNone, True, [], True);
  SetLexerFormat(AManager, 'HTML Code', Tag, clNone, True, [], True);
  SetLexerFormat(AManager, 'Bold', Plain, clNone, True, [fsBold], True);
  SetLexerFormat(AManager, 'Italic', Plain, clNone, True, [fsItalic], True);
  SetLexerFormat(AManager, 'Bold-Italic', Plain, clNone, True, [fsBold, fsItalic], True);
  SetLexerFormat(AManager, 'Definition', Plain, clNone, True, [fsBold], True);
  SetLexerFormat(AManager, 'List', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'Crossed out', Plain, clNone, True, [fsStrikeOut], True);

  // Everything else: the formats of the lexers Markdown hands fenced blocks to,
  // and the plain names the other analyzers share.
  SetLexerFormat(AManager, 'Default', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'Identifier', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'Id', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'Symbol', Plain, clNone, True, [], True);
  SetLexerFormat(AManager, 'String', StrLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Char', StrLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Number', NumLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Integer', NumLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Float', NumLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Hex', NumLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'HexNumber', NumLit, clNone, True, [], True);
  SetLexerFormat(AManager, 'Reserved word', Keyword, clNone, True, [fsBold], True);
  SetLexerFormat(AManager, 'Id keyword', Keyword, clNone, True, [], True);
  SetLexerFormat(AManager, 'Id keyword def', Keyword, clNone, True, [fsBold], True);
  SetLexerFormat(AManager, 'Preprocessor', Directive, clNone, True, [], True);
  SetLexerFormat(AManager, 'Attribute', AttrName, clNone, True, [], True);
  SetLexerFormat(AManager, 'Method', Keyword, clNone, True, [], True);
  SetLexerFormat(AManager, 'MethodName', Keyword, clNone, True, [], True);

  // Most lexers number their comment styles: "Comment", "Comment 1", ...
  for I := 0 to AManager.AnalyzerCount - 1 do
  begin
    for J := 0 to AManager.Analyzers[I].Formats.Count - 1 do
    begin
      Fmt := AManager.Analyzers[I].Formats[J];
      if Pos('Comment', Fmt.DisplayName) = 1 then
        Fmt.Font.Color := Comment;
    end;
  end;
end;

// The custom Theme.json's editor colors, on top of the palette above: the keys
// BCEditor writes under Colors/Editor/Colors, plus its "Editor" element (the
// plain text and its background).
procedure ApplyEditorOverrides(var C: TATEditorColors; const AOverrides: TThemeOverrides);
var
  I: Integer;
begin
  for I := 0 to High(AOverrides) do
    with AOverrides[I] do
    begin
      if SameText(Name, 'Editor') then
      begin
        if FontColor <> clNone then
          C.TextFont := FontColor;
        if HasBg and (BgColor <> clNone) then
          C.TextBG := BgColor;
      end
      else if SameText(Name, 'Background') then
        C.TextBG := FontColor
      else if SameText(Name, 'ActiveLineBackground') then
        C.CurrentLineBG := FontColor
      else if SameText(Name, 'SelectionBackground') then
        C.TextSelBG := FontColor
      else if SameText(Name, 'SelectionForeground') then
        C.TextSelFont := FontColor
      else if SameText(Name, 'LeftMarginBackground') then
        C.GutterBG := FontColor
      else if SameText(Name, 'LeftMarginLineNumbers') then
        C.GutterFont := FontColor
      else if SameText(Name, 'LeftMarginActiveLineBackground') then
        C.GutterCaretBG := FontColor
      else if SameText(Name, 'LeftMarginLineNumberLine') then
        C.GutterCaretFont := FontColor
      else if SameText(Name, 'LeftMarginBookmarkPanel') then
        C.BookmarkBG := FontColor
      else if SameText(Name, 'LeftMarginLineStateModified') then
        C.StateChanged := FontColor
      else if SameText(Name, 'LeftMarginLineStateNormal') then
        C.StateAdded := FontColor
      else if SameText(Name, 'RightMargin') then
        C.MarginRight := FontColor;
    end;
end;

// Which EControl formats a BCEditor theme element stands for, '|'-separated.
// The Markdown lexer names its own styles; the generic names are the ones the
// lexers it embeds use for fenced code.
function EcontrolNamesForTheme(const AThemeName: string): string;
begin
  if SameText(AThemeName, 'Comment') then
    Result := 'Comment'
  else if SameText(AThemeName, 'String') then
    Result := 'String|Char'
  else if SameText(AThemeName, 'Directive') then
    Result := 'Preprocessor'
  else if SameText(AThemeName, 'Character') then
    Result := 'Char'
  else if SameText(AThemeName, 'ReservedWord') then
    Result := 'Reserved word|Id keyword|Id keyword def|Heading'
  else if SameText(AThemeName, 'Symbol') then
    Result := 'Symbol'
  else if SameText(AThemeName, 'Number') then
    Result := 'Number|Integer|Float'
  else if SameText(AThemeName, 'HexNumber') then
    Result := 'Hex|HexNumber'
  else if SameText(AThemeName, 'HighlightedBlock') then
    Result := 'Block|Codeblock'
  else if SameText(AThemeName, 'Attribute') then
    Result := 'Attribute'
  else if SameText(AThemeName, 'Method') then
    Result := 'Method'
  else if SameText(AThemeName, 'MethodName') then
    Result := 'MethodName'
  else
    Result := '';
end;

procedure ApplyLexerOverrides(AManager: TecSyntaxManager;
  const AOverrides: TThemeOverrides);
var
  I, P: Integer;
  Names, One: string;
begin
  for I := 0 to High(AOverrides) do
    with AOverrides[I] do
    begin
      Names := EcontrolNamesForTheme(Name);
      while Names <> '' do
      begin
        P := Pos('|', Names);
        if P > 0 then
        begin
          One := Copy(Names, 1, P - 1);
          Delete(Names, 1, P);
        end
        else
        begin
          One := Names;
          Names := '';
        end;
        // A token background only means something for highlighted blocks; the
        // other elements carry the editor's surface, which the palette and
        // ApplyEditorOverrides already paint.
        SetLexerFormat(AManager, One, FontColor, BgColor,
          HasBg and SameText(Name, 'HighlightedBlock'), Style, HasStyle);
      end;
    end;
end;

{$IFDEF MSWINDOWS}
procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
var
   sl: TStringList;
   ms: TMemoryStream;
   url, vnil: OleVariant;
begin
  url := UTF8Encode('about:blank');
  vnil := NULL;
   WebBrowser.ComServer.Navigate(url, vnil, vnil, vnil, vnil) ;
   while WebBrowser.ComServer.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

   if Assigned(WebBrowser.ComServer.Document) then
   begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (WebBrowser.ComServer.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
   end;
end;
procedure TWebBrowser.CNChar(var Message: TWMChar);
begin
  Message.Result:=0;
end;

constructor TWebBrowser.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

destructor TWebBrowser.Destroy;
begin
//  if Assigned(Self) then  FreeAndNil(Self);
  inherited Destroy;
end;
{$ENDIF}

function LoadFileToStr(const FileName: TFileName): String;
var LStrings: TStringList;
begin
    LStrings := TStringList.Create;
    try
      LStrings.Loadfromfile(FileName);
      Result := LStrings.text;
    finally
      FreeAndNil(LStrings);
    end;
end;

// MDPad's own Markdown4D pipeline. Not the one TMarkdown.ToUnsafeHtml shares:
// the shared pipelines leave the headings unnamed (the conformance corpora
// compare their output byte for byte) while a page wants its headings nameable.
// HeadingAnchors writes the anchor TMarkdownToc names each heading by as the id
// of its element, so a #link, an outline entry and the element they stand for
// all agree. Raw HTML is kept (UnsafeHtml) and the GFM tag filter still runs.
//
// UnsafeHtml (not ToHtml) on purpose: it keeps raw HTML in the document, which
// is what the other engines do (MyWiki; the JS ones on Windows) and what the
// Markdown4D canvas renders (`HtmlBlock` is laid out, see
// Markdown4D.Layout.Engine). ToHtml would instead drop every raw HTML block, so
// a document like markdowntest.md (mostly raw HTML) would lose most of its
// content.
function Md4dPipeline: IMarkdownPipeline;
begin
  Result := TMarkdownPipeline.Create.UseCommonMark.UseGfm.UnsafeHtml.UnsafeLinks.HeadingAnchors.Build;
end;

// Takes the heading list the table of contents and the HTML anchors work from
// off a Markdown4D outline, in reading order. The outline counts source lines
// from 1, the way its parser does; the editor, the tree ranges and the scroll
// maps count from 0, so the line is the one before.
function HeadersFromOutline(const Outline: IMarkdownToc): TObjectList<THeaderItem>;
var
  Headers: TObjectList<THeaderItem>;

  procedure AddEntry(const Entry: IMarkdownTocEntry);
  var
    Item: THeaderItem;
    Index: Integer;
  begin
    Item := THeaderItem.Create;
    Item.Caption := Entry.Caption;
    Item.Id := Entry.Anchor;
    Item.Level := Entry.Level;
    Item.Line := Entry.SourceLine - 1;
    Headers.Add(Item);

    for Index := 0 to Entry.ChildCount - 1 do
      AddEntry(Entry.Children[Index]);
  end;

var
  Index: Integer;
begin
  Result := nil;
  if Outline = nil then
    Exit;

  Headers := TObjectList<THeaderItem>.Create(True);
  try
    for Index := 0 to Outline.EntryCount - 1 do
      AddEntry(Outline.Entries[Index]);
    Result := Headers;
  except
    Headers.Free;
    raise;
  end;
end;

{ TConversionThread }

procedure TConversionThread.SyncUpdateUI;
begin
   // Este método corre en el hilo principal (Main Thread)
   if Form1.FShuttingDown then
     Exit; // el form se está destruyendo, no tocar la UI
   if FRequestID = Form1.FCurrentRequestID then
   begin
     LastPreviewBody := FHtmlResult;
     // PreviewHtmlHead is the theme's sheet, built on the main thread by
     // RefreshPreviewStyle; the engine only supplies the body.
     PreviewHtml.Text := PreviewHtmlHead + FHtmlResult + '</body></html>';
     // The headings of the HTML just rendered are the anchor points the scroll
     // sync needs and the entries of the table of contents; the form owns them
     // from here on.
     Form1.AdoptHeaders(FHeaders);
     FHeaders := nil;
     Form1.UpdateTOC;
     // A fresh load parks the preview at the top: put it back where the editor
     // is right away instead of at the next tick (no jump while typing).
     if Form1.Synceditwithpreview1.Checked then
     begin
       Form1.SyncEditorToPreview;
       Form1.InvalidateScrollSync;
     end;
     PreviewHtml.Cursor := crDefault;
     Form1.StatusBar1.Panels[1].Text := '';
   end;
end;

procedure TConversionThread.Execute;
var
  md2: TMarkdownConverter;
  hi, nh: THeaderItem;
  Pipeline: IMarkdownPipeline;
begin
  try
    if FEngine = mdMARKDOWN4D then
    begin
      // Markdown4D renders markdown -> HTML in process: its Core is plain
      // Pascal, so a worker thread is fine.
      //
      // A pipeline of our own (Md4dPipeline): the shared one leaves the headings
      // unnamed, and the preview wants to be able to send the reader to one.
      Pipeline := Md4dPipeline;
      FHtmlResult := Pipeline.ToHtml(FMarkdown);
      // The renderer hands no outline over, so the same document is parsed once
      // more for it: these are the headings of the HTML just rendered.
      FHeaders := HeadersFromOutline(TMarkdownToc.FromDocument(Pipeline.Parse(FMarkdown)));
    end
    else
    begin
      md2 := TMarkdownConverter.Create;
      try
        md2.GiveIdToHeader := True;
        FHtmlResult := md2.WikiToHtml(FMarkdown);

        FHeaders := TObjectList<THeaderItem>.Create(True);
        for hi in md2.Header.HeaderList do
        begin
          nh := THeaderItem.Create;
          nh.Caption := hi.Caption;
          nh.Id := hi.Id;
          nh.Level := hi.Level;
          nh.Line := hi.Line;
          FHeaders.Add(nh);
        end;
      finally
        md2.Free;
      end;
    end;

    // Pasamos el resultado a la UI en el hilo principal.
    // Synchronize (bloqueante) en vez de Queue: con FreeOnTerminate el objeto
    // podría liberarse antes de que el main procese la cola -> GPF intermitente.
    if not Terminated then
      Synchronize(SyncUpdateUI);
  except
    // Manejar posibles excepciones para que no rompan el hilo silenciosamente
  end;
end;

constructor TConversionThread.Create(const AMarkdown: string; ARequestID: Int64;
  AEngine: Integer);
begin
  inherited Create(True); // Creado suspendido
  FreeOnTerminate := True;
  FMarkdown := AMarkdown;
  FRequestID := ARequestID;
  FEngine := AEngine;
  FHeaders := nil;
end;

destructor TConversionThread.Destroy;
begin
  // Decrementamos el contador de tareas atómicamente cuando el hilo realmente muere
  TInterlocked.Decrement(Form1.FActiveTaskCount);
  FHeaders.Free;
  inherited Destroy;
end;

{$IFDEF MSWINDOWS}
procedure ExecuteScript(doc: IHTMLDocument2;script: string; language:string);
begin
  if doc<>nil then
  begin
    if doc.parentWindow<>nil then
     doc.parentWindow.execScript(script,olevariant(language));

  end;
end;

function GetElementById(const Doc: IDispatch; const Id: string): IDispatch;
var
  Document: IHTMLDocument2;     // IHTMLDocument2 interface of Doc
  Body: IHTMLElement2;          // document body element
  Tags: IHTMLElementCollection; // all tags in document body
  Tag: IHTMLElement;            // a tag in document body
  I: Integer;                   // loops thru tags in document body
begin
  Result := nil;
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  // Get all tags in body element ('*' => any tag name)
  Tags := Body.getElementsByTagName('*');
  // Scan through all tags in body
  for I := 0 to Pred(Tags.length) do
  begin
    // Get reference to a tag
    Tag := Tags.item(I, EmptyParam) as IHTMLElement;
    // Check tag's id and return it if id matches
    if AnsiSameText(Tag.id, Id) then
    begin
      Result := Tag;
      Break;
    end;
  end;
end;
{$ENDIF}

procedure TForm1.About1Click(Sender: TObject);
begin
//  ShellAbout(Handle, 'MDPad', 'MDPad v1.1 beta'#13'Written by vhanla - http://apps.codigobit.info', Application.Icon.Handle);
  if FileExists(ExtractFilePath(ParamStr(0))+'Readme.md') then
  begin
    if MessageDlg(ABOUTMDPAD+#13#13'Want to read more about?',mtInformation, mbYesNo, 0) = mrYes then
      OpenMDFile(ExtractFilePath(ParamStr(0))+'Readme.md');
  end
  else
    MessageDlg(ABOUTMDPAD,mtInformation, [mbOK], 0);
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  if Length(BCEditor1.TextSelected) > 0 then
    BCEditor1.DoCommand(cCommand_ClipboardCopy, TATCommandInvoke.MenuMain);
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  if Length(BCEditor1.TextSelected) > 0 then
    BCEditor1.DoCommand(cCommand_ClipboardCut, TATCommandInvoke.MenuMain);
end;

procedure TForm1.EditorandResult1Click(Sender: TObject);
var
prevwas: boolean;
prevwrdwrp: boolean;
begin
  prevwas:=EditorandResult1.Checked;
  tmrHiddenElements.Enabled:=True;
  Editoronly1.Checked:=False;
  Resultonly1.Checked:=False;
  EditorandResult1.Checked:=True;

  // let's disable wordwrap first, otherwise BCEditor will raise error
  // it might have to do with resizing width while wordwrap, weird
  prevwrdwrp := BCEditor1.OptWrapIndented;
  if prevwrdwrp then
    BCEditor1.OptWrapIndented := False;

  //let's use a variable to keep the position
//  Memo1.Width:=ClientWidth div 2;
//  WebBrowser1.Width:=ClientWidth div 2;
  BCEditor1.Width:=Trunc(ViewersRatio/100*ClientWidth);

  // Editor and viewer side by side with Splitter1 between them; the viewer is
  // the alClient control, so it takes whatever the panes on the left leave.
  DisableAlign;
  try
    BCEditor1.Visible:=True;
    BCEditor1.Align:=alLeft;

    ActivePreview.Visible:=True;
    ActivePreview.Align:=alClient;
    Splitter1.Visible:=True;
    Splitter1.Enabled:=True;

    ArrangePanes;
  finally
    EnableAlign;
  end;

  try
  if not prevwas then
    BCEditor1.SetFocus;
  except

  end;

  if prevwrdwrp then
    BCEditor1.OptWrapIndented:= prevwrdwrp;
end;

procedure TForm1.Editoronly1Click(Sender: TObject);
begin
  tmrHiddenElements.Enabled:=False;
  Editoronly1.Checked:=True;
  Resultonly1.Checked:=False;
  EditorandResult1.Checked:=False;

  // The editor takes everything the tree leaves. Splitter1 only divides the
  // editor from the viewer: with no viewer on screen it is visible but useless,
  // and Visible is what takes it out of the layout (Enabled does not).
  DisableAlign;
  try
    ActivePreview.Visible:=False;
    ActivePreview.Align:=alNone;

    BCEditor1.Visible:=True;
    BCEditor1.Align:=alClient;

    Splitter1.Visible:=False;
    Splitter1.Enabled:=False;

    ArrangePanes;
  finally
    EnableAlign;
  end;

  //focus
  BCEditor1.SetFocus;
end;

procedure TForm1.Registerfilestoopenwith1Click(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  r: TRegistry;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  r:=TRegistry.Create;
  try
    r.RootKey:=HKEY_CURRENT_USER;
    //first let's register the files
    if r.OpenKey('\Software\Classes\.md',true) then
    begin
      r.WriteString('','MDPadFile');
      r.WriteString('Content Type','text/plain');
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\.mkd',true) then
    begin
      r.WriteString('','MDPadFile');
      r.WriteString('Content Type','text/plain');
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\.markdown',true) then
    begin
      r.WriteString('','MDPadFile');
      r.WriteString('Content Type','text/plain');
      r.CloseKey;
    end;
    //now let's create the file handler
    if r.OpenKey('\Software\Classes\MDPadFile',true) then
    begin
      r.WriteString('','Mark Down Text');
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\MDPadFile\DefaultIcon',true) then
    begin
      r.WriteString('',pchar(ExtractFilePath(ParamStr(0))+ExtractFileName(ParamStr(0))+',0'));
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\MDPadFile\shell',true) then
    begin
      r.WriteString('','Open');
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\MDPadFile\shell\Open',true) then
    begin
      r.WriteString('','Open');
      r.CloseKey;
    end;
    if r.OpenKey('\Software\Classes\MDPadFile\shell\Open\command',true) then
    begin
      r.WriteString('',pchar('"'+ExtractFilePath(ParamStr(0))+ExtractFileName(ParamStr(0))+'" "%1"'));
      r.CloseKey;
    end;
  finally
    r.Free;
  end;
  {$ENDIF}
end;

procedure TForm1.Resultonly1Click(Sender: TObject);
begin
  tmrHiddenElements.Enabled:=True;
  Editoronly1.Checked:=False;
  Resultonly1.Checked:=True;
  EditorandResult1.Checked:=False;

  // The viewer takes everything the tree leaves (see Editoronly1Click, same
  // single-pane arrangement on the other side).
  DisableAlign;
  try
    BCEditor1.Visible:=False;
    BCEditor1.Align:=alNone;

    ActivePreview.Visible:=True;
    ActivePreview.Align:=alClient;

    Splitter1.Visible:=False;
    Splitter1.Enabled:=False;

    ArrangePanes;
  finally
    EnableAlign;
  end;

  {$IFDEF MSWINDOWS}
  //focus (IE ActiveX needs explicit UI activation)
  //good tricks at http://stackoverflow.com/a/918869/537347
  // i guess they copied from here http://www.swissdelphicenter.ch/torry/showcode.php?id=1940
  if UsingIE and Assigned(Browser) then
  with Browser.ComServer do
  if Document <> nil then
  with Application as IOleObject do
  DoVerb(OLEIVERB_UIACTIVATE, nil, BrowserContainer, 0, Handle, GetClientRect);
  {$ENDIF}

end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if (CurrentFile <> '') and (FileExists(CurrentFile)) then
  begin
    BCEditor1.SaveToFile(CurrentFile);
    textBuffer:=BCEditor1.Text;
    if Tryingtoclose then
    close;
  end
  else begin
    //save as
    Saveas1Click(Sender);
  end;
end;

procedure TForm1.Saveas1Click(Sender: TObject);
begin
  //save as
  begin
    //this is a new edition
    with SaveDialog1 do
    begin
      Filter:='MarkDown files|*.md;*.mkd;*.markdown|*.*|*.*';
      if Execute then
      begin
        //chosen a filename

        //but let's make sure the extensions is the correct one
//        ShowMessage(ExtractFileExt(FileName));
        if (ExtractFileExt(FileName) <>'.md')
        and (ExtractFileExt(FileName) <>'.mkd')
        and (ExtractFileExt(FileName) <>'.markdown')then
        FileName:=FileName+'.md';

        if FileExists(FileName) then
        if MessageDlg('Overwrite existing file?',mtConfirmation,[mbyes,mbno],0)=mrNo then
        exit;
        //let's overwrite all
        BCEditor1.SaveToFile(FileName);
        CurrentFile:=FileName;
        Caption:='MDPad - '+FileName;
        AddToMRU(FileName);
        if Assigned(Adapter) then
          Adapter.Lexer := LexerForCurrentFile;
        textBuffer:=BCEditor1.Text;
        if Tryingtoclose then
        close;
      end;
    end;
  end

end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  //TMemo(Memo1).SelectAll;
  //TBCEditor(BCEditor1).SelectAll;
  BCEditor1.DoSelect_All;
end;

procedure TForm1.Splitter1Moved(Sender: TObject);
begin
  ViewersRatio:=Trunc(BCEditor1.Width/ClientWidth*100);
end;

procedure TForm1.Statusbar2Click(Sender: TObject);
begin
StatusBar2.Checked:= not Statusbar2.Checked;
StatusBar1.Visible:=Statusbar2.Checked;
SaveINI;
end;

// View > Table of contents. Hiding the tree takes it (and the splitter that
// sizes it) out of the layout and stops the fill that every render used to
// start, so a hidden tree costs nothing until it is shown again -- then the
// contents are built once, from whatever headings the current document has.
procedure TForm1.mnuViewTreeClick(Sender: TObject);
begin
  ApplyTreeVisible(not FTreeVisible);
  SaveINI;
end;

procedure TForm1.ApplyTreeVisible(AVisible: Boolean);
begin
  FTreeVisible := AVisible;
  mnuViewTree.Checked := AVisible;
  if Tree.Visible = AVisible then
  begin
    // Already in place (the startup call, or the same pick twice): only the
    // contents can be stale, and only when the tree is (or is being) shown.
    if AVisible then
      RefreshTree;
    Exit;
  end;

  // Both controls are alLeft: Visible is what takes them out of the align pass
  // (Enabled would leave them eating their width). ArrangePanes keeps the
  // order, and the viewer -- the alClient pane -- absorbs the freed space.
  DisableAlign;
  try
    Tree.Visible := AVisible;
    Splitter2.Visible := AVisible;
    ArrangePanes;
  finally
    EnableAlign;
  end;

  if AVisible then
    RefreshTree;
end;

procedure _OnTreeDuplicateNode(ANode: TTreeNode; const AFileName: string); forward;

// Fills the tree with whatever this document needs: EControl's own tree for the
// lexers that declare one, the table of contents UpdateTOC builds for markdown.
// Called when the tree is shown again, because while it was hidden every fill
// was skipped.
procedure TForm1.RefreshTree;
begin
  if not FTreeVisible then
    Exit;
  if (Adapter.Lexer <> nil) and not IsMarkdownLexer(Adapter.Lexer) then
  begin
    ClearTOC;
    Adapter.TreeFill(Tree, 1000, false, '?', @_OnTreeDuplicateNode);
    EditorChangeCaretPos(Self);
  end
  else
    // UpdateTOC leaves the selection on the caret's heading itself.
    UpdateTOC;
end;


procedure TForm1.UpdateEngineInMenu;
begin
  //lets flush all
  engMarkDownJS.Checked:=False;
  engMarked.Checked:=False;
  engPageDown.Checked:=False;
  engShowDown.Checked := False;
  engMarkdownit.Checked := False;
  engNative.Checked := False;
  engMarkdown4DNative.Checked := False;

  case SelectedEngine of
    mdPAGEDOWN: engPageDown.Checked := True;
    mdMARKDOWNJS: engMarkDownJS.Checked := True;
    mdMARKED: engMarked.Checked := True;
    mdSHOWDOWN: engShowDown.Checked := True;
    mdMARKDOWNIT: engMarkdownit.Checked := True;
    mdNATIVE : engNative.Checked := True;
    mdMARKDOWN4D: engMarkdown4DNative.Checked := True;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.ExportHTML1Click(Sender: TObject);
var
  RelHtml: string;
  HTMLText: TMemo;
  {$IFDEF MSWINDOWS}
  Rel: IHTMLElement;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    Rel:=GetElementById(Browser.ComServer.Document,'resultado') as IHTMLElement;
    if not Assigned(Rel) then
      Exit;
    RelHtml:=Rel.innerHTML;
  end
  else
  {$ENDIF}
    RelHtml:=PreviewHtmlBody;
  begin
    //let's save it to disk
    with SaveDialog1 do
    begin
      Filter:='HTML|*.html';
      if FileExists(CurrentFile) then
        FileName:=copy(ExtractFileName(CurrentFile),0,pos(ExtractFileExt(CurrentFile),ExtractFileName(CurrentFile)))+'html';

      if Execute then
      begin
        //we have the name now
        if FileExists(FileName) then
          if MessageDlg('Overwrite existing file?',mtConfirmation,[mbYes, mbNo],0)=mrNo then
            Exit;
        //let's continue saving the file
        HTMLText:=TMemo.Create(Self);
        try
          HTMLText.Text:='<!DOCTYPE html><html><head><title>MDPad Exported'
          +#13' File</title><meta http-equiv="X-UA-Compatible" content="IE=9" ><meta charset="utf-8">'+PreviewCSS+'<body><div id="readme"><div class="md">'
          +RelHtml+'</div></div><code>Created by <a href="http://apps.codigo'
          +'bit.info/2012/06/markdown-pad-markdown-textfile-editor.html" target="_blank">MDPad v1.1</a> Thanks to <a href="https://code.google.com/p/pagedown/" target="_blank">Pagedown</a></code></body></html>';

          //HTMLText.Lines.SaveToFile(FileName,TEncoding.UTF8);
          HTMLText.Lines.SaveToFile(FileName);
          //let's offer the change to open its folder
          if MessageDlg('Exported successfully'#13'Would you like to open its location folder?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
            OpenDocument(ExtractFilePath(FileName));
        finally
          HTMLText.Free;
        end;


      end;
    end;
  end;
end;

procedure TForm1.Find1Click(Sender: TObject);
begin
  FSelPos:=-1;
  FindDialog1.Execute;
  BCEditor1.SetFocus;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  S: UnicodeString;
  StartPos0, FoundPos, AbsOff: Integer;
  P1, P2: TPoint;
begin
  with TFindDialog(Sender) do
  begin
    {If the stored position is -1 this cannot be a find next. }
    if FSelPos < 0 then
      Options := Options - [frFindNext];

     { Figure out where to start the search and get the corresponding
       text from the editor. Offsets are 0-based ATSynEdit string offsets. }
    if frfindNext in Options then
    begin
      { This is a find next, start after the end of the last found word. }
      StartPos0 := FSelPos + Length(FindText);
      S := Copy(BCEditor1.Text, StartPos0 + 1, MaxInt);
    end
    else
    begin
      { This is a find first, start at the, well, start. }
      S := BCEditor1.Text;
      StartPos0 := 0;
    end;
    { Perform a global case-sensitive search for FindText in S }
    FoundPos := Pos(FindText, S);
    if FoundPos > 0 then
    begin
       { Found something, correct position for the location of the start
         of search. }
      AbsOff := StartPos0 + FoundPos - 1;
      FSelPos := AbsOff;
      P1 := BCEditor1.OffsetToCaretPos(AbsOff);
      P2 := BCEditor1.OffsetToCaretPos(AbsOff + Length(FindText));
      with BCEditor1.Carets[0] do
      begin
        PosX := P1.X; PosY := P1.Y;
        EndX := P2.X; EndY := P2.Y;
      end;
      BCEditor1.DoShowPos(P1, 0, 0, True, True, True);
      BCEditor1.SetFocus;
    end
    else
    begin
      { No joy, show a message. }
      if frfindNext in Options then
        S := Concat('There are no further occurences of "', FindText,
          '" in Editor.')
      else
        S := Concat('Could not find "', FindText, '" in Editor.');
      MessageDlg(S, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm1.Font1Click(Sender: TObject);
var
  OldFont: string;
begin
  // The font is one of the stored editor options now (it used to be reset to
  // Consolas on every start), so the pick goes through the record and is saved.
  FontDialog1.Font.Assign(BCEditor1.Font);
  if FontDialog1.Execute() then
  begin
    OldFont := FEditorOpts.FontName;
    FEditorOpts.FontName := FontDialog1.Font.Name;
    FEditorOpts.FontSize := FontDialog1.Font.Size;
    ApplyEditorOptions;
    // The previews' code font follows the editor's, and both the sheet and the
    // canvas theme are written by ApplyTheme: re-render so the new face is what
    // is on screen.
    if not SameText(FEditorOpts.FontName, OldFont) then
      ApplyTheme(True);
    SaveINI;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  confirm: Integer;
begin
  Tryingtoclose:=true;
  if textBuffer <> BCEditor1.Text then
  begin
    Action:=caNone;
    confirm := MessageDlg('Your document has been modified'#13'Do you want to save those changes?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
    if confirm = mrYes then
      Save1Click(sender)
    else if confirm = mrNo then
      Action:= caFree
    else if confirm = mrCancel then
    begin
      Tryingtoclose := False;
      Action:=caNone;
    end;
  end
  else
  begin
    Action:=caFree;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  feditor: string;
  st: TStringStream;
  mi, Sub: TMenuItem;
begin
  Application.OnActivate:=OnFocus;
  Caption := 'MDPad';

  BCEditor1 := TATSynEdit.Create(Self);
  BCEditor1.Parent := Self;
  BCEditor1.OnChange := BCEditor1Change;
  BCEditor1.OnKeyDown := BCEditor1KeyDown;
  BCEditor1.OnKeyUp := BCEditor1KeyUp;
  BCEditor1.OnChangeCaretPos := BCEditor1CaretChanged;
  BCEditor1.OptUnprintedVisible:=False;
  BCEditor1.OptRulerVisible:=False;
  BCEditor1.OnChangeCaretPos:=EditorChangeCaretPos;

  // EControl syntax highlighting + code tree (optional: needs lib.lxl next to the exe)
  Manager := TecSyntaxManager.Create(Self);
  feditor := ExtractFilePath(ParamStr(0))+'lib.lxl';
  if FileExists(feditor) then
    Manager.LoadFromFile(feditor);

  Adapter := TATAdapterEControl.Create(Self);
  // OnParseDone, but not OnParseBegin: the latter clears the tree on every
  // parse, which would wipe the table of contents. EControl's own tree only
  // exists for the lexers that ask for it (markdown is not one of them) -- see
  // AdapterParseDone and UpdateTOC.
  Adapter.OnParseDone := AdapterParseDone;
  Adapter.AddEditor(BCEditor1);
  Adapter.Lexer := Lexer_FindForFilename(Manager, CurrentFile);
  // The code tree doubles as the table of contents: a click on a heading goes
  // there in both panes.
  Tree.OnClick := TreeClick;

//  memo1.Visible:=false;
//////////////////  BCEditor1.ScrollBars:=ssBoth;
  BCEditor1.OptWrapIndented := True;
//  Form1.WindowProc:=ScrollWheel;
///  KeyPreview := True;
//  SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
  {$IFDEF MSWINDOWS}
  SetPriorityClass(GetCurrentProcess, $4000);//below normal al parecer mejor de IDLE
  {$ENDIF}

  //native editor context menu (ATSynEdit has no default popup)
  EditorPopup := TPopupMenu.Create(Self);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '&Undo'; mi.Tag := cCommand_Undo; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := 'Cu&t'; mi.Tag := cCommand_ClipboardCut; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '&Copy'; mi.Tag := cCommand_ClipboardCopy; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '&Paste'; mi.Tag := cCommand_ClipboardPaste; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '&Delete'; mi.Tag := cCommand_TextDeleteSelection; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := 'Select &All'; mi.Tag := cCommand_SelectAll; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; EditorPopup.Items.Add(mi);

  // Markdown formatting: the discoverable half of the shortcuts (the commands
  // themselves are MdExecute; the keys are in BCEditor1KeyDown). The menu shows
  // the shortcut, but the editor consumes the key first, so a command can never
  // run twice.
  Sub := TMenuItem.Create(EditorPopup);
  Sub.Caption := 'F&ormat';
  EditorPopup.Items.Add(Sub);
  AddMdMenuItem(Sub, '&Bold', mcBold, ShortCut(Ord('B'), [ssCtrl]));
  AddMdMenuItem(Sub, '&Italic', mcItalic, ShortCut(Ord('I'), [ssCtrl]));
  AddMdMenuItem(Sub, '&Strikethrough', mcStrike, ShortCut(Ord('X'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, 'Inline &code', mcCode, ShortCut(VK_OEM_3, [ssCtrl]));
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; Sub.Add(mi);
  AddMdMenuItem(Sub, '&Heading (cycle)', mcHeading, ShortCut(Ord('H'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, 'Code &block', mcCodeBlock, ShortCut(Ord('K'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, '&Quote', mcQuote, ShortCut(Ord('Q'), [ssCtrl, ssShift]));
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; Sub.Add(mi);
  AddMdMenuItem(Sub, '&Bullet list', mcList, ShortCut(Ord('U'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, '&Numbered list', mcOrdered, ShortCut(Ord('O'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, '&Task item', mcTask, ShortCut(Ord('T'), [ssCtrl, ssShift]));

  Sub := TMenuItem.Create(EditorPopup);
  Sub.Caption := '&Insert';
  EditorPopup.Items.Add(Sub);
  AddMdMenuItem(Sub, '&Link...', mcLink, ShortCut(Ord('K'), [ssCtrl]));
  AddMdMenuItem(Sub, '&Image...', mcImage, ShortCut(Ord('I'), [ssCtrl, ssShift]));
  AddMdMenuItem(Sub, '&Table...', mcTable, 0);
  AddMdMenuItem(Sub, '&Horizontal rule', mcRule, 0);

  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup);
  mi.Caption := 'Complete &word';
  mi.Tag := Ord(mcCompleteWord);
  mi.OnClick := MdCommandClick;
  mi.ShortCut := ShortCut(VK_SPACE, [ssCtrl]);
  EditorPopup.Items.Add(mi);

  BCEditor1.PopupMenu := EditorPopup;

  // The format bar, hidden until the saved option says otherwise (ApplyEditorOptions
  // runs right after LoadINI and shows it). Built before that, so the bar can take
  // its place in the align pass with the first paint.
  BuildFormatBar;

  // THtmlViewer preview, default on every platform (no JavaScript needed)
  PreviewHtml := THtmlViewer.Create(Self);
  PreviewHtml.Parent := Self;
  PreviewHtml.Align := alClient;
  PreviewHtml.DefFontName := 'Sans';
  PreviewHtml.OnHotSpotClick := PreviewHotSpotClick;
  PreviewBaseFontSize := PreviewHtml.DefFontSize;

  // Markdown4D preview: an alternative backend that parses the markdown and
  // draws it on a canvas. No HTML pipeline involved.
  PreviewMd4D := TMarkdownViewer.Create(Self);
  PreviewMd4D.Parent := Self;
  PreviewMd4D.Align := alClient;
  PreviewMd4D.Visible := False;
  PreviewMd4D.OnLinkClick := PreviewLinkClick;
  // Its theme (the preset, or Md4dTheme.json, plus the editor's code font) is
  // built and owned by ApplyCanvasTheme, which FormCreate calls right away.

  {$IFDEF MSWINDOWS}
  // Legacy IE WebBrowser instance, only for the JavaScript engines
  BrowserContainer := TActiveXContainer.Create(Self);
  Browser := TWebBrowser.Create(Self);
  //Browser.SetParentComponent(BrowserContainer);
  Browser.OnBeforeNavigate2 := WebBrowser1BeforeNavigate2;
  Browser.OnDocumentComplete := WebBrowser1DocumentComplete;
  BrowserContainer.ComServer := Browser.ComServer;
  BrowserContainer.Active := True;
  BrowserContainer.Align := alClient;


  //disable ugly sounds on internet explorer
  CoInternetSetFeatureEnabled(FEATURE_DISABLE_NAVIGATION_SOUNDS, SET_FEATURE_ON_PROCESS, True);
  //WebBrowser1.Silent := True;
  Browser.ComServer.Set_Silent(True);

  //let's load the mdeditor\index.html file
  {feditor:= ExtractFilePath(ParamStr(0))+'somdeditor\index.html';
  if FileExists(feditor) then
    feditor:='file:///'+StringReplace(feditor,'\','/',[rfReplaceAll]);
    WebBrowser1.Navigate(feditor);}//good offline tester
  //WBLoadHTML(WebBrowser1, PAGEDOWN);

  // we need to load the engine prior to update its markdown generated contens
  WBLoadHTML(Browser, '');
  {$ELSE}
  //no IE outside Windows: JS engines unavailable, file association is Windows-only
  engPageDown.Visible := False;
  engMarkDownJS.Visible := False;
  engMarked.Visible := False;
  engShowDown.Visible := False;
  engMarkdownit.Visible := False;
  Registerfilestoopenwith1.Visible := False;
  {$ENDIF}

  //
  ViewersRatio:= Trunc(BCEditor1.Width / ClientWidth * 100); //averiguamos el porcentaje que vale lo que ocupa memo1.width

  Constraints.MinHeight:=200;
  Constraints.MinWidth:=300;

  //restore zoom of twebbrowser
//  WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.0;

//initialize position of our trackbar
  TrackBar1.Left:=ClientWidth-TrackBar1.Width;
  TrackBar1.Top:=ClientHeight-TrackBar1.Height;
//  TrackBar1.Position:=2;
  TrackBar1.Visible:=False;

  Application.Title:='MDPad';

  BCEditor1.Font.Name:='Consolas';
  BCEditor1.Font.Size:=11;
  BCEditor1.OptWrapIndented:= True;

  // Recent files are loaded by LoadINI, which also builds the submenu.
  FMRU := TStringList.Create;
  FMRULimit := 10;
  // A settings.ini without the key keeps this, the sensible default: a list
  // item continues itself when Enter is pressed.
  FEditorOpts.SmartEnter := True;
  // The tree is the table of contents: on unless the last session hid it.
  FTreeVisible := True;

  LoadINI;

  // Push the options LoadINI read into the editor before the first paint, and
  // bring the Editor menu's checks in line with them.
  ApplyEditorOptions;
  UpdateEditorMenuChecks;

  // Paint the editor and every preview with the picked theme before anything
  // is loaded, so the first document is already rendered into the right sheet
  // (the preview is not reloaded here: it is still empty).
  ApplyTheme(False);
  // The saved syntax switch decides whether the lexer is attached at all: with
  // it off the editor stays plain text and no parse happens on keypress.
  ApplySyntaxEnabled;

  textBuffer := BCEditor1.Text;
  // let's load the configured engine
  LoadEngine;
  //apply the saved view mode (editor/result layout) to the active preview
  ApplyViewMode;
  // View > Table of contents, after the view mode has laid the panes out: a
  // hidden tree (and Splitter2) only has to be taken out of that layout.
  ApplyTreeVisible(FTreeVisible);

  CurrentFile:=''; //none
  {$IFDEF MSWINDOWS}
  //let's open with explorer (IE path resolves it on DocumentComplete,
  //THtmlViewer path loads synchronously so open it right away)
  if UsingIE then
  begin
    if ParamCount>0 then
      ReadingFromExplorer:=True
    else
      ReadingFromExplorer:=False;
  end
  else
  {$ENDIF}
  begin
    ReadingFromExplorer:=False;
    if ParamCount>0 then
    begin
      OpenMDFile(ParamStr(1));
      AddToMRU(ParamStr(1));
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Settings first: the picks are already on disk (TogglePreview/ToggleEngine
  // save them), but the rest must not depend on a worker deciding to stop.
  SaveINI;
  // Avisar a los workers y esperarlos: su Synchronize necesita que el main
  // bombee la cola, y SyncUpdateUI sale temprano gracias a FShuttingDown.
  // Sin esto, un worker vivo tocaría PreviewHtml/Form1 ya liberados -> GPF.
  FShuttingDown := True;
  while FActiveTaskCount > 0 do
  begin
    CheckSynchronize(0);
    Sleep(5);
  end;
  FreeAndNil(FHeaders);
  ClearTOC;
  FreeAndNil(FMRU);
  BCEditor1.Text := '';
  BCEditor1.Free;
  {$IFDEF MSWINDOWS}
  FreeAndNil(Browser);
  //Browser.Free;
  BrowserContainer.Free;
  {$ENDIF}
  PreviewHtml.Free;
  PreviewMd4D.Free;
  // The viewer only borrows the theme it was given (SetTheme never frees it),
  // so the one ApplyCanvasTheme built is MDPad's, preset or Md4dTheme.json.
  FreeAndNil(FCanvasTheme);
end;

//thanks to http://beensoft.blogspot.com/2007/10/fooling-around-with-twebbrowser-4.html
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {$IFDEF MSWINDOWS}
  if Key = #13 then
  begin
    Key := #0;
    keybd_event(VK_LCONTROL,0,0,0); //Ctrl key down
    keybd_event(Ord('M'), MapVirtualKey(Ord('M'),0),0,0); // m key is down
    //let's release those virtual keystrokes
    keybd_event(Ord('M'), MapVirtualKey(Ord('M'),0),KEYEVENTF_KEYUP,0);
    keybd_event(VK_LCONTROL,0,KEYEVENTF_KEYUP,0); //Ctrl key up
    keybd_event(VK_CANCEL, 0,0,0);
  end;
//  if Key = #116 then
//    WebBrowser1.Refresh;
  {$ENDIF}
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {$IFDEF MSWINDOWS}
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0)
  {$ENDIF}
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if EditorandResult1.Checked then
    EditorandResult1Click(Sender);
  // The preview is laid out again at its new width, so every heading sits at a
  // different Y: the anchor table has to be measured once more.
  InvalidateHtmlAnchors;
  TrackBar1.Left:=ClientWidth-TrackBar1.Width-32;
  TrackBar1.Top:=ClientHeight-TrackBar1.Height;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if BCEditor1.Visible then
  BCEditor1.SetFocus;
  TrackBar1.Position:=TrackBar1_Position;

end;

procedure TForm1.FullScreen1Click(Sender: TObject);
begin
  ToggleFullScreen;
end;

procedure TForm1.Helponline1Click(Sender: TObject);
begin
  OpenURL('http://daringfireball.net/projects/markdown/syntax');
end;

procedure TForm1.tmrHiddenElementsTimer(Sender: TObject);
var
  p:TPoint;
begin
  try
    p:=ScreenToClient(mouse.CursorPos);
    if (p.X > TrackBar1.Left) and (p.X< TrackBar1.Left+TrackBar1.Width)
    and (p.Y > TrackBar1.Top) and (p.Y< TrackBar1.Top+TrackBar1.Height)
    then
      TrackBar1.Visible:=True
    else
      TrackBar1.Visible:=False;
      //StatusBar1.Panels[0].Text:=IntToStr(TScrollbar(Memo1).Position);
  except

  end;

end;

procedure TForm1.tmrKeyEventTimer(Sender: TObject);
begin
  if TDelay <= 1 then
  begin
    UpdateResult;
    tmrKeyEvent.Enabled:=False;
    TDelay:=DELAYTIME;
  end
  else dec(TDelay);
end;

procedure TForm1.ToggleFullScreen;
begin
  { TODO: Improve restoring size after fullscreen }
  if BorderStyle = bsNone then
  begin
    //restore
    FullScreen1.Checked:=False;
    {$IFDEF MSWINDOWS}
    if UsingIE then
    begin
      BrowserContainer.Active := False;
      BorderStyle:=bsSizeable;
      BrowserContainer.Active := True;
      WBLoadHTML(Browser, '');
      LoadEngine;
      ReloadingEngine := True;
    end
    else
    {$ENDIF}
      BorderStyle:=bsSizeable;
    { TODO: Restore last position of WebViewer after refresh }
    if PrevWindowState = wsMaximized then
      //Perform(WM_SYSCOMMAND, SC_MAXIMIZE,0)
      WindowState := wsMaximized
    else
      WindowState := wsNormal;
  end
  else
  begin
    //fulscreen
    FullScreen1.Checked:=True;
    {$IFDEF MSWINDOWS}
    if UsingIE then
    begin
      BrowserContainer.Active := False;
      BorderStyle:=bsNone;
      BrowserContainer.Active := True;
      WBLoadHTML(Browser, '');
      LoadEngine;
      ReloadingEngine := True;
    end
    else
    {$ENDIF}
      BorderStyle:=bsNone;
    PrevWindowState:=WindowState;
    if WindowState = wsMaximized then
      WindowState := wsNormal;
    Sleep(10);
    //Perform(WM_SYSCOMMAND, SC_MAXIMIZE,0);
    WindowState := wsMaximized;
  end;
end;

procedure TForm1.OpenMDFile(const fn: string);
{$IFDEF MSWINDOWS}
var
  Elem: IHTMLElement;
{$ENDIF}
//  script: string;
///  docs: IHTMLDocument3;
///  pos1,pos2:integer;
begin
  {$IFDEF MSWINDOWS}
  // let's make sure the engine is fully loaded before loading content into it
  if UsingIE then
  begin
    Elem:= GetElementById(Browser.ComServer.Document,'resultado') as IHTMLElement;
    if not Assigned(elem) then
      Exit;
  end;
  {$ENDIF}
  begin
    //prevent to open a file if previous was not saved

//    docs:=WebBrowser1.Document as IHTMLDocument3;
//        memo2.Text:=docs.documentElement.innerText;
//        pos1:=pos(copy(textBuffer,0,10),memo2.Text);
//        pos2:=pos(copy(textBuffer,StrLen(pchar(textBuffer))-10),memo2.Text);
//        memo2.Text:=copy(docs.documentElement.innerText,pos1,pos2-pos1);
//      if memo1.Text <> textBuffer then
//        ShowMessage('Archivo cambiado');
    //lets finish it

    //BCEditor1.Lines.LoadFromFile(fn);
    BCEditor1.LoadFromFile(fn, []);
//        if (Length(BCEditor1.Text)>10000)
    if Length(BCEditor1.Text) > 10000
    then needtodelay:=true
    else needtodelay:=false;

    textBuffer:=BCEditor1.Text; //buffered to see changes
//        memo1.Text:=StringReplace(memo1.Text,'```','    ',[rfReplaceAll]);
    CurrentFile:=fn;
    Caption := 'MDPad - '+fn;
    if Assigned(Adapter) then
    begin
      Adapter.Lexer := LexerForCurrentFile;
      // Loading a file raises no change event for the adapter to follow, so it
      // has to be told which buffer it is now looking at.
      BCEditor1.DoEventChange(0, False);
    end;
    UpdateResult; //update the rendering
  end;

end;

procedure TForm1.OnFocus(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  //ShowMessage('ac');
  if UsingIE and Assigned(BrowserContainer)
  and (BrowserContainer.Visible) and not (BCEditor1.Visible) then
    with Browser.ComServer do
      if Document <> nil then
        with Application as IOleObject do
          DoVerb(OLEIVERB_UIACTIVATE, nil, BrowserContainer, 0, Handle, GetClientRect);
  {$ENDIF}
end;

procedure TForm1.UpdateResult;
{$IFDEF MSWINDOWS}
var
  Elem: IHTMLElement;
{$ENDIF}
begin
{  if (Length(Memo1.Text)>10000)
  and not WebBrowser1.Visible then
  exit;}

  // The preview resolves <img src> against the document it came from.
  ApplyPreviewBaseFolder;

  {$IFDEF MSWINDOWS}
  // with a javascript engine we only update the text in the loaded engine
  if UsingIE then
  begin
    // then continue with the update
    Elem:= GetElementById(Browser.ComServer.Document,'wmd-input') as IHTMLElement;
    if Assigned(Elem) then
    begin
      Elem.innerText:=BCEditor1.Text;
      ExecuteScript(Browser.ComServer.Document as IHTMLDocument2,'update();','javascript');
    end;
    Exit;
  end;
  {$ENDIF}

  // Markdown4D parses incrementally on its own and marshals SetText to the
  // main thread, so there is no worker and no HTML step here.
  if UsingMarkdown4D then
  begin
    PreviewMd4D.Text := BCEditor1.Text;
    // SetText laid the document out again, so the viewer's outline describes
    // what is on screen now: that is where the table of contents comes from
    // here (there is no worker on this path).
    AdoptCanvasOutline;
    // Laying the document out again parks the viewer at the top, and it also
    // moved every line: put the view back where the editor is, at once, so the
    // preview does not jump on every keystroke.
    if Synceditwithpreview1.Checked then
    begin
      SyncEditorToPreview;
      InvalidateScrollSync;
    end;
    Exit;
  end;

  // THtmlViewer has no scripting: la conversión corre en un worker thread
  // y SyncUpdateUI refresca el preview al terminar (ver PerformConversion).
  // No se toca el preview aquí: conserva el HTML anterior sin parpadeos.
  PerformConversion;
end;

//let's find out events for mouse scrolling
{procedure TForm1.ScrollWheel(var Msg: TMessage);
var
  cant: short;
  i: integer;
begin
  //
  if Msg.Msg=WM_MOUSEWHEEL then
  begin
    cant:=HiWord(Msg.WParam);
    cant:=cant div 120;
    for I := 1 to abs(cant) do begin
      if (cant>0) then
//       memo1.ScaleBy(0,1);
      SendMessage(BCEditor1.Handle, EM_SETSEL, 0,0);
//      memo1.Lines.
    end;
  end
  else Comodin(Form1).WndProc(msg);
end;}

procedure TForm1.Synceditwithpreview1Click(Sender: TObject);
begin
  Synceditwithpreview1.Checked:=not Synceditwithpreview1.Checked;
  tmrScrollSyncer.Enabled:=Synceditwithpreview1.Checked;
  if Synceditwithpreview1.Checked then
  begin
    // Starting to follow: take the preview to the editor right away instead of
    // at the next tick, and leave the editor as the reference (the preview may
    // not be laid out yet, and then the tick redoes it).
    InvalidateScrollSync;
    SyncEditorToPreview;
    InvalidateScrollSync;
  end;
  // The pick is on disk at once, like the theme/backend/engine ones: the save
  // at FormDestroy never runs if the process is killed or hangs.
  SaveINI;
end;

procedure TForm1.SyncScrolling;
var
  refpos: integer;
begin
  //sync scrolling bars according to its relative %age position
//  Memo1.ScrollBy();
end;

procedure TForm1.SaveINI;
var
ini: TIniFile;
i: Integer;
begin
  ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
    try
      ini.WriteString('MDPad','fontname',BCEditor1.Font.Name);
      ini.WriteInteger('MDPad','fontsize',BCEditor1.Font.Size);

      ini.WriteInteger('MDPad','fontcolor',BCEditor1.Font.Color);

      ini.WriteBool('MDPad','sync',Synceditwithpreview1.Checked);
      ini.WriteBool('MDPad','delay',Waitafewsecondsbeforeupdatingthepreview1.Checked);
      ini.WriteBool('MDPad','statusbar',Statusbar2.Checked);
      ini.WriteBool('MDPad','tree',FTreeVisible);
      ini.WriteBool('MDPad','wordwrap',Wordwrap1.Checked);

      ini.WriteInteger('Window','editorposition',ViewersRatio);
      // Splitter2 resizes Tree; its Width is where the user left the splitter.
      ini.WriteInteger('Window','treeposition',Tree.Width);
      if WindowState=wsNormal then
      begin
      ini.WriteInteger('Window','width',Width);
      ini.WriteInteger('Window','height',Height);
      end;
      ini.WriteInteger('Preview','zoom',TrackBar1.Position);

      ini.WriteInteger('MDPad', 'engine', SelectedEngine);
      ini.WriteInteger('MDPad', 'preview', SelectedPreview);

      ini.WriteBool('MDPad', 'syntaxenabled', mnuSyntax.Checked);
      ini.WriteString('MDPad', 'theme', ThemeToName(SelectedTheme));
      ini.WriteBool('MDPad', 'cssenabled', mnuCSS.Checked);
      ini.WriteBool('MDPad', 'remoteimages', Loadremoteimages1.Checked);

      if Assigned(FMRU) then
      begin
        ini.WriteInteger('Files', 'mrucount', FMRULimit);
        for i := 0 to FMRU.Count - 1 do
          ini.WriteString('Files', 'mru' + IntToStr(i), FMRU[i]);
        // Drop the keys the list no longer has, or a shortened list would come
        // back on the next start.
        for i := FMRU.Count to 29 do
          ini.DeleteKey('Files', 'mru' + IntToStr(i));
      end;

      SaveEditorOptions(ini);
    finally
      ini.Free;
    end;
end;

// True when the selected engine is one of the JavaScript ones: they need a real
// browser, so on Windows they force the IE backend (see UsingIE).
function TForm1.UsingJsEngine: Boolean;
begin
  Result := (SelectedEngine >= mdPAGEDOWN) and (SelectedEngine <= mdMARKDOWNIT);
end;

// True when the preview goes through the legacy IE ActiveX viewer
// (Windows only, and only for the JavaScript engines; THtmlViewer
// cannot run JavaScript, so it always uses the native engine).
function TForm1.UsingIE: Boolean;
begin
  {$IFDEF MSWINDOWS}
  // Picking a JS engine implies IE, whatever the selected preview backend is.
  Result := Assigned(Browser)
    and ((SelectedPreview = pvIE) or UsingJsEngine);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

// Markdown4D is the backend unless IE is on duty (IE wins on Windows).
function TForm1.UsingMarkdown4D: Boolean;
begin
  Result := (not UsingIE) and (SelectedPreview = pvMARKDOWN4D);
end;

// The preview control currently on duty (IE container, Markdown4D or THtmlViewer).
function TForm1.ActivePreview: TWinControl;
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
    Exit(BrowserContainer);
  {$ENDIF}
  if UsingMarkdown4D then
    Exit(PreviewMd4D);
  Result := PreviewHtml;
end;

// The HTML of the preview body, as Export HTML expects it. The Markdown4D
// backend never runs the HTML pipeline, so its body is rendered on demand by
// Markdown4D's own HTML renderer (which keeps the export consistent with what
// the native preview shows).
function TForm1.PreviewHtmlBody: string;
begin
  if UsingMarkdown4D then
    // The same pipeline the preview renders with, heading anchors included, so
    // an exported page is the page that was on screen (and its in-page links
    // resolve). Unsafe (raw HTML kept) because the canvas lays HtmlBlock nodes
    // out instead of hiding them.
    Result := Md4dPipeline.ToHtml(BCEditor1.Text)
  else
    Result := LastPreviewBody;
end;

// A document that names an image relative to itself expects it next to the
// document, not next to the MDPad binary or wherever the process was started
// from. Each preview takes the folder its own way: THtmlViewer through Base,
// the canvas viewer through the base URL of its image settings (which also
// drops the images that were resolved against the previous one).
procedure TForm1.ApplyPreviewBaseFolder;
var
  Folder: string;
begin
  Folder := ExtractFileDir(CurrentFile);
  PreviewHtml.Base := Folder;
  PreviewMd4D.Images.BaseUrl := Folder;
end;

// Remote images are the one thing a document can have the preview fetch from
// the network (the HTML preview never does). The canvas viewer has a switch
// for them, so MDPad exposes it; Reload is passed as False when the setting is
// only being restored at startup and there is no document on screen to refresh.
procedure TForm1.ApplyRemoteImagesSetting(Reload: Boolean);
begin
  PreviewMd4D.Images.AllowRemote := Loadremoteimages1.Checked;
  if Reload then
    // Images the old setting refused, or loaded, only change when the document
    // asks for them again.
    PreviewMd4D.ReloadImages;
end;

// The table of contents, then the editor, then the viewer, with a splitter
// between each pair. LCL lays the alLeft controls out from left to right in the
// order of their current Left, and setting an Align realigns on the spot, so
// the lefts written here decide the order of the next pass. The editor is
// created at runtime with Left 0: without this it is laid out before the tree
// and the tree ends up on the right of it.
procedure TForm1.ArrangePanes;
begin
  Tree.Left:=0;
  Splitter2.Left:=Tree.Left+Tree.Width;
  BCEditor1.Left:=Splitter2.Left+Splitter2.Width;
  Splitter1.Left:=BCEditor1.Left+BCEditor1.Width;
end;

// Re-applies the checked view mode (editor/result/both) to the active
// preview. Needed after an engine switch changes the preview control,
// and at startup to give both panes a sane initial layout.
procedure TForm1.ApplyViewMode;
begin
  {$IFDEF MSWINDOWS}
  if Assigned(BrowserContainer) then
    BrowserContainer.Visible := False;
  {$ENDIF}
  PreviewHtml.Visible := False;
  PreviewMd4D.Visible := False;
  if EditorandResult1.Checked then
    EditorandResult1Click(Self)
  else if Editoronly1.Checked then
    Editoronly1Click(Self)
  else if Resultonly1.Checked then
    Resultonly1Click(Self);
  // Another control is on duty now: its scroll position has nothing to do with
  // the one just recorded, so the editor drives the next sync.
  InvalidateScrollSync;
  InvalidateHtmlAnchors;
  //Print Preview needs a scriptable DOM, only the IE viewer has one
  PrintPreview1.Enabled := UsingIE;
end;

procedure TForm1.UpdateCaretStatus;
begin
  if StatusBar1.Visible and Assigned(BCEditor1) and (BCEditor1.Carets.Count > 0) then
  begin
    StatusBar1.Panels[1].Text := 'Line: '
      + IntToStr(BCEditor1.Carets[0].PosY + 1)
      + ', Column: '
      + IntToStr(BCEditor1.Carets[0].PosX + 1);
  end;
end;

procedure TForm1.EditorPopupClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    BCEditor1.DoCommand(TMenuItem(Sender).Tag, TATCommandInvoke.MenuMain);
end;

// THtmlViewer links: open http(s) targets in the external browser,
// keep in-page anchors (#...) working inside the preview.
procedure TForm1.PreviewHotSpotClick(Sender: TObject; const SRC: ThtString; var Handled: Boolean);
begin
  if (Pos('http://', SRC) = 1) or (Pos('https://', SRC) = 1) then
  begin
    OpenURL(SRC);
    Handled := True;
  end;
end;

// Markdown4D links. In-page anchors are already resolved by the viewer itself
// (it scrolls to them), so only external targets arrive here. The viewer is
// compiled with UnicodeString on, hence the explicit URL type.
procedure TForm1.PreviewLinkClick(const Sender: TObject; const Url: UnicodeString);
begin
  if (Pos('http://', Url) = 1) or (Pos('https://', Url) = 1) then
    OpenURL(UTF8Encode(Url));
end;

// This will load the selected MarkDownEngin
// Incase is native, we still need to load the styles and container
// in order to let the webbrowser detect ondocumentcomplete to start loading
// its markdwn content over it
// it will enable the selectedEngine and pass a default string if desired so
procedure TForm1.LoadEngine(const DefaultText: string = '');
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    case SelectedEngine of
      // in common engines, the default text will in hidden textarea
      mdPAGEDOWN: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + PAGEDOWN + FOOTER);
      mdMARKDOWNJS: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKDOWNJS + FOOTER);
      mdMARKED: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKED + FOOTER);
      mdSHOWDOWN: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + SHOWDOWN + FOOTER);
      mdMARKDOWNIT: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKDOWNIT + FOOTER);
    else
      WBLoadHTML(Browser, HEADER + PreviewCSS + OPENCONTAINER + DefaultText + CLOSECONTAINER + FOOTER);
    end;
    Exit;
  end;
  {$ENDIF}
  // Markdown4D parses the markdown itself: there is no HTML document to load
  // and no engine to install, just the source to hand over.
  if UsingMarkdown4D then
  begin
    PreviewMd4D.Text := DefaultText;
    AdoptCanvasOutline;
    InvalidateScrollSync;
    Exit;
  end;
  // THtmlViewer path (default everywhere): synchronous full-document load,
  // the native engine renders the markdown on UpdateResult
  PreviewHtml.LoadFromString(HEADER + PreviewCSS + OPENCONTAINER + DefaultText + CLOSECONTAINER + FOOTER);
  // LoadEngine runs on a new document (or a backend switch), so the heading list
  // and the anchor table of the previous one no longer describe the preview, and
  // the table of contents is rebuilt from whatever the new engine renders.
  AdoptHeaders(nil);
  UpdateTOC;
  InvalidateScrollSync;
end;

procedure TForm1.EditorChangeCaretPos(Sender: TObject);
var
  NLine: integer;
begin
  // Hidden tree: there is no node to select, and the walk over its items is
  // part of what the toggle saves.
  if FTreeVisible and (BCEditor1.Carets.Count>0) then
    with BCEditor1.Carets[0] do
      CodetreeSelectItemForPosition(Tree, PosX, PosY, NLine);
end;

procedure _OnTreeDuplicateNode(ANode: TTreeNode; const AFileName: string);
begin
  //empty
end;

// EControl fills the tree only for the lexers whose rules ask for it (Bash, C,
// PHP): its Markdown lexer asks for none, so for a markdown document the tree is
// the table of contents UpdateTOC builds from the rendered headings instead.
procedure TForm1.AdapterParseDone(Sender: TObject; ATime: integer);
begin
  if Adapter.Lexer = nil then
    // Highlighting is off (Preferences > "Enable Syntax highlighter"): there is
    // no parse to fill anything from, and TreeFill needs a client.
    Exit;
  // The tree toggle: while the tree is hidden there is nothing to fill, and
  // the whole point of hiding it is not to spend the time. RefreshTree builds
  // the contents once, when it is shown again.
  if not FTreeVisible then
    Exit;
  if IsMarkdownLexer(Adapter.Lexer) then
    UpdateTOC
  else
  begin
    // Free the ranges of the previous fill before EControl drops those nodes.
    ClearTOC;
    adapter.TreeFill(Tree, 1000, false, '?', @_OnTreeDuplicateNode);
  end;
  EditorChangeCaretPos(Self);
end;

// LCL does not own what a node points at, so the ranges MDPad creates have to
// go before the nodes that refer to them.
procedure TForm1.ClearTOC;
var
  Index: Integer;
begin
  for Index := 0 to Tree.Items.Count - 1 do
    if (Tree.Items[Index].Data <> nil)
    and (TObject(Tree.Items[Index].Data) is TATRangeInCodeTree) then
      TObject(Tree.Items[Index].Data).Free;
  Tree.Items.Clear;
end;

// A render happens on every keystroke, and rebuilding the tree each time would
// throw away where the user scrolled it: the headings are compared first.
function TForm1.TocMatchesHeaders: Boolean;
var
  Index: Integer;
begin
  Result := False;
  if (FHeaders = nil) or (Tree.Items.Count <> FHeaders.Count) then
    Exit;
  for Index := 0 to FHeaders.Count - 1 do
  begin
    if (Tree.Items[Index].Text <> FHeaders[Index].Caption)
    or (Tree.Items[Index].Data = nil)
    or not (TObject(Tree.Items[Index].Data) is TATRangeInCodeTree)
    or (TATRangeInCodeTree(Tree.Items[Index].Data).PosBegin.Y <> FHeaders[Index].Line) then
      Exit;
  end;
  Result := True;
end;

// Fills the code tree with the document's headings, indented by their level.
// Each node carries a TATRangeInCodeTree over its section (the heading's line up
// to the line before the next heading, whatever its level), which is both the
// line TreeClick jumps to and what keeps CodetreeSelectItemForPosition selecting
// the heading the caret is reading. A backend whose engine renders no heading
// list (the canvas one) leaves the tree empty, as it was.
procedure TForm1.UpdateTOC;
var
  Index, Level, ParentLevel, NextLine: Integer;
  Line, LastLine: Integer;
  Parents: array[1..6] of TTreeNode;
  Node: TTreeNode;
  Range: TATRangeInCodeTree;
begin
  // View > Table of contents is off: nothing fills it, so a render costs only
  // the preview itself. ApplyTreeVisible calls this once when it is shown
  // again, and the headings are compared then as usual.
  if not FTreeVisible then
    Exit;
  if TocMatchesHeaders then
  begin
    EditorChangeCaretPos(Self);
    Exit;
  end;

  ClearTOC;
  if FHeaders = nil then
    Exit;
  for Level := Low(Parents) to High(Parents) do
    Parents[Level] := nil;
  LastLine := BCEditor1.Strings.Count - 1;
  if LastLine < 0 then
    LastLine := 0;

  Tree.Items.BeginUpdate;
  try
    for Index := 0 to FHeaders.Count - 1 do
    begin
      Line := FHeaders[Index].Line;
      if (Line < 0) or (Trim(FHeaders[Index].Caption) = '') then
        Continue;
      if Index < FHeaders.Count - 1 then
        NextLine := FHeaders[Index + 1].Line
      else
        NextLine := LastLine + 1;
      Range := TATRangeInCodeTree.Create;
      Range.PosBegin := Point(0, Line);
      Range.PosEnd := Point(High(Integer), Max(Line, NextLine - 1));

      Level := FHeaders[Index].Level;
      if Level < Low(Parents) then
        Level := Low(Parents)
      else if Level > High(Parents) then
        Level := High(Parents);
      Node := nil;
      for ParentLevel := Level - 1 downto Low(Parents) do
        if Parents[ParentLevel] <> nil then
        begin
          Node := Parents[ParentLevel];
          Break;
        end;
      Node := Tree.Items.AddChildObject(Node, FHeaders[Index].Caption, Range);
      Parents[Level] := Node;
      // A deeper heading after this one starts its own subtree.
      for ParentLevel := Level + 1 to High(Parents) do
        Parents[ParentLevel] := nil;
    end;
  finally
    Tree.Items.EndUpdate;
  end;
  Tree.FullExpand;
  EditorChangeCaretPos(Self);
end;

// The tree is the table of contents: a click on a heading goes to that line in
// both panes.
procedure TForm1.TreeClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := Tree.Selected; // the node the click just selected
  if (Node = nil) or (Node.Data = nil) then
    Exit;
  // Group nodes are plain text and carry no range.
  if not (TObject(Node.Data) is TATRangeInCodeTree) then
    Exit;
  JumpToSourceLine(TATRangeInCodeTree(Node.Data).PosBegin.Y);
end;

// Takes both panes to a source line: the caret and the editor's top line, and
// the preview to the Y that line was rendered at -- the same maps the scroll
// sync uses, so the heading lands at the top of both. This is a jump the user
// asked for, so it works whether or not the panes are following each other;
// SyncEditorToPreview also records the new position, which leaves the next tick
// seeing both panes already in agreement.
procedure TForm1.JumpToSourceLine(ALine: Integer);
begin
  if (ALine < 0) or (ALine > BCEditor1.Strings.Count - 1) then
    Exit;
  if BCEditor1.Carets.Count = 0 then
    Exit;

  with BCEditor1.Carets[0] do
  begin
    PosX := 0; PosY := ALine;
    EndX := 0; EndY := ALine;
  end;
  BCEditor1.DoShowPos(Point(0, ALine), 0, 0, True, True, True);
  SetEditorTopLine(ALine);
  SyncEditorToPreview;
end;

procedure TForm1.LoadINI;
var
ini:tinifile;
theme: string;
i: Integer;
s: string;
begin
  ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
    try
      BCEditor1.Font.Name:=ini.ReadString('MDPad','fontname','consolas');
      BCEditor1.Font.Size:=ini.ReadInteger('MDPad','fontsize',11);

      BCEditor1.Font.Color:=ini.ReadInteger('MDPad','fontcolor',$000000);

      Synceditwithpreview1.Checked:=ini.ReadBool('MDPad','sync',false);
      tmrScrollSyncer.Enabled:=Synceditwithpreview1.Checked;
      Waitafewsecondsbeforeupdatingthepreview1.Checked:=ini.ReadBool('MDPad','delay',false);

      Statusbar2.Checked:=ini.ReadBool('MDPad','statusbar',false);
      StatusBar1.Visible:=Statusbar2.Checked;
      // View > Table of contents, on unless a session turned it off.
      FTreeVisible := ini.ReadBool('MDPad','tree',true);
      Wordwrap1.Checked:=ini.ReadBool('MDPad','wordwrap',false);
      // That legacy key used to toggle OptWrapIndented (the wrap indent), which
      // only matters when wrapping is on -- so with wrapping off it looked dead.
      // It is read as "wrapping on" by LoadEditorOptions now, and the menu check
      // is taken from the editor options after that.

      ViewersRatio:=ini.ReadInteger('Window','editorposition',50);
      Width:=ini.ReadInteger('Window','width',771);
      Height:=ini.ReadInteger('Window','height',472);

      // Where Splitter2 was left: it resizes the alLeft tree. Clamped, because
      // the value can come from another build or another screen, and a tree
      // wider than the window would leave the editor with nothing.
      i := ini.ReadInteger('Window','treeposition',Tree.Width);
      if i > Width - 200 then
        i := Width - 200;
      if i < 50 then
        i := 50;
      Tree.Width := i;

      TrackBar1_Position:= ini.ReadInteger('Preview','zoom',2);

      // What the last session picked (View -> Preview: ... and Engines). A
      // settings.ini from another build, or one carried over from Windows, can
      // carry a viewer or an engine this one does not have: fall back rather
      // than leave the preview with no control behind it.
      SelectedEngine := ini.ReadInteger('MDPad', 'engine', mdNATIVE);
      if (SelectedEngine < mdPAGEDOWN) or (SelectedEngine > mdMARKDOWN4D) then
        SelectedEngine := mdNATIVE;
      SelectedPreview := ini.ReadInteger('MDPad', 'preview', pvHTML);
      if (SelectedPreview <> pvHTML) and (SelectedPreview <> pvMARKDOWN4D)
      {$IFDEF MSWINDOWS} and (SelectedPreview <> pvIE) {$ENDIF} then
        SelectedPreview := pvHTML;

      // Syntax highlighting is what a markdown editor is for, so it defaults to
      // on; the key is honoured either way (see ApplySyntaxEnabled).
      mnuSyntax.Checked := ini.ReadBool('MDPad', 'syntaxenabled', true);
      // The theme is a name now (see TAppTheme). A settings.ini written by an
      // older build only has the "Enable Custom Theme" boolean: true meant the
      // editor was painted from Theme.json, which is what Custom means now, and
      // false meant the built-in look, i.e. System.
      theme := ini.ReadString('MDPad', 'theme', '');
      if SameText(theme, 'light') then
        SelectedTheme := atLIGHT
      else if SameText(theme, 'dark') then
        SelectedTheme := atDARK
      else if SameText(theme, 'custom') then
        SelectedTheme := atCUSTOM
      else if (theme = '') and ini.ReadBool('MDPad', 'themeenabled', false) then
        SelectedTheme := atCUSTOM
      else
        SelectedTheme := atSYSTEM;
      mnuCSS.Checked := ini.ReadBool('MDPad', 'cssenabled', false);

      Loadremoteimages1.Checked := ini.ReadBool('MDPad', 'remoteimages', true);
      ApplyRemoteImagesSetting(False);

      // Recent files: full paths, most recent first. The list's own length is
      // the limit (the Options dialog picks it, 10 by default).
      FMRULimit := ini.ReadInteger('Files', 'mrucount', 10);
      if FMRULimit < 1 then
        FMRULimit := 1;
      if FMRULimit > 30 then
        FMRULimit := 30;
      FMRU.Clear;
      for i := 0 to FMRULimit - 1 do
      begin
        s := ini.ReadString('Files', 'mru' + IntToStr(i), '');
        if s <> '' then
          FMRU.Add(s);
      end;
      RebuildRecentMenu;

      // Editor options: seeded from the live editor, so a key this build does
      // not write keeps the default ATSynEdit (and FormCreate) gave it.
      LoadEditorOptions(ini);

      UpdateEngineInMenu;
      UpdatePreviewInMenu;
      UpdateThemeInMenu;

    finally
      ini.Free;
    end;

end;

procedure TForm1.UpdateThemeInMenu;
begin
  // The four entries are a radio group: the marks are set only here, so the
  // AutoCheck toggle a click does first is always corrected.
  mnuThemeSystem.Checked := SelectedTheme = atSYSTEM;
  mnuThemeLight.Checked := SelectedTheme = atLIGHT;
  mnuThemeDark.Checked := SelectedTheme = atDARK;
  mnuThemeCustom.Checked := SelectedTheme = atCUSTOM;
end;

// Rebuild the File > Open recent submenu from FMRU. The items are created here
// (the .lfm only declares the parent): the list is data, not layout.
procedure TForm1.RebuildRecentMenu;
var
  i: Integer;
  Item: TMenuItem;
begin
  if mnuRecent = nil then
    Exit;
  mnuRecent.Clear;
  if FMRU.Count = 0 then
  begin
    Item := TMenuItem.Create(mnuRecent);
    Item.Caption := '(no recent files)';
    Item.Enabled := False;
    mnuRecent.Add(Item);
    Exit;
  end;
  for i := 0 to FMRU.Count - 1 do
  begin
    Item := TMenuItem.Create(mnuRecent);
    // The number doubles as the accelerator; an ampersand in the path itself is
    // escaped so a folder called "R&D" does not become one.
    if i < 9 then
      Item.Caption := '&' + IntToStr(i + 1) + ' ' +
        StringReplace(FMRU[i], '&', '&&', [rfReplaceAll])
    else
      Item.Caption := '1&0 ' + StringReplace(FMRU[i], '&', '&&', [rfReplaceAll]);
    Item.Tag := i;
    Item.OnClick := mnuRecentClick;
    mnuRecent.Add(Item);
  end;
  Item := TMenuItem.Create(mnuRecent);
  Item.Caption := '-';
  mnuRecent.Add(Item);
  Item := TMenuItem.Create(mnuRecent);
  Item.Caption := 'Clear list';
  Item.OnClick := mnuRecentClearClick;
  mnuRecent.Add(Item);
end;

// A file that was opened (or saved) goes to the top; opening it again moves it
// there instead of listing it twice. Saved immediately, like the other picks.
procedure TForm1.AddToMRU(const AFile: string);
var
  fn: string;
  i: Integer;
begin
  if not Assigned(FMRU) then
    Exit;
  fn := ExpandFileName(AFile);
  if not FileExists(fn) then
    Exit;
  i := FMRU.IndexOf(fn);
  if i >= 0 then
    FMRU.Delete(i);
  FMRU.Insert(0, fn);
  while FMRU.Count > FMRULimit do
    FMRU.Delete(FMRU.Count - 1);
  RebuildRecentMenu;
  SaveINI;
end;

procedure TForm1.RemoveFromMRU(const AFile: string);
begin
  if not Assigned(FMRU) then
    Exit;
  if FMRU.IndexOf(ExpandFileName(AFile)) >= 0 then
  begin
    FMRU.Delete(FMRU.IndexOf(ExpandFileName(AFile)));
    RebuildRecentMenu;
    SaveINI;
  end;
end;

procedure TForm1.mnuRecentClick(Sender: TObject);
var
  fn: string;
  idx: Integer;
begin
  idx := TMenuItem(Sender).Tag;
  if (idx < 0) or (idx >= FMRU.Count) then
    Exit;
  fn := FMRU[idx];
  if not FileExists(fn) then
  begin
    // The list outlives the files it names: say so and forget the entry.
    MessageDlg('This file no longer exists:'#13 + fn, mtWarning, [mbOK], 0);
    RemoveFromMRU(fn);
    Exit;
  end;
  if not CanOpenAnotherFile then
    Exit;
  AddToMRU(fn); // opening it makes it the most recent
  OpenMDFile(fn);
end;

procedure TForm1.mnuRecentClearClick(Sender: TObject);
begin
  if not Assigned(FMRU) then
    Exit;
  FMRU.Clear;
  RebuildRecentMenu;
  SaveINI;
end;

// The "document has been modified" guard, shared by Open and Open recent. A
// cancelled Save-as leaves the buffer untouched, so the open is cancelled too
// instead of silently discarding the changes.
function TForm1.CanOpenAnotherFile: Boolean;
begin
  if textBuffer = BCEditor1.Text then
    Exit(True);
  case MessageDlg('Your document has been modified'#13 +
    'Do you want to save those changes?', mtConfirmation,
    [mbYes, mbNo, mbCancel], 0) of
    mrYes:
      begin
        Save1Click(Self);
        Result := textBuffer = BCEditor1.Text;
      end;
    mrNo:
      Result := True;
  else
    Result := False;
  end;
end;

// ---------------------------------------------------------------------------
// Editor options
//
// One record (mdoptions.TEditorOptions) is what the Options dialog edits, what
// settings.ini stores and what ApplyEditorOptions writes into BCEditor1.
// CaptureEditorOptions seeds it from the live editor, so a settings.ini written
// by an older build -- or one from which somebody deleted a key -- keeps the
// ATSynEdit default for that key instead of a value invented here.
// ---------------------------------------------------------------------------

function TForm1.GutterBandVisible(ATag: Integer): Boolean;
var
  i: Integer;
begin
  i := BCEditor1.Gutter.FindIndexByTag(ATag);
  Result := (i >= 0) and BCEditor1.Gutter[i].Visible;
end;

procedure TForm1.SetGutterBandVisible(ATag: Integer; AValue: Boolean);
var
  i: Integer;
begin
  i := BCEditor1.Gutter.FindIndexByTag(ATag);
  if i >= 0 then
    BCEditor1.Gutter[i].Visible := AValue;
end;

procedure TForm1.CaptureEditorOptions;
begin
  with FEditorOpts do
  begin
    ShowCurLine := BCEditor1.OptShowCurLine;
    ShowCurLineMinimal := BCEditor1.OptShowCurLineMinimal;
    ShowCurColumn := BCEditor1.OptShowCurColumn;
    LastLineOnTop := BCEditor1.OptLastLineOnTop;
    ShowFullWidthSel := BCEditor1.OptShowFullWidthForSelection;
    ShowFullWidthHilite := BCEditor1.OptShowFullWidthForSyntaxHilite;
    ShowIndentLines := BCEditor1.OptShowIndentLines;
    ZebraActive := BCEditor1.OptZebraActive;
    ZebraStep := BCEditor1.OptZebraStep;
    ShowScrollHint := BCEditor1.OptShowScrollHint;
    TextHint := BCEditor1.OptTextHint;
    WrapMode := Ord(BCEditor1.OptWrapMode);
    WrapIndented := BCEditor1.OptWrapIndented;
    GutterVisible := BCEditor1.OptGutterVisible;
    GutterNumbers := GutterBandVisible(ATEditorOptions.GutterTagNumbers);
    GutterBookmarks := GutterBandVisible(ATEditorOptions.GutterTagBookmarks);
    GutterFolding := GutterBandVisible(ATEditorOptions.GutterTagFolding);
    GutterStates := GutterBandVisible(ATEditorOptions.GutterTagLineStates);
    GutterSeparator := GutterBandVisible(ATEditorOptions.GutterTagSeparator);
    NumbersStyle := Ord(BCEditor1.OptNumbersStyle);
    NumbersAlignment := Ord(BCEditor1.OptNumbersAlignment);
    NumbersShowFirst := BCEditor1.OptNumbersShowFirst;
    NumbersShowCarets := BCEditor1.OptNumbersShowCarets;
    GutterCaretBG := BCEditor1.OptShowGutterCaretBG;
    RulerVisible := BCEditor1.OptRulerVisible;
    RulerHeight := BCEditor1.OptRulerHeightPercents;
    RulerFontSize := BCEditor1.OptRulerFontSizePercents;
    RulerTopIndent := BCEditor1.OptRulerTopIndentPercents;
    RulerStyle := Ord(BCEditor1.OptRulerNumeration);
    MinimapVisible := BCEditor1.OptMinimapVisible;
    MinimapCharWidth := BCEditor1.OptMinimapCharWidth;
    MinimapSelBorder := BCEditor1.OptMinimapShowSelBorder;
    MinimapSelAlways := BCEditor1.OptMinimapShowSelAlways;
    UnprintedVisible := BCEditor1.OptUnprintedVisible;
    UnprintedSpaces := BCEditor1.OptUnprintedSpaces;
    UnprintedSpacesTrailing := BCEditor1.OptUnprintedSpacesTrailing;
    UnprintedSpacesBothEnds := BCEditor1.OptUnprintedSpacesBothEnds;
    UnprintedEnds := BCEditor1.OptUnprintedEnds;
    UnprintedEndsDetails := BCEditor1.OptUnprintedEndsDetails;
    UnprintedReplaceSpec := ATEditorOptions.UnprintedReplaceSpec;
    UnprintedEndSymbol := Ord(ATEditorOptions.UnprintedEndSymbol);
    UnprintedTabScale := ATEditorOptions.UnprintedTabPointerScale;
    TabSpaces := BCEditor1.OptTabSpaces;
    TabSize := BCEditor1.OptTabSize;
    IndentSize := BCEditor1.OptIndentSize;
    AutoIndent := BCEditor1.OptAutoIndent;
    AutoIndentKind := Ord(BCEditor1.OptAutoIndentKind);
    TabIndents := BCEditor1.OptKeyTabIndents;
    BackspaceUnindent := BCEditor1.OptKeyBackspaceUnindent;
    BackspaceGoesPrev := BCEditor1.OptKeyBackspaceGoesToPrevLine;
    IndentKeepsAlign := BCEditor1.OptIndentKeepsAlign;
    OverwriteSel := BCEditor1.OptOverwriteSel;
    NavUpDownWrapped := BCEditor1.OptKeyUpDownNavigateWrapped;
    UpDownAllowToEdge := BCEditor1.OptKeyUpDownAllowToEdge;
    UpDownKeepColumn := BCEditor1.OptKeyUpDownKeepColumn;
    NavHomeEndWrapped := BCEditor1.OptKeyHomeEndNavigateWrapped;
    HomeToNonSpace := BCEditor1.OptKeyHomeToNonSpace;
    EndToNonSpace := BCEditor1.OptKeyEndToNonSpace;
    PageKeepsRelative := BCEditor1.OptKeyPageKeepsRelativePos;
    PageSize := Ord(BCEditor1.OptKeyPageUpDownSize);
    LeftRightSwapSel := BCEditor1.OptKeyLeftRightSwapSel;
    MouseNormalSel := BCEditor1.OptMouseEnableNormalSelection;
    MouseColumnSel := BCEditor1.OptMouseEnableColumnSelection;
    Mouse2ClickAction := Ord(BCEditor1.OptMouse2ClickAction);
    Mouse3ClickSelectsLine := BCEditor1.OptMouse3ClickSelectsLine;
    Mouse2ClickDragSelectsWords := BCEditor1.OptMouse2ClickDragSelectsWords;
    MouseClickNumberSelectsLine := BCEditor1.OptMouseClickNumberSelectsLine;
    MouseDragDrop := BCEditor1.OptMouseDragDrop;
    MouseRightClickMovesCaret := BCEditor1.OptMouseRightClickMovesCaret;
    MouseMiddleClickAction := Ord(BCEditor1.OptMouseMiddleClickAction);
    MouseHideCursorOnType := BCEditor1.OptMouseHideCursorOnType;
    MouseClickOpensURL := BCEditor1.OptMouseClickOpensURL;
    CaretBlinkEnabled := BCEditor1.OptCaretBlinkEnabled;
    CaretBlinkTime := BCEditor1.OptCaretBlinkTime;
    CaretVirtual := BCEditor1.OptCaretVirtual;
    CaretMany := BCEditor1.OptCaretManyAllowed;
    CaretStopUnfocused := BCEditor1.OptCaretStopUnfocused;
    CaretPrimitiveColumn := BCEditor1.OptCaretsPrimitiveColumnSelection;
    CaretTextInverted := ATEditorOptions.CaretTextOverInvertedRect;
    SaveForceFinalEol := BCEditor1.OptSavingForceFinalEol;
    SaveTrimSpaces := BCEditor1.OptSavingTrimSpaces;
    SaveTrimFinalEmptyLines := BCEditor1.OptSavingTrimFinalEmptyLines;
    CopyLinesIfNoSel := BCEditor1.OptCopyLinesIfNoSel;
    CutLinesIfNoSel := BCEditor1.OptCutLinesIfNoSel;
    PasteOverwrite := BCEditor1.OptOverwriteAllowedOnPaste;
    PasteSpread := BCEditor1.OptPasteMultilineTextSpreadsToCarets;
    UndoLimit := BCEditor1.OptUndoLimit;
    UndoGrouped := BCEditor1.OptUndoGrouped;
    UndoAfterSave := BCEditor1.OptUndoAfterSave;
    UndoForCaretJump := BCEditor1.OptUndoForCaretJump;
    FontName := BCEditor1.Font.Name;
    FontSize := BCEditor1.Font.Size;
  end;
end;

procedure TForm1.ApplyEditorOptions;
begin
  with FEditorOpts do
  begin
    // An ini from a build with a longer enum must not index past the end of
    // these -- the casts below would not range-check.
    if (WrapMode < 0) or (WrapMode > Ord(High(TATEditorWrapMode))) then
      WrapMode := Ord(TATEditorWrapMode.ModeOff);
    if (NumbersStyle < 0) or (NumbersStyle > Ord(High(TATEditorNumbersStyle))) then
      NumbersStyle := 0;
    if (NumbersAlignment < 0) or (NumbersAlignment > Ord(High(TAlignment))) then
      NumbersAlignment := 0;
    if (RulerStyle < 0) or (RulerStyle > Ord(High(TATEditorRulerNumeration))) then
      RulerStyle := 0;
    if (AutoIndentKind < 0) or (AutoIndentKind > Ord(High(TATEditorAutoIndentKind))) then
      AutoIndentKind := 0;
    if (PageSize < 0) or (PageSize > Ord(High(TATEditorPageDownSize))) then
      PageSize := 0;
    if (Mouse2ClickAction < 0) or (Mouse2ClickAction > Ord(High(TATEditorDoubleClickAction))) then
      Mouse2ClickAction := 0;
    if (MouseMiddleClickAction < 0) or (MouseMiddleClickAction > Ord(High(TATEditorMiddleClickAction))) then
      MouseMiddleClickAction := 0;
    if (UnprintedEndSymbol < 0) or (UnprintedEndSymbol > Ord(High(TATEditorUnptintedEolSymbol))) then
      UnprintedEndSymbol := 0;
    if TabSize < 1 then TabSize := 1;
    if TabSize > 32 then TabSize := 32;
    if IndentSize < -16 then IndentSize := -16;
    if IndentSize > 32 then IndentSize := 32;
    if ZebraStep < 2 then ZebraStep := 2;
    if CaretBlinkTime < 100 then CaretBlinkTime := 100;
    if UndoLimit < 0 then UndoLimit := 0;

    BCEditor1.OptShowCurLine := ShowCurLine;
    BCEditor1.OptShowCurLineMinimal := ShowCurLineMinimal;
    BCEditor1.OptShowCurColumn := ShowCurColumn;
    BCEditor1.OptLastLineOnTop := LastLineOnTop;
    BCEditor1.OptShowFullWidthForSelection := ShowFullWidthSel;
    BCEditor1.OptShowFullWidthForSyntaxHilite := ShowFullWidthHilite;
    BCEditor1.OptShowIndentLines := ShowIndentLines;
    BCEditor1.OptZebraActive := ZebraActive;
    BCEditor1.OptZebraStep := ZebraStep;
    BCEditor1.OptShowScrollHint := ShowScrollHint;
    BCEditor1.OptTextHint := TextHint;
    BCEditor1.OptWrapMode := TATEditorWrapMode(WrapMode);
    BCEditor1.OptWrapIndented := WrapIndented;
    BCEditor1.OptGutterVisible := GutterVisible;
    SetGutterBandVisible(ATEditorOptions.GutterTagNumbers, GutterNumbers);
    SetGutterBandVisible(ATEditorOptions.GutterTagBookmarks, GutterBookmarks);
    SetGutterBandVisible(ATEditorOptions.GutterTagFolding, GutterFolding);
    SetGutterBandVisible(ATEditorOptions.GutterTagLineStates, GutterStates);
    SetGutterBandVisible(ATEditorOptions.GutterTagSeparator, GutterSeparator);
    BCEditor1.OptNumbersStyle := TATEditorNumbersStyle(NumbersStyle);
    BCEditor1.OptNumbersAlignment := TAlignment(NumbersAlignment);
    BCEditor1.OptNumbersShowFirst := NumbersShowFirst;
    BCEditor1.OptNumbersShowCarets := NumbersShowCarets;
    BCEditor1.OptShowGutterCaretBG := GutterCaretBG;
    BCEditor1.OptRulerVisible := RulerVisible;
    BCEditor1.OptRulerHeightPercents := RulerHeight;
    BCEditor1.OptRulerFontSizePercents := RulerFontSize;
    BCEditor1.OptRulerTopIndentPercents := RulerTopIndent;
    BCEditor1.OptRulerNumeration := TATEditorRulerNumeration(RulerStyle);
    BCEditor1.OptMinimapVisible := MinimapVisible;
    BCEditor1.OptMinimapCharWidth := MinimapCharWidth;
    BCEditor1.OptMinimapShowSelBorder := MinimapSelBorder;
    BCEditor1.OptMinimapShowSelAlways := MinimapSelAlways;
    BCEditor1.OptUnprintedVisible := UnprintedVisible;
    BCEditor1.OptUnprintedSpaces := UnprintedSpaces;
    BCEditor1.OptUnprintedSpacesTrailing := UnprintedSpacesTrailing;
    BCEditor1.OptUnprintedSpacesBothEnds := UnprintedSpacesBothEnds;
    BCEditor1.OptUnprintedEnds := UnprintedEnds;
    BCEditor1.OptUnprintedEndsDetails := UnprintedEndsDetails;
    ATEditorOptions.UnprintedReplaceSpec := UnprintedReplaceSpec;
    ATEditorOptions.UnprintedEndSymbol := TATEditorUnptintedEolSymbol(UnprintedEndSymbol);
    ATEditorOptions.UnprintedTabPointerScale := UnprintedTabScale;
    BCEditor1.OptTabSpaces := TabSpaces;
    BCEditor1.OptTabSize := TabSize;
    BCEditor1.OptIndentSize := IndentSize;
    BCEditor1.OptAutoIndent := AutoIndent;
    BCEditor1.OptAutoIndentKind := TATEditorAutoIndentKind(AutoIndentKind);
    BCEditor1.OptKeyTabIndents := TabIndents;
    BCEditor1.OptKeyBackspaceUnindent := BackspaceUnindent;
    BCEditor1.OptKeyBackspaceGoesToPrevLine := BackspaceGoesPrev;
    BCEditor1.OptIndentKeepsAlign := IndentKeepsAlign;
    BCEditor1.OptOverwriteSel := OverwriteSel;
    BCEditor1.OptKeyUpDownNavigateWrapped := NavUpDownWrapped;
    BCEditor1.OptKeyUpDownAllowToEdge := UpDownAllowToEdge;
    BCEditor1.OptKeyUpDownKeepColumn := UpDownKeepColumn;
    BCEditor1.OptKeyHomeEndNavigateWrapped := NavHomeEndWrapped;
    BCEditor1.OptKeyHomeToNonSpace := HomeToNonSpace;
    BCEditor1.OptKeyEndToNonSpace := EndToNonSpace;
    BCEditor1.OptKeyPageKeepsRelativePos := PageKeepsRelative;
    BCEditor1.OptKeyPageUpDownSize := TATEditorPageDownSize(PageSize);
    BCEditor1.OptKeyLeftRightSwapSel := LeftRightSwapSel;
    BCEditor1.OptMouseEnableNormalSelection := MouseNormalSel;
    BCEditor1.OptMouseEnableColumnSelection := MouseColumnSel;
    BCEditor1.OptMouse2ClickAction := TATEditorDoubleClickAction(Mouse2ClickAction);
    BCEditor1.OptMouse3ClickSelectsLine := Mouse3ClickSelectsLine;
    BCEditor1.OptMouse2ClickDragSelectsWords := Mouse2ClickDragSelectsWords;
    BCEditor1.OptMouseClickNumberSelectsLine := MouseClickNumberSelectsLine;
    BCEditor1.OptMouseDragDrop := MouseDragDrop;
    BCEditor1.OptMouseRightClickMovesCaret := MouseRightClickMovesCaret;
    BCEditor1.OptMouseMiddleClickAction := TATEditorMiddleClickAction(MouseMiddleClickAction);
    BCEditor1.OptMouseHideCursorOnType := MouseHideCursorOnType;
    BCEditor1.OptMouseClickOpensURL := MouseClickOpensURL;
    BCEditor1.OptCaretBlinkEnabled := CaretBlinkEnabled;
    BCEditor1.OptCaretBlinkTime := CaretBlinkTime;
    BCEditor1.OptCaretVirtual := CaretVirtual;
    BCEditor1.OptCaretManyAllowed := CaretMany;
    BCEditor1.OptCaretStopUnfocused := CaretStopUnfocused;
    BCEditor1.OptCaretsPrimitiveColumnSelection := CaretPrimitiveColumn;
    ATEditorOptions.CaretTextOverInvertedRect := CaretTextInverted;
    BCEditor1.OptSavingForceFinalEol := SaveForceFinalEol;
    BCEditor1.OptSavingTrimSpaces := SaveTrimSpaces;
    BCEditor1.OptSavingTrimFinalEmptyLines := SaveTrimFinalEmptyLines;
    BCEditor1.OptCopyLinesIfNoSel := CopyLinesIfNoSel;
    BCEditor1.OptCutLinesIfNoSel := CutLinesIfNoSel;
    BCEditor1.OptOverwriteAllowedOnPaste := PasteOverwrite;
    BCEditor1.OptPasteMultilineTextSpreadsToCarets := PasteSpread;
    BCEditor1.OptUndoLimit := UndoLimit;
    BCEditor1.OptUndoGrouped := UndoGrouped;
    BCEditor1.OptUndoAfterSave := UndoAfterSave;
    BCEditor1.OptUndoForCaretJump := UndoForCaretJump;
    if FontName <> '' then
      BCEditor1.Font.Name := FontName;
    if FontSize > 0 then
      BCEditor1.Font.Size := FontSize;
  end;
  // ShowFormatBar is the only option that is not an ATSynEdit property: it is
  // the visibility of the bar itself (built in FormCreate).
  if Assigned(FFormatBar) then
    FFormatBar.Visible := FEditorOpts.ShowFormatBar;
  BCEditor1.Gutter.Update;
  BCEditor1.Update;
end;

procedure TForm1.LoadEditorOptions(ini: TIniFile);
begin
  CaptureEditorOptions;
  with FEditorOpts do
  begin
    // A settings.ini from before the Options dialog has no [Editor] section;
    // its only wrapping key was [MDPad] wordwrap, which maps onto wrapping.
    if (not ini.ValueExists('Editor', 'wrapmode')) and
      ini.ReadBool('MDPad', 'wordwrap', false) then
      WrapMode := Ord(TATEditorWrapMode.ModeOn);
    ShowCurLine := ini.ReadBool('Editor', 'curline', ShowCurLine);
    ShowCurLineMinimal := ini.ReadBool('Editor', 'curlineminimal', ShowCurLineMinimal);
    ShowCurColumn := ini.ReadBool('Editor', 'curcolumn', ShowCurColumn);
    LastLineOnTop := ini.ReadBool('Editor', 'lastlineontop', LastLineOnTop);
    ShowFullWidthSel := ini.ReadBool('Editor', 'fullwidthsel', ShowFullWidthSel);
    ShowFullWidthHilite := ini.ReadBool('Editor', 'fullwidthhilite', ShowFullWidthHilite);
    ShowIndentLines := ini.ReadBool('Editor', 'indentlines', ShowIndentLines);
    ZebraActive := ini.ReadBool('Editor', 'zebra', ZebraActive);
    ShowScrollHint := ini.ReadBool('Editor', 'scrollhint', ShowScrollHint);
    WrapIndented := ini.ReadBool('Editor', 'wrapindented', WrapIndented);
    GutterVisible := ini.ReadBool('Editor', 'gutter', GutterVisible);
    GutterNumbers := ini.ReadBool('Editor', 'gutternumbers', GutterNumbers);
    GutterBookmarks := ini.ReadBool('Editor', 'gutterbookmarks', GutterBookmarks);
    GutterFolding := ini.ReadBool('Editor', 'gutterfolding', GutterFolding);
    GutterStates := ini.ReadBool('Editor', 'gutterstates', GutterStates);
    GutterSeparator := ini.ReadBool('Editor', 'gutterseparator', GutterSeparator);
    NumbersShowFirst := ini.ReadBool('Editor', 'numbershowfirst', NumbersShowFirst);
    NumbersShowCarets := ini.ReadBool('Editor', 'numbershowcarets', NumbersShowCarets);
    GutterCaretBG := ini.ReadBool('Editor', 'guttercaretbg', GutterCaretBG);
    RulerVisible := ini.ReadBool('Editor', 'ruler', RulerVisible);
    MinimapVisible := ini.ReadBool('Editor', 'minimap', MinimapVisible);
    MinimapSelBorder := ini.ReadBool('Editor', 'minimapselborder', MinimapSelBorder);
    MinimapSelAlways := ini.ReadBool('Editor', 'minimapselalways', MinimapSelAlways);
    UnprintedVisible := ini.ReadBool('Editor', 'unprinted', UnprintedVisible);
    UnprintedSpaces := ini.ReadBool('Editor', 'unprintedspaces', UnprintedSpaces);
    UnprintedSpacesTrailing := ini.ReadBool('Editor', 'unprintedspacestrailing', UnprintedSpacesTrailing);
    UnprintedSpacesBothEnds := ini.ReadBool('Editor', 'unprintedspacesbothends', UnprintedSpacesBothEnds);
    UnprintedEnds := ini.ReadBool('Editor', 'unprintedends', UnprintedEnds);
    UnprintedEndsDetails := ini.ReadBool('Editor', 'unprintedendsdetails', UnprintedEndsDetails);
    UnprintedReplaceSpec := ini.ReadBool('Editor', 'unprintedreplace', UnprintedReplaceSpec);
    TabSpaces := ini.ReadBool('Editor', 'tabspaces', TabSpaces);
    AutoIndent := ini.ReadBool('Editor', 'autoindent', AutoIndent);
    TabIndents := ini.ReadBool('Editor', 'tabindents', TabIndents);
    BackspaceUnindent := ini.ReadBool('Editor', 'backspaceunindent', BackspaceUnindent);
    BackspaceGoesPrev := ini.ReadBool('Editor', 'backspacegoesprev', BackspaceGoesPrev);
    IndentKeepsAlign := ini.ReadBool('Editor', 'indentkeepsalign', IndentKeepsAlign);
    OverwriteSel := ini.ReadBool('Editor', 'overwritesel', OverwriteSel);
    NavUpDownWrapped := ini.ReadBool('Editor', 'navupdownwrapped', NavUpDownWrapped);
    UpDownAllowToEdge := ini.ReadBool('Editor', 'updownallowtoedge', UpDownAllowToEdge);
    UpDownKeepColumn := ini.ReadBool('Editor', 'updownkeepcolumn', UpDownKeepColumn);
    NavHomeEndWrapped := ini.ReadBool('Editor', 'navhomeendwrapped', NavHomeEndWrapped);
    HomeToNonSpace := ini.ReadBool('Editor', 'hometononspace', HomeToNonSpace);
    EndToNonSpace := ini.ReadBool('Editor', 'endtononspace', EndToNonSpace);
    PageKeepsRelative := ini.ReadBool('Editor', 'pagekeepsrelative', PageKeepsRelative);
    LeftRightSwapSel := ini.ReadBool('Editor', 'leftrightswapsel', LeftRightSwapSel);
    MouseNormalSel := ini.ReadBool('Editor', 'mousenormalsel', MouseNormalSel);
    MouseColumnSel := ini.ReadBool('Editor', 'mousecolumnsel', MouseColumnSel);
    Mouse3ClickSelectsLine := ini.ReadBool('Editor', 'mouse3clicksline', Mouse3ClickSelectsLine);
    Mouse2ClickDragSelectsWords := ini.ReadBool('Editor', 'mouse2dragwords', Mouse2ClickDragSelectsWords);
    MouseClickNumberSelectsLine := ini.ReadBool('Editor', 'mouseclicknumline', MouseClickNumberSelectsLine);
    MouseDragDrop := ini.ReadBool('Editor', 'mousedragdrop', MouseDragDrop);
    MouseRightClickMovesCaret := ini.ReadBool('Editor', 'mouserightcaret', MouseRightClickMovesCaret);
    MouseHideCursorOnType := ini.ReadBool('Editor', 'mousehidecursortype', MouseHideCursorOnType);
    MouseClickOpensURL := ini.ReadBool('Editor', 'mouseclickopensurl', MouseClickOpensURL);
    CaretBlinkEnabled := ini.ReadBool('Editor', 'caretblink', CaretBlinkEnabled);
    CaretVirtual := ini.ReadBool('Editor', 'caretvirtual', CaretVirtual);
    CaretMany := ini.ReadBool('Editor', 'caretmany', CaretMany);
    CaretStopUnfocused := ini.ReadBool('Editor', 'caretstopunfocused', CaretStopUnfocused);
    CaretPrimitiveColumn := ini.ReadBool('Editor', 'caretprimitivecolumn', CaretPrimitiveColumn);
    CaretTextInverted := ini.ReadBool('Editor', 'carettextinverted', CaretTextInverted);
    SaveForceFinalEol := ini.ReadBool('Editor', 'savefinaleol', SaveForceFinalEol);
    SaveTrimSpaces := ini.ReadBool('Editor', 'savetrimspaces', SaveTrimSpaces);
    SaveTrimFinalEmptyLines := ini.ReadBool('Editor', 'savetrimempty', SaveTrimFinalEmptyLines);
    CopyLinesIfNoSel := ini.ReadBool('Editor', 'copylinesifnosel', CopyLinesIfNoSel);
    CutLinesIfNoSel := ini.ReadBool('Editor', 'cutlinesifnosel', CutLinesIfNoSel);
    PasteOverwrite := ini.ReadBool('Editor', 'pasteoverwrite', PasteOverwrite);
    PasteSpread := ini.ReadBool('Editor', 'pastespread', PasteSpread);
    UndoGrouped := ini.ReadBool('Editor', 'undogrouped', UndoGrouped);
    UndoAfterSave := ini.ReadBool('Editor', 'undoaftersave', UndoAfterSave);
    UndoForCaretJump := ini.ReadBool('Editor', 'undocaretjump', UndoForCaretJump);
    ShowFormatBar := ini.ReadBool('Editor', 'formatbar', ShowFormatBar);
    SmartEnter := ini.ReadBool('Editor', 'smartenter', SmartEnter);
    ZebraStep := ini.ReadInteger('Editor', 'zebrastep', ZebraStep);
    NumbersStyle := ini.ReadInteger('Editor', 'numberstyle', NumbersStyle);
    NumbersAlignment := ini.ReadInteger('Editor', 'numberalign', NumbersAlignment);
    RulerHeight := ini.ReadInteger('Editor', 'rulerheight', RulerHeight);
    RulerFontSize := ini.ReadInteger('Editor', 'rulerfontsize', RulerFontSize);
    RulerTopIndent := ini.ReadInteger('Editor', 'rulertopindent', RulerTopIndent);
    RulerStyle := ini.ReadInteger('Editor', 'rulerstyle', RulerStyle);
    MinimapCharWidth := ini.ReadInteger('Editor', 'minimapcharwidth', MinimapCharWidth);
    UnprintedEndSymbol := ini.ReadInteger('Editor', 'unprintedendsymbol', UnprintedEndSymbol);
    UnprintedTabScale := ini.ReadInteger('Editor', 'unprintedtabscale', UnprintedTabScale);
    TabSize := ini.ReadInteger('Editor', 'tabsize', TabSize);
    IndentSize := ini.ReadInteger('Editor', 'indentsize', IndentSize);
    AutoIndentKind := ini.ReadInteger('Editor', 'autoindentkind', AutoIndentKind);
    PageSize := ini.ReadInteger('Editor', 'pagesize', PageSize);
    Mouse2ClickAction := ini.ReadInteger('Editor', 'mouse2click', Mouse2ClickAction);
    MouseMiddleClickAction := ini.ReadInteger('Editor', 'mousemiddle', MouseMiddleClickAction);
    CaretBlinkTime := ini.ReadInteger('Editor', 'caretblinktime', CaretBlinkTime);
    UndoLimit := ini.ReadInteger('Editor', 'undolimit', UndoLimit);
    WrapMode := ini.ReadInteger('Editor', 'wrapmode', WrapMode);
    FontSize := ini.ReadInteger('Editor', 'fontsize', FontSize);
    TextHint := ini.ReadString('Editor', 'texthint', TextHint);
    FontName := ini.ReadString('Editor', 'fontname', FontName);
  end;
end;

procedure TForm1.SaveEditorOptions(ini: TIniFile);
begin
  with FEditorOpts do
  begin
    ini.WriteBool('Editor', 'curline', ShowCurLine);
    ini.WriteBool('Editor', 'curlineminimal', ShowCurLineMinimal);
    ini.WriteBool('Editor', 'curcolumn', ShowCurColumn);
    ini.WriteBool('Editor', 'lastlineontop', LastLineOnTop);
    ini.WriteBool('Editor', 'fullwidthsel', ShowFullWidthSel);
    ini.WriteBool('Editor', 'fullwidthhilite', ShowFullWidthHilite);
    ini.WriteBool('Editor', 'indentlines', ShowIndentLines);
    ini.WriteBool('Editor', 'zebra', ZebraActive);
    ini.WriteBool('Editor', 'scrollhint', ShowScrollHint);
    ini.WriteBool('Editor', 'wrapindented', WrapIndented);
    ini.WriteBool('Editor', 'gutter', GutterVisible);
    ini.WriteBool('Editor', 'gutternumbers', GutterNumbers);
    ini.WriteBool('Editor', 'gutterbookmarks', GutterBookmarks);
    ini.WriteBool('Editor', 'gutterfolding', GutterFolding);
    ini.WriteBool('Editor', 'gutterstates', GutterStates);
    ini.WriteBool('Editor', 'gutterseparator', GutterSeparator);
    ini.WriteBool('Editor', 'numbershowfirst', NumbersShowFirst);
    ini.WriteBool('Editor', 'numbershowcarets', NumbersShowCarets);
    ini.WriteBool('Editor', 'guttercaretbg', GutterCaretBG);
    ini.WriteBool('Editor', 'ruler', RulerVisible);
    ini.WriteBool('Editor', 'minimap', MinimapVisible);
    ini.WriteBool('Editor', 'minimapselborder', MinimapSelBorder);
    ini.WriteBool('Editor', 'minimapselalways', MinimapSelAlways);
    ini.WriteBool('Editor', 'unprinted', UnprintedVisible);
    ini.WriteBool('Editor', 'unprintedspaces', UnprintedSpaces);
    ini.WriteBool('Editor', 'unprintedspacestrailing', UnprintedSpacesTrailing);
    ini.WriteBool('Editor', 'unprintedspacesbothends', UnprintedSpacesBothEnds);
    ini.WriteBool('Editor', 'unprintedends', UnprintedEnds);
    ini.WriteBool('Editor', 'unprintedendsdetails', UnprintedEndsDetails);
    ini.WriteBool('Editor', 'unprintedreplace', UnprintedReplaceSpec);
    ini.WriteBool('Editor', 'tabspaces', TabSpaces);
    ini.WriteBool('Editor', 'autoindent', AutoIndent);
    ini.WriteBool('Editor', 'tabindents', TabIndents);
    ini.WriteBool('Editor', 'backspaceunindent', BackspaceUnindent);
    ini.WriteBool('Editor', 'backspacegoesprev', BackspaceGoesPrev);
    ini.WriteBool('Editor', 'indentkeepsalign', IndentKeepsAlign);
    ini.WriteBool('Editor', 'overwritesel', OverwriteSel);
    ini.WriteBool('Editor', 'navupdownwrapped', NavUpDownWrapped);
    ini.WriteBool('Editor', 'updownallowtoedge', UpDownAllowToEdge);
    ini.WriteBool('Editor', 'updownkeepcolumn', UpDownKeepColumn);
    ini.WriteBool('Editor', 'navhomeendwrapped', NavHomeEndWrapped);
    ini.WriteBool('Editor', 'hometononspace', HomeToNonSpace);
    ini.WriteBool('Editor', 'endtononspace', EndToNonSpace);
    ini.WriteBool('Editor', 'pagekeepsrelative', PageKeepsRelative);
    ini.WriteBool('Editor', 'leftrightswapsel', LeftRightSwapSel);
    ini.WriteBool('Editor', 'mousenormalsel', MouseNormalSel);
    ini.WriteBool('Editor', 'mousecolumnsel', MouseColumnSel);
    ini.WriteBool('Editor', 'mouse3clicksline', Mouse3ClickSelectsLine);
    ini.WriteBool('Editor', 'mouse2dragwords', Mouse2ClickDragSelectsWords);
    ini.WriteBool('Editor', 'mouseclicknumline', MouseClickNumberSelectsLine);
    ini.WriteBool('Editor', 'mousedragdrop', MouseDragDrop);
    ini.WriteBool('Editor', 'mouserightcaret', MouseRightClickMovesCaret);
    ini.WriteBool('Editor', 'mousehidecursortype', MouseHideCursorOnType);
    ini.WriteBool('Editor', 'mouseclickopensurl', MouseClickOpensURL);
    ini.WriteBool('Editor', 'caretblink', CaretBlinkEnabled);
    ini.WriteBool('Editor', 'caretvirtual', CaretVirtual);
    ini.WriteBool('Editor', 'caretmany', CaretMany);
    ini.WriteBool('Editor', 'caretstopunfocused', CaretStopUnfocused);
    ini.WriteBool('Editor', 'caretprimitivecolumn', CaretPrimitiveColumn);
    ini.WriteBool('Editor', 'carettextinverted', CaretTextInverted);
    ini.WriteBool('Editor', 'savefinaleol', SaveForceFinalEol);
    ini.WriteBool('Editor', 'savetrimspaces', SaveTrimSpaces);
    ini.WriteBool('Editor', 'savetrimempty', SaveTrimFinalEmptyLines);
    ini.WriteBool('Editor', 'copylinesifnosel', CopyLinesIfNoSel);
    ini.WriteBool('Editor', 'cutlinesifnosel', CutLinesIfNoSel);
    ini.WriteBool('Editor', 'pasteoverwrite', PasteOverwrite);
    ini.WriteBool('Editor', 'pastespread', PasteSpread);
    ini.WriteBool('Editor', 'undogrouped', UndoGrouped);
    ini.WriteBool('Editor', 'undoaftersave', UndoAfterSave);
    ini.WriteBool('Editor', 'undocaretjump', UndoForCaretJump);
    ini.WriteBool('Editor', 'formatbar', ShowFormatBar);
    ini.WriteBool('Editor', 'smartenter', SmartEnter);
    ini.WriteInteger('Editor', 'zebrastep', ZebraStep);
    ini.WriteInteger('Editor', 'numberstyle', NumbersStyle);
    ini.WriteInteger('Editor', 'numberalign', NumbersAlignment);
    ini.WriteInteger('Editor', 'rulerheight', RulerHeight);
    ini.WriteInteger('Editor', 'rulerfontsize', RulerFontSize);
    ini.WriteInteger('Editor', 'rulertopindent', RulerTopIndent);
    ini.WriteInteger('Editor', 'rulerstyle', RulerStyle);
    ini.WriteInteger('Editor', 'minimapcharwidth', MinimapCharWidth);
    ini.WriteInteger('Editor', 'unprintedendsymbol', UnprintedEndSymbol);
    ini.WriteInteger('Editor', 'unprintedtabscale', UnprintedTabScale);
    ini.WriteInteger('Editor', 'tabsize', TabSize);
    ini.WriteInteger('Editor', 'indentsize', IndentSize);
    ini.WriteInteger('Editor', 'autoindentkind', AutoIndentKind);
    ini.WriteInteger('Editor', 'pagesize', PageSize);
    ini.WriteInteger('Editor', 'mouse2click', Mouse2ClickAction);
    ini.WriteInteger('Editor', 'mousemiddle', MouseMiddleClickAction);
    ini.WriteInteger('Editor', 'caretblinktime', CaretBlinkTime);
    ini.WriteInteger('Editor', 'undolimit', UndoLimit);
    ini.WriteInteger('Editor', 'wrapmode', WrapMode);
    ini.WriteInteger('Editor', 'fontsize', FontSize);
    ini.WriteString('Editor', 'texthint', TextHint);
    ini.WriteString('Editor', 'fontname', FontName);
  end;
end;

// The Editor menu's quick toggles show the same state the dialog does, and so
// does Format > Wordwrap (which had been toggling something else).
procedure TForm1.UpdateEditorMenuChecks;
begin
  if mnuEditorGutter = nil then
    Exit;
  mnuEditorGutter.Checked := FEditorOpts.GutterVisible;
  mnuEditorRuler.Checked := FEditorOpts.RulerVisible;
  mnuEditorMinimap.Checked := FEditorOpts.MinimapVisible;
  mnuEditorUnprinted.Checked := FEditorOpts.UnprintedVisible;
  mnuEditorWrap.Checked := FEditorOpts.WrapMode <> Ord(TATEditorWrapMode.ModeOff);
  Wordwrap1.Checked := mnuEditorWrap.Checked;
  mnuEditorFormatBar.Checked := FEditorOpts.ShowFormatBar;
  mnuEditorSmartEnter.Checked := FEditorOpts.SmartEnter;
end;

// ---------------------------------------------------------------------------
// Markdown editing helpers
// ---------------------------------------------------------------------------

function TForm1.ThemeIsDark: Boolean;
begin
  Result := FThemeDark;
end;

// The selection as offsets into the whole text, which is the unit the engine
// and CaretPosToOffset/OffsetToCaretPos speak.
function TForm1.EditorSelection(out AStart, AEnd: Integer): Boolean;
var
  C: TATCaretItem;
  P1, P2: TPoint;
  Swap: Integer;
begin
  AStart := 0;
  AEnd := 0;
  Result := Assigned(BCEditor1) and (BCEditor1.Carets.Count > 0);
  if not Result then
    Exit;
  C := BCEditor1.Carets[0];
  P1 := Point(C.PosX, C.PosY);
  if C.EndX >= 0 then
    P2 := Point(C.EndX, C.EndY)
  else
    P2 := P1;
  AStart := BCEditor1.CaretPosToOffset(P1);
  AEnd := BCEditor1.CaretPosToOffset(P2);
  if (AStart < 0) or (AEnd < 0) then
  begin
    Result := False;
    Exit;
  end;
  if AEnd < AStart then
  begin
    Swap := AStart;
    AStart := AEnd;
    AEnd := Swap;
  end;
end;

// One replace, one undo step: the delete and the insert are separate editor
// commands, so they are wrapped in an undo group, and only then is the
// selection the engine asked for restored.
procedure TForm1.ApplyMdEdit(const AEdit: TMdEdit);
var
  P, Q, PSel, QSel: TPoint;
begin
  if not AEdit.Changed then
    Exit;
  if not Assigned(BCEditor1) then
    Exit;
  P := BCEditor1.OffsetToCaretPos(AEdit.StartOffset);
  Q := BCEditor1.OffsetToCaretPos(AEdit.EndOffset);
  if (P.X < 0) or (Q.X < 0) then
    Exit;
  BCEditor1.Strings.BeginUndoGroup;
  try
    BCEditor1.Carets[0].Change(P.X, P.Y, Q.X, Q.Y);
    if AEdit.StartOffset <> AEdit.EndOffset then
      BCEditor1.DoCommand(cCommand_TextDeleteSelection, TATCommandInvoke.Internal);
    if AEdit.InsertText <> '' then
      BCEditor1.TextInsertAtCarets(AEdit.InsertText, False, False, False);
    PSel := BCEditor1.OffsetToCaretPos(AEdit.SelStart);
    QSel := BCEditor1.OffsetToCaretPos(AEdit.SelEnd);
    BCEditor1.Carets[0].Change(PSel.X, PSel.Y, QSel.X, QSel.Y);
    if AEdit.SelStart = AEdit.SelEnd then
      BCEditor1.Carets[0].SelectNone;
  finally
    BCEditor1.Strings.EndUndoGroup;
  end;
  BCEditor1.DoShowPos(PSel, 0, 0, True, True, True);
  BCEditor1.SetFocus;
end;

procedure TForm1.MdCommandClick(Sender: TObject);
begin
  if Sender is TComponent then
    MdExecute(TMdCommand(TComponent(Sender).Tag));
  // The sender was a menu item or a bar button and has the focus now; the
  // command may have changed nothing at all (bold on an empty line), so hand
  // the keyboard back to the editor either way.
  if Assigned(BCEditor1) then
    BCEditor1.SetFocus;
end;

procedure TForm1.MdExecute(ACommand: TMdCommand);
var
  S, E: Integer;
  T: UnicodeString;
begin
  if ACommand = mcCompleteWord then
  begin
    MdCompleteWord;
    Exit;
  end;
  if ACommand = mcLink then
  begin
    MdInsertLinkCommand;
    Exit;
  end;
  if ACommand = mcImage then
  begin
    MdInsertImageCommand;
    Exit;
  end;
  if ACommand = mcTable then
  begin
    MdInsertTableCommand;
    Exit;
  end;
  if not EditorSelection(S, E) then
    Exit;
  T := BCEditor1.Text;
  case ACommand of
    mcBold: ApplyMdEdit(MdToggleInline(T, S, E, '**'));
    mcItalic: ApplyMdEdit(MdToggleInline(T, S, E, '*'));
    mcStrike: ApplyMdEdit(MdToggleInline(T, S, E, '~~'));
    mcCode: ApplyMdEdit(MdToggleInline(T, S, E, '`'));
    mcCodeBlock: ApplyMdEdit(MdToggleFence(T, S, E));
    mcHeading: ApplyMdEdit(MdCycleHeading(T, S, E));
    mcQuote: ApplyMdEdit(MdToggleLinePrefix(T, S, E, '> '));
    mcList: ApplyMdEdit(MdToggleLinePrefix(T, S, E, '- '));
    mcOrdered: ApplyMdEdit(MdToggleLinePrefix(T, S, E, '1. '));
    mcTask: ApplyMdEdit(MdToggleTask(T, S, E));
    mcRule: ApplyMdEdit(MdInsertRule(T, S));
  else
    ;
  end;
end;

// A link is rebuilt from the dialog's own three values, so editing an existing
// one replaces the whole markup instead of nesting a second pair of brackets.
procedure TForm1.MdInsertLinkCommand;
var
  S, E, MS, ME: Integer;
  T, UText, UTarget, UTitle: UnicodeString;
  Text, Target, Title: string;
  Editing: Boolean;
  Edit: TMdEdit;
begin
  if not EditorSelection(S, E) then
    Exit;
  T := BCEditor1.Text;
  Editing := MdFindMarkupAt(T, S, False, MS, ME, UText, UTarget, UTitle);
  if Editing then
  begin
    Text := string(UText);
    Target := string(UTarget);
    Title := string(UTitle);
  end
  else
  begin
    Text := '';
    if E > S then
      Text := string(Copy(T, S + 1, E - S));
    Target := '';
    Title := '';
    MS := S;
    ME := E;
  end;
  if not MdShowLinkDialog(ThemeIsDark, Text, Target, Title) then
    Exit;
  Edit.Changed := True;
  Edit.StartOffset := MS;
  Edit.EndOffset := ME;
  Edit.InsertText := MdBuildLink(UnicodeString(Text), UnicodeString(Target),
    UnicodeString(Title));
  Edit.SelStart := MS + 1;
  Edit.SelEnd := MS + 1 + Length(UnicodeString(Text));
  ApplyMdEdit(Edit);
end;

// Same for images, plus the "copy into assets/" answer, which is remembered
// for the session (FImageCopyToAssets).
procedure TForm1.MdInsertImageCommand;
var
  S, E, MS, ME: Integer;
  T, UText, UTarget, UTitle: UnicodeString;
  Alt, Src, Title: string;
  Editing: Boolean;
  Edit: TMdEdit;
begin
  if not EditorSelection(S, E) then
    Exit;
  T := BCEditor1.Text;
  Editing := MdFindMarkupAt(T, S, True, MS, ME, UText, UTarget, UTitle);
  if Editing then
  begin
    Alt := string(UText);
    Src := string(UTarget);
    Title := string(UTitle);
  end
  else
  begin
    Alt := '';
    if E > S then
      Alt := string(Copy(T, S + 1, E - S));
    Src := '';
    Title := '';
    MS := S;
    ME := E;
  end;
  if not MdShowImageDialog(ThemeIsDark, ExtractFileDir(CurrentFile),
    Alt, Src, Title, FImageCopyToAssets) then
    Exit;
  Edit.Changed := True;
  Edit.StartOffset := MS;
  Edit.EndOffset := ME;
  Edit.InsertText := MdBuildImage(UnicodeString(Alt), UnicodeString(Src),
    UnicodeString(Title));
  Edit.SelStart := MS + 2;
  Edit.SelEnd := MS + 2 + Length(UnicodeString(Alt));
  ApplyMdEdit(Edit);
end;

procedure TForm1.MdInsertTableCommand;
var
  S, E, Rows, Cols: Integer;
begin
  if not EditorSelection(S, E) then
    Exit;
  Rows := 2;
  Cols := 3;
  if not MdShowTableDialog(ThemeIsDark, Rows, Cols) then
    Exit;
  ApplyMdEdit(MdInsertTable(BCEditor1.Text, S, Rows, Cols));
end;

// Ctrl+Space: the word before the caret is completed from the document, and
// pressing it again cycles through the candidates. No popup, so no focus game
// and nothing covers the text; the typed prefix is never replaced by itself.
procedure TForm1.MdCompleteWord;
var
  S, E, WStart, WEnd, RStart, REnd, i, Next: Integer;
  T, Prefix, Cand: UnicodeString;
  Cycling: Boolean;
  Edit: TMdEdit;
begin
  if not EditorSelection(S, E) then
    Exit;
  if S <> E then
    Exit;
  T := BCEditor1.Text;
  Prefix := MdWordBeforeCaret(T, S, WStart);
  // The caret may sit in the middle of a word that was already typed: the
  // candidate then replaces the whole word, not just what is left of the caret.
  WEnd := S;
  if MdWordRange(T, S, RStart, REnd) and (RStart = WStart) and (REnd >= S) then
    WEnd := REnd;
  Cycling := FComplActive and (FComplStart = WStart) and (FComplIndex >= 0)
    and (WEnd >= FComplStart)
    and (Copy(T, FComplStart + 1, WEnd - FComplStart) = FComplLast);
  if not Cycling then
  begin
    if Length(Prefix) < 2 then
      Exit;
    FComplWords := MdCollectWords(T, 2);
    FComplPrefix := Prefix;
    FComplStart := WStart;
    FComplIndex := -1;
    FComplActive := True;
  end;
  Next := -1;
  for i := 0 to High(FComplWords) do
    if (i > FComplIndex) and MdStartsWithText(FComplWords[i], FComplPrefix)
      and not MdEqualText(FComplWords[i], FComplPrefix) then
    begin
      Next := i;
      Break;
    end;
  if Next < 0 then
    // past the last candidate: start again from the first one
    for i := 0 to High(FComplWords) do
      if MdStartsWithText(FComplWords[i], FComplPrefix)
        and not MdEqualText(FComplWords[i], FComplPrefix) then
      begin
        Next := i;
        Break;
      end;
  if Next < 0 then
    Exit;
  Cand := FComplWords[Next];
  FComplIndex := Next;
  FComplLast := Cand;
  FComplCaret := FComplStart + Length(Cand);
  Edit.Changed := True;
  Edit.StartOffset := FComplStart;
  Edit.EndOffset := WEnd;
  Edit.InsertText := Cand;
  Edit.SelStart := FComplCaret;
  Edit.SelEnd := FComplCaret;
  ApplyMdEdit(Edit);
end;

function TForm1.AddMdMenuItem(AParent: TMenuItem; const ACaption: string;
  ACommand: TMdCommand; AShortCut: TShortCut): TMenuItem;
begin
  Result := TMenuItem.Create(AParent);
  Result.Caption := ACaption;
  Result.Tag := Ord(ACommand);
  Result.OnClick := MdCommandClick;
  if AShortCut <> 0 then
    Result.ShortCut := AShortCut;
  AParent.Add(Result);
end;

// The format bar: a plain panel of flat text buttons over the editor. It is an
// alTop control, so the align pass gives the panes below it the rest of the
// window -- the tree/editor/viewer order and widths are untouched.
procedure TForm1.BuildFormatBar;
var
  x: Integer;
  B: TSpeedButton;

  procedure AddBtn(const ACaption, AHint: string; ACmd: TMdCommand;
    AWidth: Integer; AStyle: TFontStyles);
  begin
    B := TSpeedButton.Create(FFormatBar);
    B.Parent := FFormatBar;
    B.Flat := True;
    B.Caption := ACaption;
    B.Hint := AHint;
    B.ShowHint := True;
    B.Left := x;
    B.Top := 3;
    B.Width := AWidth;
    B.Height := 24;
    B.Tag := Ord(ACmd);
    B.OnClick := MdCommandClick;
    B.Font.Style := AStyle;
    SetLength(FFormatButtons, Length(FFormatButtons) + 1);
    FFormatButtons[High(FFormatButtons)] := B;
    Inc(x, AWidth + 2);
  end;

begin
  if Assigned(FFormatBar) then
    Exit;
  FFormatBar := TPanel.Create(Self);
  FFormatBar.Parent := Self;
  FFormatBar.Align := alTop;
  FFormatBar.Height := 30;
  FFormatBar.BevelOuter := bvNone;
  FFormatBar.Caption := '';
  FFormatBar.Visible := False;
  x := 4;
  AddBtn('B', 'Bold (Ctrl+B)', mcBold, 26, [fsBold]);
  AddBtn('I', 'Italic (Ctrl+I)', mcItalic, 26, [fsItalic]);
  AddBtn('S', 'Strikethrough (Ctrl+Shift+X)', mcStrike, 26, []);
  AddBtn('<>', 'Inline code (Ctrl+`)', mcCode, 28, []);
  AddBtn('```', 'Code block (Ctrl+Shift+K)', mcCodeBlock, 32, []);
  AddBtn('H', 'Heading, cycles the # level (Ctrl+Shift+H)', mcHeading, 26, []);
  AddBtn('>', 'Quote (Ctrl+Shift+Q)', mcQuote, 26, []);
  AddBtn('*', 'Bullet list (Ctrl+Shift+U)', mcList, 26, []);
  AddBtn('1.', 'Numbered list (Ctrl+Shift+O)', mcOrdered, 26, []);
  AddBtn('[]', 'Task item (Ctrl+Shift+T)', mcTask, 26, []);
  AddBtn('Link', 'Link (Ctrl+K)', mcLink, 38, []);
  AddBtn('Image', 'Image (Ctrl+Shift+I)', mcImage, 44, []);
  AddBtn('Table', 'Table', mcTable, 46, []);
  AddBtn('---', 'Horizontal rule', mcRule, 30, []);
  AddBtn('Word', 'Complete word (Ctrl+Space)', mcCompleteWord, 42, []);
  ApplyFormatBarTheme;
end;

procedure TForm1.ApplyFormatBarTheme;
var
  i: Integer;
begin
  if not Assigned(FFormatBar) then
    Exit;
  for i := 0 to High(FFormatButtons) do
    FFormatButtons[i].Font.Color := FFormatBar.Font.Color;
end;



procedure TForm1.mnuEditorToggleClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;
  case TMenuItem(Sender).Tag of
    0: FEditorOpts.GutterVisible := not FEditorOpts.GutterVisible;
    1: FEditorOpts.RulerVisible := not FEditorOpts.RulerVisible;
    2: FEditorOpts.MinimapVisible := not FEditorOpts.MinimapVisible;
    3: FEditorOpts.UnprintedVisible := not FEditorOpts.UnprintedVisible;
    4: if FEditorOpts.WrapMode = Ord(TATEditorWrapMode.ModeOff) then
         FEditorOpts.WrapMode := Ord(TATEditorWrapMode.AtWindowOrMargin)
       else
         FEditorOpts.WrapMode := Ord(TATEditorWrapMode.ModeOff);
    5: FEditorOpts.ShowFormatBar := not FEditorOpts.ShowFormatBar;
    6: FEditorOpts.SmartEnter := not FEditorOpts.SmartEnter;
  end;
  ApplyEditorOptions;
  UpdateEditorMenuChecks;
  SaveINI;
end;

function TForm1.BuildPreviewList: TIdCaptionArray;
begin
  // What this build can actually show: IE is compiled in on Windows only, and
  // the JS engines need it.
  SetLength(Result, 2);
  Result[0].Id := pvHTML;
  Result[0].Caption := 'HTML (THtmlViewer)';
  Result[1].Id := pvMARKDOWN4D;
  Result[1].Caption := 'Canvas (Markdown4D)';
  {$IFDEF MSWINDOWS}
  SetLength(Result, 3);
  Result[2].Id := pvIE;
  Result[2].Caption := 'Internet Explorer (ActiveX)';
  {$ENDIF}
end;

function TForm1.BuildEngineList: TIdCaptionArray;
var
  n: Integer;
begin
  n := 0;
  {$IFDEF MSWINDOWS}
  // Off Windows the JS engines fall through to the native path, so listing
  // them would offer a pick that changes nothing.
  SetLength(Result, 7);
  Result[0].Id := mdPAGEDOWN;    Result[0].Caption := 'PageDown (JavaScript)';
  Result[1].Id := mdMARKDOWNJS;  Result[1].Caption := 'Markdown.js (JavaScript)';
  Result[2].Id := mdMARKED;      Result[2].Caption := 'Marked (JavaScript)';
  Result[3].Id := mdSHOWDOWN;    Result[3].Caption := 'ShowDown (JavaScript)';
  Result[4].Id := mdMARKDOWNIT;  Result[4].Caption := 'MarkdownIt (JavaScript)';
  n := 5;
  {$ELSE}
  SetLength(Result, 2);
  {$ENDIF}
  Result[n].Id := mdNATIVE;
  Result[n].Caption := 'Native Markdown (MyWiki)';
  Result[n + 1].Id := mdMARKDOWN4D;
  Result[n + 1].Caption := 'Native GFM (Markdown4D)';
end;

// The tabbed Options window. The dialog edits the records; the direction of
// travel is one way here: everything is applied (and saved) only after OK.
procedure TForm1.mnuOptionsClick(Sender: TObject);
var
  App: TMdAppOptions;
  oldPreview, oldEngine, oldZoom, oldMRU: Integer;
  oldTheme: TAppTheme;
  oldSyntax, oldCSS, oldSync, oldRemote: Boolean;
  oldFont: string;
begin
  oldFont := FEditorOpts.FontName;
  App.Theme := Ord(SelectedTheme);
  App.SyntaxEnabled := mnuSyntax.Checked;
  App.CSSEnabled := mnuCSS.Checked;
  App.SyncScroll := Synceditwithpreview1.Checked;
  App.RemoteImages := Loadremoteimages1.Checked;
  App.Preview := SelectedPreview;
  App.Engine := SelectedEngine;
  App.Zoom := TrackBar1.Position;
  App.MRULimit := FMRULimit;

  if not ShowOptionsDialog(FEditorOpts, App, BuildPreviewList, BuildEngineList) then
    Exit;

  oldPreview := SelectedPreview;
  oldEngine := SelectedEngine;
  oldZoom := TrackBar1.Position;
  oldMRU := FMRULimit;
  oldTheme := SelectedTheme;
  oldSyntax := mnuSyntax.Checked;
  oldCSS := mnuCSS.Checked;
  oldSync := Synceditwithpreview1.Checked;
  oldRemote := Loadremoteimages1.Checked;

  ApplyEditorOptions;
  UpdateEditorMenuChecks;

  if App.MRULimit <> oldMRU then
  begin
    FMRULimit := App.MRULimit;
    while FMRU.Count > FMRULimit do
      FMRU.Delete(FMRU.Count - 1);
    RebuildRecentMenu;
  end;

  mnuSyntax.Checked := App.SyntaxEnabled;
  SelectedTheme := TAppTheme(App.Theme);
  UpdateThemeInMenu;
  mnuCSS.Checked := App.CSSEnabled;

  SelectedPreview := App.Preview;
  SelectedEngine := App.Engine;
  UpdatePreviewInMenu;
  UpdateEngineInMenu;

  if App.Zoom <> oldZoom then
  begin
    TrackBar1.Position := App.Zoom;
    TrackBar1Change(Self);
  end;

  if App.SyncScroll <> oldSync then
  begin
    Synceditwithpreview1.Checked := App.SyncScroll;
    tmrScrollSyncer.Enabled := App.SyncScroll;
    if App.SyncScroll then
    begin
      // Same as Synceditwithpreview1Click: follow the editor at once instead
      // of waiting for the next tick.
      InvalidateScrollSync;
      SyncEditorToPreview;
      InvalidateScrollSync;
    end;
  end;

  if App.RemoteImages <> oldRemote then
  begin
    Loadremoteimages1.Checked := App.RemoteImages;
    ApplyRemoteImagesSetting(True);
  end;

  if mnuSyntax.Checked <> oldSyntax then
    ApplySyntaxEnabled;

  // The theme repaints the sheet the preview is drawn into, so it goes before
  // the engine is reloaded (ApplyTheme(True) re-renders with the old engine).
  // A font pick belongs here too: the previews' code font is the editor's.
  if (SelectedTheme <> oldTheme) or (mnuCSS.Checked <> oldCSS)
    or not SameText(FEditorOpts.FontName, oldFont) then
    ApplyTheme(True);

  if (SelectedPreview <> oldPreview) or (SelectedEngine <> oldEngine) then
  begin
    LoadEngine;
    UpdateResult;
    ApplyViewMode;
  end;

  SaveINI;
end;

// The lexer the editor should be highlighting with: none when the user turned
// syntax highlighting off, otherwise the one that matches the file.
function TForm1.LexerForCurrentFile: TecSyntAnalyzer;
begin
  Result := nil;
  if not Assigned(Manager) then
    Exit;
  if not mnuSyntax.Checked then
    Exit;
  Result := Lexer_FindForFilename(Manager, CurrentFile);
  // An untitled buffer has no extension to go by, and MDPad edits markdown:
  // highlight it as such instead of leaving the editor plain.
  if (Result = nil) and (CurrentFile = '') then
    Result := Manager.FindAnalyzer('Markdown');
end;

// Attaches or detaches the EControl lexer, which is what the syntax switch
// really does: with Adapter.Lexer = nil there are no token colors, no folding
// and no parse on keypress (the adapter is what re-parsed the buffer as you
// typed).
procedure TForm1.ApplySyntaxEnabled;
var
  HadCodeTree: Boolean;
begin
  if not Assigned(Adapter) then
    Exit;
  // EControl's own tree is only there for the non-markdown lexers (MDPad fills
  // the tree for markdown itself, from the render's headings). Detaching the
  // lexer frees the ranges those nodes point at, so the tree is rebuilt.
  HadCodeTree := Assigned(Adapter.Lexer) and not IsMarkdownLexer(Adapter.Lexer);
  Adapter.Lexer := LexerForCurrentFile;
  // The adapter only learns about the text through editor change events, and
  // neither loading a file nor attaching the lexer after the fact raises any:
  // without this the editor stays plain until the first keystroke. (The
  // reference demo does the same after it switches a lexer.)
  BCEditor1.DoEventChange(0, False);
  if HadCodeTree then
  begin
    ClearTOC;
    UpdateTOC;
  end;
end;

procedure TForm1.ApplyChromeColors(ADark: Boolean);
var
  Bg, Fg, Border: TColor;
begin
  if ADark then
  begin
    Bg := RGB($0D, $11, $17);
    Fg := RGB($C9, $D1, $D9);
    Border := RGB($30, $36, $3D);
  end
  else
  begin
    Bg := RGB($FF, $FF, $FF);
    Fg := RGB($1F, $23, $28);
    Border := RGB($D0, $D7, $DE);
  end;

  // The editor and the previews carry the content; the tree, the splitters and
  // the status bar are the chrome around them, and they follow the same theme
  // so the window does not end up half dark. Menus belong to the widgetset and
  // keep its own look.
  FThemeDark := ADark;
  Color := Bg;
  if Assigned(FFormatBar) then
  begin
    FFormatBar.Color := Bg;
    FFormatBar.Font.Color := Fg;
    ApplyFormatBarTheme;
  end;
  if Assigned(Tree) then
  begin
    Tree.Color := Bg;
    Tree.Font.Color := Fg;
    Tree.Invalidate;
  end;
  if Assigned(Splitter1) then
    Splitter1.Color := Border;
  if Assigned(Splitter2) then
    Splitter2.Color := Border;
  if Assigned(StatusBar1) then
  begin
    StatusBar1.Color := Bg;
    StatusBar1.Font.Color := Fg;
  end;
end;

// The canvas preview's palette. The built-in presets are Markdown4D's own
// light/dark themes; custom picks up Md4dTheme.json (a theme exported with
// Markdown4D's Theme.SaveToJson) when the custom theme is selected.
procedure TForm1.ApplyCanvasTheme(ADark: Boolean);
var
  Preset: TMarkdownThemePreset;
  FileName: string;
  CodeFont: string;
  Style: TMarkdownFontStyle;
  Theme: TMarkdownTheme;
begin
  if not Assigned(PreviewMd4D) then
    Exit;

  Preset := ThemePresetOf(ADark);
  FileName := ExtractFilePath(ParamStr(0)) + 'Md4dTheme.json';

  // The theme is MDPad's in either case: the viewer's Theme property only
  // borrows what it is given (SetTheme never frees it), and the code font has
  // to be set on the object *before* the assignment, or the canvas is not laid
  // out again with it.
  Theme := TMarkdownTheme.CreatePreset(Preset);
  if (SelectedTheme = atCUSTOM) and FileExists(FileName) then
    try
      Theme.LoadFromJson(LoadFileToStr(FileName));
    except
      // a broken file must not take the preview down: start from the preset
      FreeAndNil(Theme);
      Theme := TMarkdownTheme.CreatePreset(Preset);
    end;

  // Same face as the editor for code (see EditorCodeFontName): the canvas is
  // the one backend that draws the block itself, so a font that differs from
  // the editor's shifts columns and box drawing between the two panes.
  CodeFont := EditorCodeFontName;
  if CodeFont <> '' then
  begin
    Style := Theme.CodeFont;
    Style.FamilyName := CodeFont;
    Theme.CodeFont := Style;
  end;

  PreviewMd4D.Theme := Theme; // borrowed; FCanvasTheme owns it
  FreeAndNil(FCanvasTheme);
  FCanvasTheme := Theme;
end;

// The editor's font name when code may be drawn with it, '' otherwise. A
// proportional face would break the column alignment a code block is for, so
// only a monospace one is pinned (the HTML sheet and the canvas theme both call
// this). A known monospace family that is not installed still counts: both
// consumers fall back to an installed monospace face, while the widgetset's own
// fallback for an unknown family may be the proportional UI font.
function TForm1.EditorCodeFontName: string;
var
  Bmp: TBitmap;
begin
  Result := '';
  if not Assigned(BCEditor1) then
    Exit;
  Result := BCEditor1.Font.Name;
  if Result = '' then
    Exit;
  if TMarkdownViewerShared.IsMonospaceFamilyName(Result) then
    Exit;
  // Not a name we know: take the widgetset's word for it by measuring the face
  // it actually substitutes, which is what the editor draws with.
  Bmp := TBitmap.Create;
  try
    Bmp.Canvas.Font.Assign(BCEditor1.Font);
    if Bmp.Canvas.TextWidth('MMMM') <> Bmp.Canvas.TextWidth('iiii') then
      Result := '';
  finally
    Bmp.Free;
  end;
end;


// The previews' style sheet: the theme's base sheet, plus the user's style.css
// on top of it when "Enable Custom Style" is on. PreviewCSS is what the JS
// engines are loaded with (their HEADER opens the head); PreviewHtmlHead is the
// whole head the native HTML preview is rendered into.
procedure TForm1.RefreshPreviewStyle(ADark: Boolean);
var
  Css, Extra, FileName, CodeFont: string;
begin
  if ADark then
    Css := HTMLCSSDARK
  else
    Css := HTMLCSSLIGHT;

  // Code blocks use the editor's font when that is a monospace one (see
  // EditorCodeFontName): the same family as the editor, with monospace as the
  // fallback when the system does not have it. Appended after the sheet so it
  // wins over the sheet's own code rules, and before style.css so that file can
  // still override it.
  CodeFont := EditorCodeFontName;
  if CodeFont <> '' then
    Css := Css + sLineBreak
      + 'code,pre,kbd,samp,.md code,.md pre{font-family:"' + CodeFont
      + '",monospace;}';

  if mnuCSS.Checked then
  begin
    // style.css has always been a customization of the preview's look, not a
    // palette of its own, so it rides on top of the theme's rules.
    FileName := ExtractFilePath(ParamStr(0)) + 'style.css';
    if FileExists(FileName) then
    begin
      Extra := LoadFileToStr(FileName);
      if Extra <> '' then
        Css := Css + sLineBreak + Extra;
    end;
  end;
  Css := Css + sLineBreak + '</style>';

  PreviewCSS := Css + '</head>';
  PreviewHtmlHead := '<!DOCTYPE html>' + sLineBreak
    + '<html><head><meta http-equiv="X-UA-Compatible" content="IE=9" />'
    + '<meta charset="utf-8" /><title>MDPad</title>'
    + Css + '</head><body>';
end;

// Reads the custom theme file. Theme.json is BCEditor's theme format, the one
// MDPad has always shipped: Colors/Editor/Colors paints the editor's surface,
// the Elements list colors the token classes (mapped onto EControl's formats by
// EcontrolNamesForTheme). ADark is what the editor background asks for, and the
// rest of the app follows it so the editor and the previews agree.
procedure TForm1.LoadCustomTheme(out ADark: Boolean; out AOverrides: TThemeOverrides);
var
  FileName, Text: string;
  Root, Colors, Editor, Obj, Element: TJSONObject;
  Arr: TJSONArray;
  V: TJSONValue;
  I: Integer;
  Items: TThemeOverrides;
  Bg: TColor;

  procedure AddEntry(const AName: string; const AFore, ABack: TColor;
    AHasBg: Boolean; const AStyle: TFontStyles; AHasStyle: Boolean);
  var
    N: Integer;
  begin
    N := Length(Items);
    SetLength(Items, N + 1);
    Items[N].Name := AName;
    Items[N].FontColor := AFore;
    Items[N].BgColor := ABack;
    Items[N].HasBg := AHasBg;
    Items[N].Style := AStyle;
    Items[N].HasStyle := AHasStyle;
  end;

  function ElementStyle(const S: string): TFontStyles;
  begin
    Result := [];
    if Pos('Bold', S) > 0 then
      Include(Result, fsBold);
    if Pos('Italic', S) > 0 then
      Include(Result, fsItalic);
    if Pos('Underline', S) > 0 then
      Include(Result, fsUnderline);
    if Pos('Strike', S) > 0 then
      Include(Result, fsStrikeOut);
  end;

begin
  ADark := False;
  Items := nil;
  AOverrides := nil;

  FileName := ExtractFilePath(ParamStr(0)) + 'Theme.json';
  if not FileExists(FileName) then
  begin
    AOverrides := Items;
    Exit;
  end;

  V := TJSONObject.ParseJSONValue(UTF8String(LoadFileToStr(FileName)));
  if not (V is TJSONObject) then
  begin
    V.Free;
    AOverrides := Items;
    Exit;
  end;

  Root := TJSONObject(V);
  try
    Colors := JsonChildObject(Root, 'Colors');
    if Assigned(Colors) then
    begin
      Editor := JsonChildObject(Colors, 'Editor');
      Obj := JsonChildObject(Editor, 'Colors');
      if Assigned(Obj) then
      begin
        Bg := ThemeColorFromString(JsonText(Obj, 'Background'));
        if Bg <> clNone then
          ADark := ColorLuminance(Bg) < 128;
        for I := 0 to Obj.Count - 1 do
          AddEntry(UTF8Encode(Obj.Pairs[I].JsonString.Value),
            ThemeColorFromString(JsonText(Obj, UTF8Encode(Obj.Pairs[I].JsonString.Value))),
            clNone, False, [], False);
      end;

      Arr := JsonChildArray(Colors, 'Elements');
      if Assigned(Arr) then
        for I := 0 to Arr.Count - 1 do
        begin
          if not (Arr[I] is TJSONObject) then
            Continue;
          Element := TJSONObject(Arr[I]);
          AddEntry(JsonText(Element, 'Name'),
            ThemeColorFromString(JsonText(Element, 'Foreground')),
            ThemeColorFromString(JsonText(Element, 'Background')),
            Element.GetValue('Background') <> nil,
            ElementStyle(JsonText(Element, 'Style')),
            Element.GetValue('Style') <> nil);
        end;
    end;
  finally
    Root.Free;
  end;

  AOverrides := Items;
end;

// Paints every surface with the picked theme: the editor (its own colors and
// the EControl token colors), the table of contents and the window chrome, and
// whichever preview backend is on duty. AReloadPreview is False during startup,
// when there is no document to re-render yet.
procedure TForm1.ApplyTheme(AReloadPreview: Boolean);
var
  Dark: Boolean;
  Overrides: TThemeOverrides;
begin
  Overrides := nil;
  case SelectedTheme of
    atDARK:
      Dark := True;
    atLIGHT:
      Dark := False;
    atSYSTEM:
      Dark := SystemPrefersDark;
  else
    // Custom: the background Theme.json asks the editor for decides whether the
    // rest of the app is painted light or dark.
    Dark := False;
    LoadCustomTheme(Dark, Overrides);
  end;

  if Assigned(BCEditor1) then
  begin
    SetEditorPalette(BCEditor1.Colors, Dark);
    if SelectedTheme = atCUSTOM then
      ApplyEditorOverrides(BCEditor1.Colors, Overrides);
    BCEditor1.Invalidate;
  end;

  if Assigned(Manager) then
  begin
    SetLexerPalette(Manager, Dark);
    if SelectedTheme = atCUSTOM then
      ApplyLexerOverrides(Manager, Overrides);
  end;

  ApplyChromeColors(Dark);
  ApplyCanvasTheme(Dark);
  RefreshPreviewStyle(Dark);
  UpdateThemeInMenu;

  // Colors (and, for the canvas, fonts) changed: the HTML anchor table and the
  // editor/preview pairing describe the old rendering.
  InvalidateHtmlAnchors;
  InvalidateScrollSync;

  if not AReloadPreview then
    Exit;

  if UsingMarkdown4D then
    // ApplyCanvasTheme's SetTheme already laid the document out again with the
    // new theme (and its code font) and asked for a repaint; the next sync tick
    // re-anchors the view.
    Exit;

  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    // The JS engines live in the IE document itself: it has to be built again
    // with the new sheet, and the markdown pushed into it after that.
    LoadEngine;
    ReloadingEngine := True;
    Screen.Cursor := crHourGlass;
    Exit;
  end;
  {$ENDIF}

  // The native HTML preview re-renders through the worker, which puts the new
  // PreviewHtmlHead in front of the same body.
  UpdateResult;
end;


// "Enable Custom Style": puts the user's style.css on top of the theme's own
// sheet. Only the previews carry a style sheet, so re-applying the theme
// reloads them with the new one; the editor palette is unaffected.
procedure TForm1.mnuCSSClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  SaveINI;
  ApplyTheme(True);
end;

// "Enable Syntax highlighter": with it off the EControl lexer is detached from
// the editor (Adapter.Lexer := nil), which is what makes the editor plain text
// -- no token colors, no folding, no parse on keypress. The pick is written to
// settings.ini right here, like the engine and the preview backend.
procedure TForm1.mnuSyntaxClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  SaveINI;
  ApplySyntaxEnabled;
end;

// The picks of the Theme submenu: System, Light, Dark, Custom (the item Tag is
// the TAppTheme value, see markdownviewer_src.lfm).
procedure TForm1.mnuThemeSelect(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;
  SelectedTheme := TAppTheme(TMenuItem(Sender).Tag);
  UpdateThemeInMenu;
  // The picked theme is what the next start should use, so it goes to disk
  // right here: the save on exit never runs if the process is killed.
  SaveINI;
  ApplyTheme(True);
end;

// by default
// 1 = PageDown
// 2 = MarkdownJS
// 3 = Marked
procedure TForm1.ToggleEngine(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin

    SelectedEngine := TMenuItem(Sender).Tag;
    UpdateEngineInMenu;
    // The picked engine is what the next start should use, so it goes to disk
    // right here: the save on exit never runs if the process is killed, crashes
    // or hangs on a worker.
    SaveINI;
    LoadEngine;
    {$IFDEF MSWINDOWS}
    if UsingIE then
    begin
      ReloadingEngine := True;
      Screen.Cursor := crHourGlass;
    //    UpdateResult; // we need to updateresult when webbrowser is ready
    end
    else
    {$ENDIF}
      UpdateResult; //THtmlViewer loads synchronously, refresh right away
    ApplyViewMode;
  end;

end;

// Picking a preview backend is orthogonal to picking a markdown engine: the JS
// engines always mean IE on Windows, THtmlViewer and Markdown4D both render the
// native pipeline's output (HTML vs. canvas). Markdown4D ignores SelectedEngine.
procedure TForm1.TogglePreview(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    SelectedPreview := TMenuItem(Sender).Tag;
    UpdatePreviewInMenu;
    // Same as the engine pick: remember the backend at once, not only on exit.
    SaveINI;
    LoadEngine;
    UpdateResult;
    ApplyViewMode;
  end;
end;

procedure TForm1.UpdatePreviewInMenu;
begin
  PreviewHtml1.Checked := SelectedPreview = pvHTML;
  PreviewMarkdown4D1.Checked := SelectedPreview = pvMARKDOWN4D;
  {$IFDEF MSWINDOWS}
  PreviewIE1.Checked := SelectedPreview = pvIE;
  {$ELSE}
  PreviewIE1.Visible := False;
  {$ENDIF}
end;

//fixing arrow navigation of twebbrowser
procedure TForm1.BCEditor1CaretChanged(Sender: TObject);
begin
  UpdateCaretStatus;
end;

procedure TForm1.BCEditor1Change(Sender: TObject);
begin
  if Waitafewsecondsbeforeupdatingthepreview1.Checked or needtodelay then
  begin
    TDelay:=DELAYTIME;
    tmrKeyEvent.Enabled:=True;
  end
  else
    UpdateResult;
end;

procedure TForm1.BCEditor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Cont: TMdContinuation;
  C: TATCaretItem;
  Line: UnicodeString;
  i, Fences: Integer;
begin
  // Smart Enter: a list item, a quote or a task continues itself, and an empty
  // one exits the block instead of starting another. Only the plain Enter, and
  // only at the end of the line: mid-line splitting stays the editor's job.
  if (Key = VK_RETURN) and (Shift = []) and FEditorOpts.SmartEnter
    and Assigned(BCEditor1) and (BCEditor1.Carets.Count > 0) then
  begin
    C := BCEditor1.Carets[0];
    if C.EndX < 0 then
    begin
      Line := BCEditor1.Strings.Lines[C.PosY];
      Fences := 0;
      i := C.PosY - 1;
      while i >= 0 do
      begin
        if MdIsFenceLine(BCEditor1.Strings.Lines[i]) then
          Inc(Fences);
        Dec(i);
      end;
      Cont := MdContinuation(Line, C.PosX, Odd(Fences));
      if Cont.Kind = mdContinue then
      begin
        // The editor's own Enter (it knows the auto-indent), then the marker,
        // as one undo step.
        BCEditor1.Strings.BeginUndoGroup;
        try
          BCEditor1.DoCommand(cCommand_KeyEnter, TATCommandInvoke.Hotkey);
          if Cont.Prefix <> '' then
            BCEditor1.TextInsertAtCarets(Cont.Prefix, False, False, False);
        finally
          BCEditor1.Strings.EndUndoGroup;
        end;
        Key := 0;
        Exit;
      end;
      if Cont.Kind = mdExitList then
      begin
        BCEditor1.Carets[0].Change(0, C.PosY, C.PosX, C.PosY);
        BCEditor1.DoCommand(cCommand_TextDeleteSelection, TATCommandInvoke.Internal);
        Key := 0;
        Exit;
      end;
    end;
  end;

  // The Markdown commands. The menu items carry the same ShortCut for display,
  // but TWinControl checks the popup menu's shortcuts only after the key went
  // through this handler, and this consumes it, so nothing runs twice.
  if Shift = [ssCtrl] then
  begin
    case Key of
      Ord('B'): begin MdExecute(mcBold); Key := 0; Exit; end;
      Ord('I'): begin MdExecute(mcItalic); Key := 0; Exit; end;
      Ord('K'): begin MdExecute(mcLink); Key := 0; Exit; end;
      VK_SPACE: begin MdExecute(mcCompleteWord); Key := 0; Exit; end;
      VK_OEM_3: begin MdExecute(mcCode); Key := 0; Exit; end;
      Ord('`'): begin MdExecute(mcCode); Key := 0; Exit; end;
    end;
  end
  else if Shift = [ssCtrl, ssShift] then
  begin
    case Key of
      Ord('X'): begin MdExecute(mcStrike); Key := 0; Exit; end;
      Ord('K'): begin MdExecute(mcCodeBlock); Key := 0; Exit; end;
      Ord('H'): begin MdExecute(mcHeading); Key := 0; Exit; end;
      Ord('Q'): begin MdExecute(mcQuote); Key := 0; Exit; end;
      Ord('U'): begin MdExecute(mcList); Key := 0; Exit; end;
      Ord('O'): begin MdExecute(mcOrdered); Key := 0; Exit; end;
      Ord('T'): begin MdExecute(mcTask); Key := 0; Exit; end;
      Ord('I'): begin MdExecute(mcImage); Key := 0; Exit; end;
    end;
  end;
end;

procedure TForm1.BCEditor1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //status bar follows the caret (also covered by OnChangeCaretPos)
  UpdateCaretStatus;
end;



{ Cross-platform editor: plain TATSynEdit is used directly (BCEditor1),
  selection/clipboard go through its native DoCommand API. The old
  Win32 user32 context-menu hack and EM_* selection emulation are gone,
  replaced by the EditorPopup TPopupMenu built in FormCreate. }

{$IFDEF MSWINDOWS}
procedure TForm1.CMDialogKey(var Message: TCMDialogKey);
begin
  if GetAsyncKeyState(VK_MENU)>=0 then
  begin
    case Message.CharCode of
      VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:
      if Assigned(BrowserContainer) and (ActiveControl=BrowserContainer) then
      begin
        Message.Result:=0;
        exit;
      end;
    end;
  end;
  inherited;
end;
{$ENDIF}

// Which pane the user moved last, so both follow each other. The mapping never
// guesses: the canvas backend maps a source line to the Y it was laid out at
// (pictures, tables and code blocks included), and THtmlViewer, which has no
// line map, is driven from the headings of the HTML it has rendered.
procedure TForm1.tmrScrollSyncerTimer(Sender: TObject);
begin
  // A backend switch renders into a canvas that has no width yet, so the outline
  // it could read was empty; the layout happens once it is shown. Adopt it again
  // when the layout has moved on, or the tree would stay empty until an edit.
  if UsingMarkdown4D and (PreviewMd4D.LayoutCount <> FCanvasLayoutCount) then
    AdoptCanvasOutline;

  if not ((Synceditwithpreview1.Checked) and (BCEditor1.Visible)
  and (ActivePreview.Visible)) then
    Exit;

  // Typing moves the caret and re-renders the preview in the same instant, so
  // the editor wins whenever both look moved; the other way round the preview
  // would drag the markdown back to where the re-render left it.
  if (BCEditor1.LineTop <> FSyncEditorLine)
  or ((BCEditor1.Carets.Count > 0) and (BCEditor1.Carets[0].PosY <> FSyncCaretLine)) then
    SyncEditorToPreview
  else if PreviewScrollPos <> FSyncPreviewPos then
    SyncPreviewToEditor;
end;

// Where the active preview is scrolled to, in whatever unit its backend uses.
// Only the tick reads it, to tell which of the two panes the user moved.
function TForm1.PreviewScrollPos: Integer;
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
    Exit(SyncPercentage); // a scriptable DOM reports nothing back
  {$ENDIF}
  if UsingMarkdown4D then
    Exit(Round(PreviewMd4D.ScrollOffset));
  Result := PreviewHtml.VScrollBarPosition;
end;

// Scrolling the editor, never moving the caret: the preview follows what is
// being read, not where the cursor was left.
procedure TForm1.SetEditorTopLine(ALine: Integer);
begin
  if ALine < 0 then
    ALine := 0;
  if ALine > BCEditor1.Strings.Count - 1 then
    ALine := BCEditor1.Strings.Count - 1;
  if BCEditor1.LineTop <> ALine then
    BCEditor1.LineTop := ALine;
end;

// A new document, a re-render or another backend leaves the mapping pointing at
// content that is no longer on screen: the editor becomes the reference again.
procedure TForm1.InvalidateScrollSync;
begin
  FSyncEditorLine := -1;
end;

// Puts what the editor is reading at the top of the preview. The caret line is
// only pushed into view when it would fall outside, which is what keeps the
// preview steady while typing (TMarkdownPreviewScroll.OffsetShowingLine).
procedure TForm1.SyncEditorToPreview;
var
  TopLine, CaretLine, LineCount, percentage: Integer;
  Target: Single;
  TargetY, CaretY, CaretBottomY: Integer;
  {$IFDEF MSWINDOWS}
  js: string;
  {$ENDIF}
begin
  TopLine := BCEditor1.LineTop;
  if BCEditor1.Carets.Count > 0 then
    CaretLine := BCEditor1.Carets[0].PosY
  else
    CaretLine := TopLine;

  {$IFDEF MSWINDOWS}
  // A scriptable DOM has no line map either, so the JS engines keep the coarse
  // line ratio: they are the one backend nothing better can drive.
  if UsingIE then
  begin
    LineCount := BCEditor1.Strings.Count - 1;
    if LineCount < 1 then
      LineCount := 1;
    percentage := TopLine * 100 div LineCount;
    if percentage < 0 then
      percentage := 0
    else if percentage > 100 then
      percentage := 100;

    if SyncPercentage <> percentage then
    begin
      SyncPercentage := percentage;
      try
        js := 'document.documentElement.scrollTop='+inttostr(percentage)+'/100*document.documentElement.scrollHeight';
        ExecuteScript(Browser.ComServer.Document as IHTMLDOcument2, js, 'javascript');
      except
      end;
    end;

    FSyncEditorLine := TopLine;
    FSyncCaretLine := CaretLine;
    FSyncPreviewPos := SyncPercentage;
    Exit;
  end;
  {$ENDIF}

  if UsingMarkdown4D then
  begin
    // Exact: every rendered line knows the source line it came from, so the
    // editor's top line is pinned to the top and the caret line only pulled in.
    Target := TMarkdownPreviewScroll.OffsetShowingLine(
      PreviewMd4D.SourceLineToScrollOffset(TopLine),
      PreviewMd4D.SourceLineToScrollOffset(CaretLine),
      PreviewMd4D.SourceLineToScrollOffset(CaretLine + 1),
      PreviewMd4D.ClientHeight);
    if not SameValue(PreviewMd4D.ScrollOffset, Target) then
      PreviewMd4D.ScrollOffset := Target;
  end
  else
  begin
    // Same "keep the line in view" rule, in pixels: the heading anchors say
    // where each line is, so an image above it cannot skew the result.
    if HtmlLineToY(TopLine, TargetY) then
    begin
      if HtmlLineToY(CaretLine, CaretY) and HtmlLineToY(CaretLine + 1, CaretBottomY) then
        TargetY := Round(TMarkdownPreviewScroll.OffsetShowingLine(TargetY, CaretY, CaretBottomY,
          PreviewHtml.ClientHeight));
      if PreviewHtml.VScrollBarRange > 0 then
        PreviewHtml.VScrollBarPosition := Max(0, Min(TargetY, PreviewHtml.VScrollBarRange));
    end
    else if PreviewHtml.VScrollBarRange > 0 then
    begin
      // Nothing to anchor on (the HTML has no headings): line ratio, as before.
      LineCount := BCEditor1.Strings.Count - 1;
      if LineCount < 1 then
        LineCount := 1;
      PreviewHtml.VScrollBarPosition := TopLine * PreviewHtml.VScrollBarRange div LineCount;
    end;
  end;

  FSyncEditorLine := TopLine;
  FSyncCaretLine := CaretLine;
  FSyncPreviewPos := PreviewScrollPos;
end;

// The other way round: what the preview shows at its top becomes the editor's
// top line, so scrolling the rendered document moves the markdown with it.
procedure TForm1.SyncPreviewToEditor;
var
  Line, LineCount: Integer;
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
    Exit; // one-way on the JS engines
  {$ENDIF}

  if UsingMarkdown4D then
    Line := PreviewMd4D.ScrollOffsetToSourceLine(PreviewMd4D.ScrollOffset)
  else if not HtmlYToLine(PreviewHtml.VScrollBarPosition, Line) then
  begin
    LineCount := BCEditor1.Strings.Count - 1;
    if LineCount < 1 then
      LineCount := 1;
    if PreviewHtml.VScrollBarRange > 0 then
      Line := PreviewHtml.VScrollBarPosition * LineCount div PreviewHtml.VScrollBarRange
    else
      Line := 0;
  end;

  SetEditorTopLine(Line);
  FSyncEditorLine := BCEditor1.LineTop;
  if BCEditor1.Carets.Count > 0 then
    FSyncCaretLine := BCEditor1.Carets[0].PosY;
  FSyncPreviewPos := PreviewScrollPos;
end;

// The worker that rendered the HTML hands its headings over: they carry the
// source line and the id each heading was written with, which is what the viewer
// is later asked to scroll to.
procedure TForm1.AdoptHeaders(AList: TObjectList<THeaderItem>);
begin
  FreeAndNil(FHeaders);
  FHeaders := AList;
  InvalidateHtmlAnchors;
end;

// The canvas backend parses the document itself, so its outline -- not the
// worker -- is where the heading list and the table of contents come from. The
// HTML anchor table is left alone: the canvas scroll sync maps a source line
// straight to an offset and never reads it.
procedure TForm1.AdoptCanvasOutline;
begin
  // Which layout this table came from: the viewer lays the document out lazily
  // (no viewport width, no document), so the tick has to know whether the
  // outline it just read is the one the layout built.
  FCanvasLayoutCount := PreviewMd4D.LayoutCount;
  AdoptHeaders(HeadersFromOutline(PreviewMd4D.Toc));
  UpdateTOC;
end;

procedure TForm1.InvalidateHtmlAnchors;
begin
  FSyncAnchorRange := -1; // the table describes HTML that is going away
end;

procedure TForm1.EnsureHtmlAnchors;
begin
  if FSyncAnchorRange = PreviewHtml.VScrollBarRange then
    Exit;
  BuildHtmlAnchors;
end;

// Measures the anchor table: the two ends of the document plus every heading the
// rendered HTML actually has. The viewer keeps a name -> section map of what it
// parsed (the one an in-page link jump uses) and reports the exact Y each
// heading was drawn at, so no height is ever estimated.
procedure TForm1.BuildHtmlAnchors;
var
  Index, At, Y, LastLine: Integer;
  Names: TIDObjectList;
begin
  SetLength(FSyncAnchorLine, 0);
  SetLength(FSyncAnchorY, 0);
  FSyncAnchorRange := PreviewHtml.VScrollBarRange;
  if (FHeaders = nil) or (FHeaders.Count = 0) or (PreviewHtml.SectionList = nil) then
    Exit;

  Names := PreviewHtml.SectionList.IDNameList;
  if Names = nil then
    Exit;

  AddHtmlAnchor(0, 0);
  for Index := 0 to FHeaders.Count - 1 do
  begin
    if FHeaders[Index].Id = '' then
      Continue;
    // The viewer stores the ids it parsed and compares without case, so the id
    // MDPad knows is enough (and it keeps accents intact: no case mangling).
    At := Names.IndexOf(FHeaders[Index].Id);
    if At < 0 then
      Continue;
    Y := Names.Objects[At].YPosition;
    AddHtmlAnchor(FHeaders[Index].Line, Y);
  end;

  LastLine := BCEditor1.Strings.Count - 1;
  if LastLine < 0 then
    LastLine := 0;
  AddHtmlAnchor(LastLine, PreviewHtml.VScrollBarRange);
end;

// Keeps the table sorted and strictly increasing in both line and Y; anything
// that would break that (two headings on one line, a heading above the previous
// one) is dropped instead of bending the interpolation.
procedure TForm1.AddHtmlAnchor(ALine, AY: Integer);
var
  Count: Integer;
begin
  if ALine < 0 then
    ALine := 0;
  if AY < 0 then
    AY := 0;
  Count := Length(FSyncAnchorLine);
  if (Count > 0)
  and ((ALine <= FSyncAnchorLine[Count - 1]) or (AY < FSyncAnchorY[Count - 1])) then
    Exit;
  SetLength(FSyncAnchorLine, Count + 1);
  SetLength(FSyncAnchorY, Count + 1);
  FSyncAnchorLine[Count] := ALine;
  FSyncAnchorY[Count] := AY;
end;

// The Y the HTML preview draws a source line at, interpolated inside the stretch
// between the two headings around it. False when the document has no headings to
// anchor on, which is when the caller falls back to the line ratio.
function TForm1.HtmlLineToY(ALine: Integer; out AY: Integer): Boolean;
var
  Index, Count, FromLine, ToLine: Integer;
begin
  AY := 0;
  EnsureHtmlAnchors;
  Count := Length(FSyncAnchorLine);
  if Count < 2 then
    Exit(False);

  if ALine <= FSyncAnchorLine[0] then
  begin
    AY := FSyncAnchorY[0];
    Result := True;
    Exit;
  end;
  if ALine >= FSyncAnchorLine[Count - 1] then
  begin
    AY := FSyncAnchorY[Count - 1];
    Result := True;
    Exit;
  end;

  for Index := 0 to Count - 2 do
  begin
    FromLine := FSyncAnchorLine[Index];
    ToLine := FSyncAnchorLine[Index + 1];
    if (ALine >= FromLine) and (ALine <= ToLine) then
    begin
      AY := FSyncAnchorY[Index]
        + ((ALine - FromLine) * (FSyncAnchorY[Index + 1] - FSyncAnchorY[Index])
           div Max(1, ToLine - FromLine));
      Result := True;
      Exit;
    end;
  end;

  AY := FSyncAnchorY[Count - 1];
  Result := True;
end;

// The inverse, so scrolling the preview moves the editor to the line then on
// screen.
function TForm1.HtmlYToLine(AY: Integer; out ALine: Integer): Boolean;
var
  Index, Count, FromY, ToY: Integer;
begin
  ALine := 0;
  EnsureHtmlAnchors;
  Count := Length(FSyncAnchorY);
  if Count < 2 then
    Exit(False);

  if AY <= FSyncAnchorY[0] then
  begin
    ALine := FSyncAnchorLine[0];
    Result := True;
    Exit;
  end;
  if AY >= FSyncAnchorY[Count - 1] then
  begin
    ALine := FSyncAnchorLine[Count - 1];
    Result := True;
    Exit;
  end;

  for Index := 0 to Count - 2 do
  begin
    FromY := FSyncAnchorY[Index];
    ToY := FSyncAnchorY[Index + 1];
    if (AY >= FromY) and (AY <= ToY) then
    begin
      ALine := FSyncAnchorLine[Index]
        + ((AY - FromY) * (FSyncAnchorLine[Index + 1] - FSyncAnchorLine[Index])
           div Max(1, ToY - FromY));
      Result := True;
      Exit;
    end;
  end;

  ALine := FSyncAnchorLine[Count - 1];
  Result := True;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  vIn, vOut: OleVariant;
{$ENDIF}
const
  ZoomPct: array[0..5] of Integer = (50, 75, 100, 125, 150, 200);
var
  pos: Integer;
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    vOut:=NULL;
    with TrackBar1 do
    begin
      if Position = 0 then
  //      WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.25
        vIn := 50
      else if Position = 1 then
  //      WebBrowser1.OleObject.Document.Body.Style.Zoom:=0.5
        vIn := 75
      else if Position = 2 then
  //      WebBrowser1.OleObject.Document.Body.Style.Zoom:=1.0
        vIn := 100
      else if Position = 3 then
  //      WebBrowser1.OleObject.Document.Body.Style.Zoom:=2.0
        vIn := 125
      else if Position = 4 then
  //      WebBrowser1.OleObject.Document.Body.Style.Zoom:=5.0
        vIn := 150
      else if Position = 5 then
        //WebBrowser1.OleObject.Document.Body.Style.Zoom:=10.0;
        vIn:=200;
      Browser.ComServer.ExecWB(OLECMDID_OPTICAL_ZOOM,OLECMDEXECOPT_DONTPROMPTUSER,vIn,vOut);
    end;
    Exit;
  end;
  {$ENDIF}
  // Markdown4D has a real optical zoom, so the trackbar maps straight to it.
  if UsingMarkdown4D then
  begin
    pos := TrackBar1.Position;
    if pos < Low(ZoomPct) then
      pos := Low(ZoomPct)
    else if pos > High(ZoomPct) then
      pos := High(ZoomPct);
    PreviewMd4D.Zoom := ZoomPct[pos];
    // Every line just moved: measure the mapping again from the editor.
    InvalidateScrollSync;
    Exit;
  end;
  //THtmlViewer has no optical zoom: scale the default font size instead
  pos := TrackBar1.Position;
  if pos < Low(ZoomPct) then
    pos := Low(ZoomPct)
  else if pos > High(ZoomPct) then
    pos := High(ZoomPct);
  PreviewHtml.DefFontSize := PreviewBaseFontSize * ZoomPct[pos] div 100;
  InvalidateScrollSync;
  InvalidateHtmlAnchors;
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  BCEditor1.DoCommand(cCommand_Undo, TATCommandInvoke.MenuMain);
end;

procedure TForm1.New1Click(Sender: TObject);
var
  confirm: integer;
  canwestartnew: boolean;
begin
  if textBuffer <> BCEditor1.Text then
  begin
    canwestartnew :=false;
    confirm := MessageDlg('Your document has been modified'#13'Do you want to save those changes?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
    if confirm = mrYes then
    begin
      Save1Click(sender);
      canwestartnew:=true;
    end
    else if confirm = mrNo then
      //let's open a new file
      canwestartnew:=true;
//    else if confirm = mrCancel then
      //let's continue
  end
  else
  begin
    canwestartnew:=true;
  end;

  if canwestartnew then
  begin
    CurrentFile:='';
    BCEditor1.Text:='';
    textBuffer := BCEditor1.Text;
    needtodelay:=false;
    UpdateResult; //clears the preview in both viewers
    Caption := 'MDPad - untitled';
  end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if not CanOpenAnotherFile then
    Exit;
  with OpenDialog1 do
  begin
    Filter:='MarkDown files|*.md;*.mkd;*.markdown|*.*|*.*';
    if Execute then
    begin
      OpenMDFile(filename);
      AddToMRU(filename);
    end;
  end;
end;



procedure TForm1.Pageconfig1Click(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  vIn, vOut: OleVariant;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    Browser.ComServer.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
    Exit;
  end;
  {$ENDIF}
  with TPrinterSetupDialog.Create(Self) do
  try
    Execute;
  finally
    Free;
  end;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  BCEditor1.DoCommand(cCommand_ClipboardPaste, TATCommandInvoke.MenuMain);
end;

procedure TForm1.Print1Click(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  vIn, vOut:OleVariant;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    Browser.ComServer.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
    Exit;
  end;
  {$ENDIF}
  if UsingMarkdown4D then
    PrintMarkdown4D
  else
    PrintHtmlViewer;
end;

// THtmlViewer on Linux has no metafile printing (upstream defines
// NoMetaFile outside Windows), so print page by page as bitmaps.
procedure TForm1.PrintHtmlViewer;
var
  Bmp: TBitmap;
  DocH, YTop, PageH: Integer;
begin
  with TPrintDialog.Create(Self) do
  try
    if not Execute then
      Exit;
  finally
    Free;
  end;
  if CurrentFile <> '' then
    Printer.Title := 'MDPad - ' + CurrentFile
  else
    Printer.Title := 'MDPad';
  DocH := PreviewHtml.FullDisplaySize(Printer.PageWidth).cy;
  if DocH < 1 then
    Exit;
  Printer.BeginDoc;
  try
    PageH := Printer.PageHeight;
    if PageH < 1 then
      PageH := DocH;
    YTop := 0;
    while YTop < DocH do
    begin
      Bmp := PreviewHtml.MakeBitmap(YTop, Printer.PageWidth, Printer.PageWidth, PageH);
      try
        if Assigned(Bmp) then
          Printer.Canvas.Draw(0, 0, Bmp);
      finally
        Bmp.Free;
      end;
      Inc(YTop, PageH);
      if YTop < DocH then
        Printer.NewPage;
    end;
  finally
    Printer.EndDoc;
  end;
end;

// Markdown4D draws on a canvas, so printing lays the document out at the page
// width and renders it page by page through an offscreen bitmap (the same trick
// PrintHtmlViewer uses, since neither viewer has a printer of its own).
procedure TForm1.PrintMarkdown4D;
const
  TargetPPI = 150; // resolution the page bitmaps are rendered at
var
  Bmp: TBitmap;
  Painter: TMarkdownLclPainter;
  // The painter also serves as the layout's text measurer. Hold it in an
  // IPainter as well: FPC's interface table does not carry an ancestor
  // interface, so `Painter as ITextMeasurer` raises EInvalidCast at run time
  // even though IPainter descends from ITextMeasurer. Passing this IPainter
  // value where an ITextMeasurer is expected is a plain upcast and works.
  //
  // Ownership: the interface reference is the owner. Never call Painter.Free
  // while it exists -- FPC's TInterfacedObject.Free on a refcounted object
  // raises EInvalidPointer -- release it by clearing PainterLifetime instead.
  PainterLifetime: IPainter;
  Document: IMarkdownDocument;
  DisplayList: IMarkdownDisplayList;
  Theme: TMarkdownTheme;
  OwnTheme: Boolean;
  PageW, PageH, DocH, YTop, PPI, PrinterPPI: Integer;
begin
  with TPrintDialog.Create(Self) do
  try
    if not Execute then
      Exit;
  finally
    Free;
  end;
  if CurrentFile <> '' then
    Printer.Title := 'MDPad - ' + CurrentFile
  else
    Printer.Title := 'MDPad';

  // FPC's TPrinter reports its resolution through XDPI/YDPI.
  PrinterPPI := Printer.YDPI;
  PPI := TargetPPI;
  if (PrinterPPI > 0) and (PrinterPPI < PPI) then
    PPI := PrinterPPI;
  PageW := Round(Printer.PageWidth * PPI / PrinterPPI);
  PageH := Round(Printer.PageHeight * PPI / PrinterPPI);
  if (PageW < 1) or (PageH < 1) then
    Exit;

  // Print what the preview shows: same theme it is rendering with.
  OwnTheme := False;
  Theme := PreviewMd4D.Theme;
  if not Assigned(Theme) then
  begin
    Theme := TMarkdownTheme.CreateLight;
    OwnTheme := True;
  end;
  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(PageW, PageH);
    Painter := TMarkdownLclPainter.Create(Bmp.Canvas, PPI);
    PainterLifetime := Painter;
    try
      Document := TMarkdown.Parse(BCEditor1.Text, TMarkdownDialect.Gfm);
      // The painter doubles as the text measurer (IPainter descends from
      // ITextMeasurer), so the layout and the drawing share one object.
      DisplayList := TMarkdownLayoutEngine.LayoutDocument(Document, PageW, Theme, PainterLifetime);
      if (DisplayList = nil) or (DisplayList.ItemCount = 0) then
        Exit;
      DocH := Ceil(DisplayList.Height);
      Printer.BeginDoc;
      try
        YTop := 0;
        while YTop < DocH do
        begin
          // OriginY names the document Y that maps to the top of the canvas, and
          // the viewport is given in document coordinates (as the viewer does).
          Painter.OriginY := YTop;
          TMarkdownDisplayListRenderer.Render(DisplayList, PainterLifetime,
            TLayoutRectF.Create(0, YTop, PageW, YTop + PageH), Theme.BackgroundColor);
          Printer.Canvas.StretchDraw(Rect(0, 0, Printer.PageWidth, Printer.PageHeight), Bmp);
          Inc(YTop, PageH);
          if YTop < DocH then
            Printer.NewPage;
        end;
      finally
        Printer.EndDoc;
      end;
    finally
      // Release the painter through the interface (see the note at the top of
      // this procedure): Painter must be cleared first, then the reference that
      // actually owns the object.
      Painter := nil;
      PainterLifetime := nil;
    end;
  finally
    Bmp.Free;
    if OwnTheme then
      Theme.Free;
  end;
end;

procedure TForm1.PerformConversion;
begin
  if FShuttingDown then
    Exit;
  TInterlocked.Increment(FCurrentRequestID);

  // El worker anterior quedó obsoleto (su RequestID ya no es el vigente):
  // pedirle que termine evita acumular conversiones en ráfagas de tipeo.
  // Se libera solo (FreeOnTerminate); ConversionTerminated nil-ea la referencia.
  if Assigned(FWorker) then
    FWorker.Terminate;

  PreviewHtml.Cursor := crHourGlass;
  StatusBar1.Panels[1].Text := 'Converting...';

   TInterlocked.Increment(FActiveTaskCount);

   // Instanciamos el hilo pasándole los datos necesarios
   FWorker := TConversionThread.Create(BCEditor1.Text, FCurrentRequestID, SelectedEngine);
   FWorker.OnTerminate := ConversionTerminated;
   FWorker.Start; // Inicia la tarea
end;

procedure TForm1.ConversionTerminated(Sender: TObject);
begin
  // Corre en el main thread. No liberar aquí: el thread es FreeOnTerminate
  // y se libera solo; solo nil-eamos si sigue siendo el vigente.
  if Sender = FWorker then
    FWorker := nil;
end;

procedure TForm1.PrintPreview1Click(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  vIn, vOut: OleVariant;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if UsingIE then
  begin
//thanks to http://delphi.about.com/cs/adptips2004/a/bltip0504_5.htm
    Browser.ComServer.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
    Exit;
  end;
{$ENDIF}
  //THtmlViewer has no scriptable print preview; use Print instead
  Print1Click(Sender);
end;

procedure TForm1.Waitafewsecondsbeforeupdatingthepreview1Click(Sender: TObject);
begin
  Waitafewsecondsbeforeupdatingthepreview1.Checked := not Waitafewsecondsbeforeupdatingthepreview1.Checked;
  SaveINI;
end;

{$IFDEF MSWINDOWS}
procedure TForm1.WebBrowser1BeforeNavigate2(ASender: TObject;pDisp:IDispatch;var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant;var Cancel:WordBool);
var
  ExternalRender: string;
begin
//  ShowMessage(URL);
  ExternalRender:=ExtractFilePath(ParamStr(0))+'somdeditor\index.html';
  if (Pos(ExternalRender,URL)>0)
  or (Pos('file:///'+stringreplace(ExtractFilePath(ParamStr(0))+'somdeditor\index.html','\','/',[rfReplaceAll]),URL)>0)
  or (Pos('about:blank',URL)>0)
  then
  begin
    cancel:=false;
  end
  else
  begin //let's open in the webbrowser
    cancel:=true;
    if pos('http',URL)=1 then
      OpenURL(string(URL));
  end;
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;pDisp:IDispatch;var URL:OleVariant);
begin
  if (ReadingFromExplorer) and (ParamCount>0) then
  begin
    ReadingFromExplorer:=False;
    Resultonly1Click(Form1);
    OpenMDFile(ParamStr(1));
    AddToMRU(ParamStr(1));
  end
  else if ReloadingEngine then
  begin
    ReloadingEngine := False;
    UpdateResult;
    Screen.Cursor := crDefault;
  end;
end;
{$ENDIF}

{procedure TForm1.WMContextMenu(var message: TWMContextMenu);
var
  wnd: HWND;
  ctrl: TWinControl;
begin
  if message.XPos > 0 then
  begin
    wnd := WindowFromPoint(Mouse.CursorPos);
    if wnd <> handle then
    begin
      ctrl := FindControl(wnd);
      if Assigned(ctrl) and (ctrl is TCustomEdit) then
        Exit;
    end;
  end
  else if ActiveControl is TCustomEdit then
    Exit;

  inherited;
end;}

procedure TForm1.Wordwrap1Click(Sender: TObject);
begin
  // Same switch as Editor > Word wrap and the Options dialog: the menu used to
  // toggle OptWrapIndented (which only affects wrapped lines), so with wrapping
  // off by default it looked like it did nothing.
  mnuEditorToggleClick(mnuEditorWrap);
end;

procedure TForm1.Loadremoteimages1Click(Sender: TObject);
begin
  Loadremoteimages1.Checked := not Loadremoteimages1.Checked;
  ApplyRemoteImagesSetting(True);
  SaveINI;
end;

end.
