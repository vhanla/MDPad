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
  Menus, ExtCtrls, ComCtrls,
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
  // Where a scroll offset keeps a source line in view (the same helper the
  // library's own editors use to follow an editor without yanking the preview).
  Markdown4D.Editor.PreviewScroll,
  Markdown4D.Ast.Interfaces,
  Markdown4D.Theme,
  Markdown4D.Layout.Interfaces,
  Markdown4D.Layout.Engine,
  Markdown4D.Layout.Renderer,
  Markdown4D.Layout.DisplayList,
  Markdown4D.Lcl.ImageDecoder,
  Markdown4D.Lcl.MathFont,
  Markdown4D.Lcl.Painter,
  Markdown4D.Lcl.Viewer;

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
    mnuCSS: TMenuItem;  procedure FormCreate(Sender: TObject);
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
    procedure mnuThemeClick(Sender: TObject);
    procedure mnuCSSClick(Sender: TObject);
    procedure Loadremoteimages1Click(Sender: TObject);
    procedure BCEditor1CaretChanged(Sender: TObject);
    procedure EditorPopupClick(Sender: TObject);
    procedure PreviewHotSpotClick(Sender: TObject; const SRC: ThtString; var Handled: Boolean);
  private
    TrackBar1_Position:integer;
    SelectedEngine: Integer;
    SelectedPreview: Integer; // pvHTML / pvMARKDOWN4D / pvIE

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
    procedure InvalidateHtmlAnchors;
    procedure EnsureHtmlAnchors;
    procedure BuildHtmlAnchors;
    procedure AddHtmlAnchor(ALine, AY: Integer);
    function HtmlLineToY(ALine: Integer; out AY: Integer): Boolean;
    function HtmlYToLine(AY: Integer; out ALine: Integer): Boolean;
    // Images the document names relative to itself have to resolve next to the
    // document, not relative to wherever MDPad was started from.
    procedure ApplyPreviewBaseFolder;
    // Mirrors the "Load remote images" menu item into the canvas viewer and
    // makes its images change accordingly.
    procedure ApplyRemoteImagesSetting(Reload: Boolean);
    procedure ApplyViewMode;
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

    procedure UpdateEngineInMenu;
    procedure LoadEngine(const DefaultText: string = '');

    procedure UpdatePreviewInMenu;
    procedure PreviewLinkClick(const Sender: TObject; const Url: UnicodeString);

    procedure EditorChangeCaretPos(Sender: TObject);
    procedure AdapterParseDone(Sender: TObject; ATime: integer);
    procedure AdapterParseBegin(Sender: TObject);

    {$IFDEF MSWINDOWS}
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    {$ENDIF}
    //procedure WMContextMenu(var message: TWMContextMenu); message WM_CONTEXTMENU;
  public
    { Public declarations }
  end;
type
  Comodin=class(TControl); //for scrolling
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
  PreviewCSS: string;
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
uses {$IFDEF MSWINDOWS}activex, registry,{$ENDIF} inifiles, LCLIntf, Printers, PrintersDlgs, Types, Math;
{$R *.lfm}

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

{ TConversionThread }

procedure TConversionThread.SyncUpdateUI;
begin
   // Este método corre en el hilo principal (Main Thread)
   if Form1.FShuttingDown then
     Exit; // el form se está destruyendo, no tocar la UI
   if FRequestID = Form1.FCurrentRequestID then
   begin
     LastPreviewBody := FHtmlResult;
     PreviewHtml.Text := GITHUBCSS + FHtmlResult + '</body></html>';
     // The headings of the HTML just rendered are the anchor points the scroll
     // sync needs; the form owns them from here on.
     Form1.AdoptHeaders(FHeaders);
     FHeaders := nil;
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
begin
  try
    if FEngine = mdMARKDOWN4D then
    begin
      // Markdown4D renders markdown -> HTML in process: its Core is plain
      // Pascal and the shared pipeline cache is monitor-guarded, so a worker
      // thread is fine. No header list here: the code tree comes from the
      // EControl adapter, not from the engine.
      //
      // UnsafeHtml (not ToHtml) on purpose: it keeps raw HTML in the document,
      // which is what the other engines do (MyWiki; the JS ones on Windows) and
      // what the Markdown4D canvas renders (`HtmlBlock` is laid out, see
      // Markdown4D.Layout.Engine). The GFM tag filter is still applied by the
      // pipeline, so <script>/<style>/<iframe>/... are escaped either way — the
      // same list MyWiki escapes. ToHtml would instead drop every raw HTML
      // block, so a document like markdowntest.md (mostly raw HTML) would lose
      // most of its content.
      FHtmlResult := TMarkdown.ToUnsafeHtml(FMarkdown, TMarkdownDialect.Gfm);
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

  BCEditor1.Visible:=True;
  BCEditor1.Align:=alLeft;

  ActivePreview.Visible:=True;
  ActivePreview.Align:=alClient;
  Splitter1.Enabled:=True;

  // let's disable wordwrap first, otherwise BCEditor will raise error
  // it might have to do with resizing width while wordwrap, weird
  prevwrdwrp := BCEditor1.OptWrapIndented;
  if prevwrdwrp then
    BCEditor1.OptWrapIndented := False;

  //let's use a variable to keep the position
//  Memo1.Width:=ClientWidth div 2;
//  WebBrowser1.Width:=ClientWidth div 2;
  BCEditor1.Width:=Trunc(ViewersRatio/100*ClientWidth);
  ActivePreview.Width:=ClientWidth-BCEditor1.Width;
  Splitter1.Left:=ActivePreview.Left;

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
  BCEditor1.Visible:=True;
  ActivePreview.Align:=alNone;
  BCEditor1.Align:=alClient;
   
  Splitter1.Enabled:=False;
  ActivePreview.Visible:=False;

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
  BCEditor1.Visible:=False;
  ActivePreview.Visible:=True;
  Splitter1.Enabled:=False;
  BCEditor1.Align:=alNone;
  ActivePreview.Align:=alClient;
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
        if Assigned(Adapter) then
          Adapter.Lexer := Lexer_FindForFilename(Manager, CurrentFile);
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
          +#13' File</title><meta http-equiv="X-UA-Compatible" content="IE=9" ><meta charset="utf-8">'+CSS+'</head><body><div id="readme"><div class="md">'
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
begin
  FontDialog1.Font:=BCEditor1.Font;
  if FontDialog1.Execute() then
  begin
    BCEditor1.Font:= FontDialog1.Font;
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
  mi: TMenuItem;
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
  Adapter.OnParseBegin:=AdapterParseBegin;
  Adapter.OnParseDone:=AdapterParseDone;
  Adapter.AddEditor(BCEditor1);
  Adapter.Lexer := Lexer_FindForFilename(Manager, CurrentFile);

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
  mi := TMenuItem.Create(EditorPopup); mi.Caption := '-'; EditorPopup.Items.Add(mi);
  mi := TMenuItem.Create(EditorPopup); mi.Caption := 'Select &All'; mi.Tag := cCommand_SelectAll; mi.OnClick := EditorPopupClick; EditorPopup.Items.Add(mi);
  BCEditor1.PopupMenu := EditorPopup;

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
  PreviewMd4D.ThemePreset := TMarkdownThemePreset.Light;

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

  LoadINI;

  if mnuCSS.Checked then
  begin
    if FileExists(ExtractFilePath(ParamStr(0))+'Style.css') then
      PreviewCSS := '<style type="text/css">'+ LoadFileToStr(ExtractFilePath(ParamStr(0))+'Style.css') +'</style></head>';
  end
  else
      PreviewCSS := CSS;

  //highlight color and editor color
  if not mnuTheme.Checked then
  begin
    {{st := TStringStream.Create(DEFAULTTHEME);
    try
      BCEditor1.Highlighter.Colors.LoadFromStream(st);
    finally
      FreeAndNil(st);
    end;}
  end
  else
  begin
    {{if FileExists(ExtractFilePath(ParamStr(0))+'Theme.json') then
      BCEditor1.Highlighter.Colors.LoadFromFile(ExtractFilePath(ParamStr(0))+ 'Theme.json');}
  end;
  {{if mnuSyntax.Checked then
    if FileExists(ExtractFilePath(ParamStr(0))+'Markdown.json') then
      BCEditor1.Highlighter.LoadFromFile(ExtractFilePath(ParamStr(0))+'MarkDown.json');}

  textBuffer := BCEditor1.Text;
  // let's load the configured engine
  LoadEngine;
  //apply the saved view mode (editor/result layout) to the active preview
  ApplyViewMode;

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
      OpenMDFile(ParamStr(1));
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // Avisar a los workers y esperarlos: su Synchronize necesita que el main
  // bombee la cola, y SyncUpdateUI sale temprano gracias a FShuttingDown.
  // Sin esto, un worker vivo tocaría PreviewHtml/Form1 ya liberados -> GPF.
  FShuttingDown := True;
  while FActiveTaskCount > 0 do
  begin
    CheckSynchronize(0);
    Sleep(5);
  end;
//save ini settings
  SaveINI;
  FreeAndNil(FHeaders);
  BCEditor1.Text := '';
  BCEditor1.Free;
  {$IFDEF MSWINDOWS}
  FreeAndNil(Browser);
  //Browser.Free;
  BrowserContainer.Free;
  {$ENDIF}
  PreviewHtml.Free;
  PreviewMd4D.Free;
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
      Adapter.Lexer := Lexer_FindForFilename(Manager, CurrentFile);
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
begin
  ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'settings.ini');
    try
      ini.WriteString('MDPad','fontname',BCEditor1.Font.Name);
      ini.WriteInteger('MDPad','fontsize',BCEditor1.Font.Size);

      ini.WriteInteger('MDPad','fontcolor',BCEditor1.Font.Color);

      ini.WriteBool('MDPad','sync',Synceditwithpreview1.Checked);
      ini.WriteBool('MDPad','delay',Waitafewsecondsbeforeupdatingthepreview1.Checked);
      ini.WriteBool('MDPad','statusbar',Statusbar2.Checked);
      ini.WriteBool('MDPad','wordwrap',Wordwrap1.Checked);

      ini.WriteInteger('Window','editorposition',ViewersRatio);
      if WindowState=wsNormal then
      begin
      ini.WriteInteger('Window','width',Width);
      ini.WriteInteger('Window','height',Height);
      end;
      ini.WriteInteger('Preview','zoom',TrackBar1.Position);

      ini.WriteInteger('MDPad', 'engine', SelectedEngine);
      ini.WriteInteger('MDPad', 'preview', SelectedPreview);

      ini.WriteBool('MDPad', 'syntaxenabled', mnuSyntax.Checked);
      ini.WriteBool('MDPad', 'themeenabled', mnuTheme.Checked);
      ini.WriteBool('MDPad', 'cssenabled', mnuCSS.Checked);
      ini.WriteBool('MDPad', 'remoteimages', Loadremoteimages1.Checked);
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
    // Unsafe (raw HTML kept), so the exported page matches what the canvas
    // draws: the layout engine lays out HtmlBlock nodes instead of hiding them.
    Result := TMarkdown.ToUnsafeHtml(BCEditor1.Text, TMarkdownDialect.Gfm)
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
    InvalidateScrollSync;
    Exit;
  end;
  // THtmlViewer path (default everywhere): synchronous full-document load,
  // the native engine renders the markdown on UpdateResult
  PreviewHtml.LoadFromString(HEADER + PreviewCSS + OPENCONTAINER + DefaultText + CLOSECONTAINER + FOOTER);
  // LoadEngine runs on a new document (or a backend switch), so the heading list
  // and the anchor table of the previous one no longer describe the preview.
  AdoptHeaders(nil);
  InvalidateScrollSync;
end;

procedure TForm1.EditorChangeCaretPos(Sender: TObject);
var
  NLine: integer;
begin
  if BCEditor1.Carets.Count>0 then
    with BCEditor1.Carets[0] do
      CodetreeSelectItemForPosition(Tree, PosX, PosY, NLine);
end;

procedure _OnTreeDuplicateNode(ANode: TTreeNode; const AFileName: string);
begin
  //empty
end;

procedure TForm1.AdapterParseDone(Sender: TObject; ATime: integer);
begin
  adapter.TreeFill(Tree, 1000, false, '?', @_OnTreeDuplicateNode);
  EditorChangeCaretPos(Self);
end;

procedure TForm1.AdapterParseBegin(Sender: TObject);
begin
  Tree.Items.Clear;
end;

procedure TForm1.LoadINI;
var
ini:tinifile;
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
      Wordwrap1.Checked:=ini.ReadBool('MDPad','wordwrap',false);

      BCEditor1.OptWrapIndented := Wordwrap1.Checked;

      ViewersRatio:=ini.ReadInteger('Window','editorposition',50);
      Width:=ini.ReadInteger('Window','width',771);
      Height:=ini.ReadInteger('Window','height',472);

      TrackBar1_Position:= ini.ReadInteger('Preview','zoom',2);

      SelectedEngine := ini.ReadInteger('MDPad', 'engine', 6); //default set to native
      SelectedPreview := ini.ReadInteger('MDPad', 'preview', pvHTML);
      {$IFNDEF MSWINDOWS}
      // The IE backend only exists on Windows; a settings.ini carried over from
      // a Windows run must not leave the preview without a control.
      if SelectedPreview = pvIE then
        SelectedPreview := pvHTML;
      {$ENDIF}

      mnuSyntax.Checked := ini.ReadBool('MDPad', 'syntaxenabled', false);
      mnuTheme.Checked := ini.ReadBool('MDPad', 'themeenabled', false);
      mnuCSS.Checked := ini.ReadBool('MDPad', 'cssenabled', false);

      Loadremoteimages1.Checked := ini.ReadBool('MDPad', 'remoteimages', true);
      ApplyRemoteImagesSetting(False);

      UpdateEngineInMenu;
      UpdatePreviewInMenu;

    finally
      ini.Free;
    end;

end;

procedure TForm1.mnuCSSClick(Sender: TObject);
var
  chk: boolean;
begin
  chk := not TMenuItem(Sender).Checked;
  TMenuItem(Sender).Checked := chk;
  if chk then
  begin
    if FileExists(ExtractFilePath(ParamStr(0))+'Style.css') then
      PreviewCSS := '<style type="text/css">'+ LoadFileToStr(ExtractFilePath(ParamStr(0))+'Style.css') +'</style></head>';
  end
  else
    PreviewCSS := CSS;
  // update the viewer CSS
  LoadEngine;
  {$IFDEF MSWINDOWS}
  if UsingIE then
  begin
    ReloadingEngine := True;
    Screen.Cursor := crHourGlass;
  end
  else
  {$ENDIF}
    UpdateResult;
end;

procedure TForm1.mnuSyntaxClick(Sender: TObject);
var
  chk: boolean;
  st: TStringStream;
begin
  chk := not TMenuItem(sender).Checked;
  TMenuItem(sender).Checked := chk;

  if chk then
  begin
    {{if FileExists(ExtractFilePath(ParamStr(0))+'Markdown.json') then
      BCEditor1.Highlighter.LoadFromFile(ExtractFilePath(ParamStr(0))+'MarkDown.json');}
  end
  else
  begin
    (*(*st := TStringStream.Create('{}');
    try
      BCEditor1.Highlighter.LoadFromStream(st);
    finally
      FreeAndNil(st);
    end;*)
  end;
end;

procedure TForm1.mnuThemeClick(Sender: TObject);
var
  chk : boolean;
  st: TStringStream;
begin
  chk := not TMenuItem(sender).Checked;
  TMenuItem(sender).Checked := chk;

  if chk then
  begin
    {{if FileExists(ExtractFilePath(ParamStr(0))+'Theme.json') then
      BCEditor1.Highlighter.Colors.LoadFromFile(ExtractFilePath(ParamStr(0))+ 'Theme.json');}
  end
  else
  begin
    {{st := TStringStream.Create(DEFAULTTHEME);
    try
      BCEditor1.Highlighter.Colors.LoadFromStream(st);
    finally
      FreeAndNil(st);
    end;}
  end;
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
begin
{  if(Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    TMemo(Sender).SelectAll;
    Key := 0;
  end;} //superseded by hot key on menu
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
var
  confirm: integer;
  canweopen: boolean;
begin
  if textBuffer <> BCEditor1.Text then
  begin
    canweopen :=false;
    confirm := MessageDlg('Your document has been modified'#13'Do you want to save those changes?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
    if confirm = mrYes then
    begin
      Save1Click(sender);
      canweopen:=true;
    end
    else if confirm = mrNo then
      //let's open a new file
      canweopen:=true;
//    else if confirm = mrCancel then
      //let's continue
  end
  else
  begin
    canweopen:=true;
  end;

  if canweopen then
  with OpenDialog1 do
  begin
    Filter:='MarkDown files|*.md;*.mkd;*.markdown|*.*|*.*';
    if Execute then
    begin
      OpenMDFile(filename);
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
  Wordwrap1.Checked:=not Wordwrap1.Checked;
  BCEditor1.OptWrapIndented := Wordwrap1.Checked;
end;

procedure TForm1.Loadremoteimages1Click(Sender: TObject);
begin
  Loadremoteimages1.Checked := not Loadremoteimages1.Checked;
  ApplyRemoteImagesSetting(True);
end;

end.
