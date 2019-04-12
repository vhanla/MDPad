{
  MDPad v1.1
  by vhanla
  -----------------
  This is a desktop version of ShowDown port to javascript

  Initial release
  2012-06-06
  +Everything in executable, no external html files

  Changelog:
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
unit markdownviewer_src;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  Menus, ExtCtrls, ComCtrls, ActiveXContainer, MSHTML_4_0_TLB,
  markdownprocessor, SHDocVw_1_1_TLB, ATSynEdit;

type
  TBCEditor = class(ATSynEdit.TATSynEdit)
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
//    procedure MouseUp(AButton: TMouseButton; AShift: TShiftState; X, Y: Integer); override;
  protected
    function GetSelLength: Integer; virtual;
    function GetSelStart: Integer;
    procedure SetSelLength(const Value: Integer);
    procedure SetSelStart(const Value: Integer);
  public
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
  end;

  { TWebBrowser }

  TWebBrowser = class(SHDocVw_1_1_TLB.TEvsWebBrowser)
    procedure CNChar(var Message: TWMChar);message CN_CHAR;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;
type

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
    tmrScrollSyncer: TTimer;
    Synceditwithpreview1: TMenuItem;
    Engines1: TMenuItem;
    engPageDown: TMenuItem;
    engMarkDownJS: TMenuItem;
    engMarked: TMenuItem;
    engShowDown: TMenuItem;
    engMarkdownit: TMenuItem;
    engNative: TMenuItem;
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
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;pDisp:IDispatch;var URL:OleVariant;var Flags:OleVariant;var TargetFrameName:OleVariant;var PostData:OleVariant;var Headers:OleVariant;var Cancel:WordBool);
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
    procedure WebBrowser1DocumentComplete(Sender: TObject;pDisp:IDispatch;var URL:OleVariant);
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
    procedure BCEditor1DblClick(Sender: TObject);
    procedure BCEditor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BCEditor1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure ToggleEngine(Sender: TObject);
    procedure mnuSyntaxClick(Sender: TObject);
    procedure mnuThemeClick(Sender: TObject);
    procedure mnuCSSClick(Sender: TObject);
    procedure BCEditor1CaretChanged(ASender: TObject; ACaretPos: TPoint);
  private
    TrackBar1_Position:integer;
    SelectedEngine: Integer;
    { Private declarations }
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

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
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
const
  DELAYTIME = 10;
var
  Form1: TForm1;
  BCEditor1: TBCEditor;
  BrowserContainer: TActiveXContainer;
  Browser: TWebBrowser;
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
  FSelPos: Integer;//for find dialog
  TDelay: Integer=DELAYTIME; //10 seconds before update changes
  needtodelay: boolean = false; //when bigger files are opened we force to slow down
  // URLMON para quitar el feo sonido al iniciar cada enlace
  const
    SET_FEATURE_ON_PROCESS = $00000002;
    FEATURE_DISABLE_NAVIGATION_SOUNDS = 21;
  function CoInternetSetFeatureEnabled(FeatureEntry: DWORD; dwFlags: DWORD; fEnable: BOOL): HRESULT; stdcall; external 'urlmon.dll';


{$include pagedown.inc}

implementation
uses shellapi, activex, registry, inifiles;
{$R *.lfm}

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
  if Assigned(Self) then  self.Destroy;
  inherited Destroy;
end;

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

procedure TForm1.About1Click(Sender: TObject);
begin
//  ShellAbout(Handle, 'MDPad', 'MDPad v1.1 beta'#13'Written by vhanla - http://apps.codigobit.info', Application.Icon.Handle);
  if FileExists(ExtractFilePath(ParamStr(0))+'Readme.md') then
  begin
    if MessageDlg(ABOUTMDPAD+#13#13'Want to read more about?',mtInformation, mbYesNo, 0) = mrYes then
      ShellExecute(0, 'OPEN', PChar(ParamStr(0)),PChar(ExtractFilePath(ParamStr(0))+'Readme.md'),nil,SW_SHOWNORMAL);
  end
  else
    MessageDlg(ABOUTMDPAD,mtInformation, [mbOK], 0);
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  if BCEditor1.GetSelLength > 0 then
    BCEditor1.TextSelected; //CopyToClipboard;
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  if BCEditor1.GetSelLength > 0 then
    BCEditor1.TextSelected; //CutToClipboard;
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

  BrowserContainer.Visible:=True;
  BrowserContainer.Align:=alClient;
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
  BrowserContainer.Width:=ClientWidth-BCEditor1.Width;
  Splitter1.Left:=BrowserContainer.Left;

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
  BrowserContainer.Align:=alNone;
  BCEditor1.Align:=alClient;
   
  Splitter1.Enabled:=False;
  BrowserContainer.Visible:=False;

  //focus
  BCEditor1.SetFocus;
end;

procedure TForm1.Registerfilestoopenwith1Click(Sender: TObject);
var
  r: TRegistry;
begin
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
end;

procedure TForm1.Resultonly1Click(Sender: TObject);
begin
  tmrHiddenElements.Enabled:=True;
  Editoronly1.Checked:=False;
  Resultonly1.Checked:=True;
  EditorandResult1.Checked:=False;
  BCEditor1.Visible:=False;
  BrowserContainer.Visible:=True;
  Splitter1.Enabled:=False;
  BCEditor1.Align:=alNone;
  BrowserContainer.Align:=alClient;
  //focus
//  WebBrowser1.SetFocus;
  //good tricks at http://stackoverflow.com/a/918869/537347
  // i guess they copied from here http://www.swissdelphicenter.ch/torry/showcode.php?id=1940
  with Browser.ComServer do
  if Document <> nil then
  with Application as IOleObject do
  DoVerb(OLEIVERB_UIACTIVATE, nil, BrowserContainer, 0, Handle, GetClientRect);

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

  case SelectedEngine of
    mdPAGEDOWN: engPageDown.Checked := True;
    mdMARKDOWNJS: engMarkDownJS.Checked := True;
    mdMARKED: engMarked.Checked := True;
    mdSHOWDOWN: engShowDown.Checked := True;
    mdMARKDOWNIT: engMarkdownit.Checked := True;
    mdNATIVE : engNative.Checked := True;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.ExportHTML1Click(Sender: TObject);
var
  Rel: IHTMLElement;
  HTMLText: TMemo;
begin
  Rel:=GetElementById(Browser.ComServer.Document,'resultado') as IHTMLElement;
  if Assigned(Rel) then
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
          +Rel.innerHTML+'</div></div><code>Created by <a href="http://apps.codigo'
          +'bit.info/2012/06/markdown-pad-markdown-textfile-editor.html" target="_blank">MDPad v1.1</a> Thanks to <a href="https://code.google.com/p/pagedown/" target="_blank">Pagedown</a></code></body></html>';

          //HTMLText.Lines.SaveToFile(FileName,TEncoding.UTF8);
          HTMLText.Lines.SaveToFile(FileName);
          //let's offer the change to open its folder
          if MessageDlg('Exported successfully'#13'Would you like to open its location folder?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
            ShellExecute(GetDesktopWindow,'OPEN',pchar(ExtractFilePath(FileName)),nil,nil,SW_SHOW);
        finally
          HTMLText.Free;
        end;


      end;
    end;
  end;
end;

procedure TForm1.Find1Click(Sender: TObject);
begin
  FSelPos:=0;
//  FindDialog1.Execute;
  BCEditor1.SelStart := 1;
  BCEditor1.SelLength := 2;
  BCEditor1.SetFocus;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  S : string;
  startpos : integer;
begin
  with TFindDialog(Sender) do
  begin
    {If the stored position is 0 this cannot be a find next. }
    if FSelPos = 0 then
      Options := Options - [frFindNext];

     { Figure out where to start the search and get the corresponding
       text from the memo. }
    if frfindNext in Options then
    begin
      { This is a find next, start after the end of the last found word. }
      StartPos := FSelPos + Length(Findtext);
      S := Copy(BCEditor1.Text, StartPos, MaxInt);
    end
    else
    begin
      { This is a find first, start at the, well, start. }
      S := BCEditor1.Text;
      //BCEditor1.SearchString := FindText;
      StartPos := 1;
    end;
    { Perform a global case-sensitive search for FindText in S }
    FSelPos := Pos(FindText, S);
    if FSelPos > 0 then
    begin
       { Found something, correct position for the location of the start
         of search. }
      FSelPos := FSelPos + StartPos - 1;
      BCEditor1.SelStart := FSelPos - 1;
      BCEditor1.SelLength := Length(FindText);
      BCEditor1.SetFocus;
      //Memo1.SelStart := FSelPos - 1;
      //Memo1.SelLength := Length(FindText);
      //Memo1.SetFocus;

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
begin
  Application.OnActivate:=OnFocus;
  Caption := 'MDPad';

  BCEditor1 := TBCEditor.Create(Self);
  BCEditor1.SetParent(Self);
  BCEditor1.OnChange := BCEditor1Change;
  BCEditor1.OnDblClick := BCEditor1DblClick;
  BCEditor1.OnKeyDown := BCEditor1KeyDown;
  BCEditor1.OnKeyUp := BCEditor1KeyUp;
{{  BCEditor1.OnChangeCaretPos := BCEditor1CaretChanged;}

//  memo1.Visible:=false;
//////////////////  BCEditor1.ScrollBars:=ssBoth;
  BCEditor1.OptWrapIndented := True;
//  Form1.WindowProc:=ScrollWheel;
///  KeyPreview := True;
//  SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
  SetPriorityClass(GetCurrentProcess, $4000);//below normal al parecer mejor de IDLE

  // Create WebBrowser instance
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

  CurrentFile:=''; //none
  //let's open with explorer
  if ParamCount>0 then
    ReadingFromExplorer:=True
  else
    ReadingFromExplorer:=False;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//save ini settings
  SaveINI;
  BCEditor1.Text := '';
  BCEditor1.Free;
  FreeAndNil(Browser);
  //Browser.Free;
  BrowserContainer.Free;
end;

//thanks to http://beensoft.blogspot.com/2007/10/fooling-around-with-twebbrowser-4.html
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
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
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0)
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if EditorandResult1.Checked then
    EditorandResult1Click(Sender);
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
  ShellExecute(GetDesktopWindow,'OPEN','http://daringfireball.net/projects/markdown/syntax',nil,nil,SW_SHOW);
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
    BrowserContainer.Active := False;
    BorderStyle:=bsSizeable;
    BrowserContainer.Active := True;
    WBLoadHTML(Browser, '');
    LoadEngine;
    ReloadingEngine := True;
    { TODO: Restore last position of WebViewer after refresh }
    if PrevWindowState = wsMaximized then
      //Perform(WM_SYSCOMMAND, SC_MAXIMIZE,0)
      WindowState := wsMaximized
    else
      Perform(WM_SYSCOMMAND, SC_RESTORE,0);
      //WindowState := wsNormal;
  end
  else
  begin
    //fulscreen
    FullScreen1.Checked:=True;
    BrowserContainer.Active := False;
    BorderStyle:=bsNone;
    BrowserContainer.Active := True;
    WBLoadHTML(Browser, '');
    LoadEngine;
    ReloadingEngine := True;
    PrevWindowState:=WindowState;
    if WindowState = wsMaximized then
      Perform(WM_SYSCOMMAND, SC_RESTORE,0);
      //WindowState := wsNormal;
    Sleep(10);
    //Perform(WM_SYSCOMMAND, SC_MAXIMIZE,0);
    WindowState := wsMaximized;
  end;
end;

procedure TForm1.OpenMDFile(const fn: string);
var
  Elem: IHTMLElement;
//  script: string;
///  docs: IHTMLDocument3;
///  pos1,pos2:integer;
begin
  // let's make sure the engine is fully loaded before loading content into it
  Elem:= GetElementById(Browser.ComServer.Document,'resultado') as IHTMLElement;
  if Assigned(elem) then
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
    BCEditor1.LoadFromFile(fn);
//        if (Length(BCEditor1.Text)>10000)
    if BCEditor1.GetTextLen > 10000
    then needtodelay:=true
    else needtodelay:=false;

    textBuffer:=BCEditor1.Text; //buffered to see changes
//        memo1.Text:=StringReplace(memo1.Text,'```','    ',[rfReplaceAll]);
    CurrentFile:=fn;
    Caption := 'MDPad - '+fn;
    UpdateResult; //update the rendering
  end;

end;

procedure TForm1.OnFocus(Sender: TObject);
begin
  //ShowMessage('ac');
  if (BrowserContainer.Visible) and not (BCEditor1.Visible) then
    with Browser.ComServer do
      if Document <> nil then
        with Application as IOleObject do
          DoVerb(OLEIVERB_UIACTIVATE, nil, BrowserContainer, 0, Handle, GetClientRect);
end;

procedure TForm1.UpdateResult;
var
  Elem: IHTMLElement;
  md: TMarkdownProcessor;
begin
{  if (Length(Memo1.Text)>10000)
  and not WebBrowser1.Visible then
  exit;}

  // we won't need to refresh a simple part of the html if native engine is chosen
  if SelectedEngine = mdNative then
  begin
    md := TMarkdownProcessor.CreateDialect(mdDaringFireball);
    try
      // then continue with the update
      Elem:= GetElementById(Browser.ComServer.Document,'resultado') as IHTMLElement;
      if Assigned(Elem) then
      begin
        Elem.innerHTML:=md.process(BCEditor1.Text);
      end;
    finally
      md.Free;
    end;
  end
  else // but we will only update the text in the current loaded javascript engin
  begin
    // then continue with the update
    Elem:= GetElementById(Browser.ComServer.Document,'wmd-input') as IHTMLElement;
    if Assigned(Elem) then
    begin
      Elem.innerText:=BCEditor1.Text;
      ExecuteScript(Browser.ComServer.Document as IHTMLDocument2,'update();','javascript');
    end;
  end;
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

      ini.WriteBool('MDPad', 'syntaxenabled', mnuSyntax.Checked);
      ini.WriteBool('MDPad', 'themeenabled', mnuTheme.Checked);
      ini.WriteBool('MDPad', 'cssenabled', mnuCSS.Checked);
    finally
      ini.Free;
    end;
end;

// This will load the selected MarkDownEngin
// Incase is native, we still need to load the styles and container
// in order to let the webbrowser detect ondocumentcomplete to start loading
// its markdwn content over it
// it will enable the selectedEngine and pass a default string if desired so
procedure TForm1.LoadEngine(const DefaultText: string = '');
begin
  case SelectedEngine of
    // in common engines, the default text will in hidden textarea
    mdPAGEDOWN: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + PAGEDOWN + FOOTER);
    mdMARKDOWNJS: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKDOWNJS + FOOTER);
    mdMARKED: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKED + FOOTER);
    mdSHOWDOWN: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + SHOWDOWN + FOOTER);
    mdMARKDOWNIT: WBLoadHTML(Browser, HEADER + PreviewCSS + BODY + DefaultText + BODY2 + MARKDOWNIT + FOOTER);
    // in native engine it will be a rendered html content, other wise it will show a plaint text only
    mdNATIVE: WBLoadHTML(Browser, HEADER + PreviewCSS + OPENCONTAINER + DefaultText + CLOSECONTAINER + FOOTER);
  end;
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

      mnuSyntax.Checked := ini.ReadBool('MDPad', 'syntaxenabled', false);
      mnuTheme.Checked := ini.ReadBool('MDPad', 'themeenabled', false);
      mnuCSS.Checked := ini.ReadBool('MDPad', 'cssenabled', false);

      UpdateEngineInMenu;

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
  ReloadingEngine := True;
  Screen.Cursor := crHourGlass;
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
    ReloadingEngine := True;
    Screen.Cursor := crHourGlass;
//    UpdateResult; // we need to updateresult when webbrowser is ready
  end;

end;

//fixing arrow navigation of twebbrowser
procedure TForm1.BCEditor1CaretChanged(ASender: TObject; ACaretPos: TPoint);
begin
  if StatusBar1.Visible then
  begin
    StatusBar1.Panels[1].Text:='Line: '
        +inttostr(ACaretPos.Y)
        +', Column: '
        +inttostr(ACaretPos.X);
  end;
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

procedure TForm1.BCEditor1DblClick(Sender: TObject);
//requries jquery, so i disabled it
{var
  Linea: integer;
  texto: string;}
begin
{  with Sender as TMemo do
  begin
//    Linea:=Perform(EM_LINEFROMCHAR, SelStart, 0); //select current first visible line
    Linea:=Perform(EM_LINEFROMCHAR, SelStart, 0); //select current line
    SelStart:=Perform(EM_LINEINDEX, Linea, 0);
    SelLength:=Length(Lines[Linea]);
    StatusBar1.Panels[0].Text:=Memo1.SelText;
    texto:=SelText;
    if trim(texto) <> '' then
    begin
      //scrolltop to that text on preview
      try
      ExecuteScript(WebBrowser1.Document as IHTMLDocument2, '$(window).scrollTop($("*:contains('''+trim(texto)+'''):last").offset().top);','javascript');
      except
      end;
    end;

    SelLength:=0;
  end;}
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
var
  row, col : integer;
begin
  //status bar
  if StatusBar1.Visible then
  begin
/////////////////////    row:=BCEditor1.Perform(EM_LINEFROMCHAR, Memo1.SelStart, 0);
    //col:=BCEditor1.SelStart-BCEditor1.Perform(EM_LINEINDEX, row, 0);
{{{{{{{{{{{{{{{{{{    StatusBar1.Panels[1].Text:='Line: '
        +inttostr(row+1)
        +', Column: '
        +inttostr(col);}
  end;
end;



{ TBCEditor }

function TBCEditor.GetSelLength: Integer;
//var
  //Selection: TSelection;
begin
  result := 0;
  exit;
{$IF DEFINED(CLR)}
  SendGetSel(Selection.StartPos, Selection.EndPos);
{$ELSE}
  {{SendMessage(Handle, EM_GETSEL, WPARAM(@Selection.StartPos), LPARAM(@Selection.EndPos));}
{$ENDIF}
  {{Result := Selection.EndPos - Selection.StartPos;}
end;

function TBCEditor.GetSelStart: Integer;
{$IF DEFINED(CLR)}
var
  Temp: Integer;
begin
  SendGetSel(Result, Temp);
{$ELSE}
begin
  SendMessage(Handle, EM_GETSEL, WPARAM(@Result), 0);
{$ENDIF}
end;

{procedure TBCEditor.MouseUp(AButton: TMouseButton; AShift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;}

procedure TBCEditor.SetSelLength(const Value: Integer);
//var
  //Selection: TSelection;
begin
{$IF DEFINED(CLR)}
  SendGetSel(Selection.StartPos, Selection.EndPos);
{$ELSE}
  {{SendMessage(Handle, EM_GETSEL, WPARAM(@Selection.StartPos), LPARAM(@Selection.EndPos));}
{$ENDIF}
  {{Selection.EndPos := Selection.StartPos + Value;
  SendMessage(Handle, EM_SETSEL, Selection.StartPos, Selection.EndPos);
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);}
end;

procedure TBCEditor.SetSelStart(const Value: Integer);
begin
  SendMessage(Handle, EM_SETSEL, Value, Value);
end;

procedure TBCEditor.WMContextMenu(var Message: TWMContextMenu);
  //http://stackoverflow.com/a/10226523/537347
  //to apply globally but not needed http://www.devsuperpage.com/Articles/views/Delphi/Art_1-1380.asp
  //to recreate, not really a good idea https://theroadtodelphi.com/2011/12/07/adding-a-standard-context-popup-menu-to-a-synedit/
  procedure CustomEditPopupMenu(re: TBCEditor; const LPoint: TPoint; out Handled: Boolean);
  const
    IDM_UNDO   = WM_UNDO;
    IDM_CUT    = WM_CUT;
    IDM_COPY   = WM_COPY;
    IDM_PASTE  = WM_PASTE;
    IDM_DELETE = WM_CLEAR;
    IDM_SELALL = EM_SETSEL;
    IDM_RTL    = $8000; // WM_APP ?

    Enables: array[Boolean] of DWORD = (MF_DISABLED or MF_GRAYED, MF_ENABLED);
    Checks: array[Boolean] of DWORD = (MF_UNCHECKED, MF_CHECKED);
  var
    hUser32: HMODULE;
    hmnu, hmenuTrackPopup: HMENU;
    Cmd: DWORD;
    Flags: Cardinal;
    HasSelText: Boolean;
    FormHandle: HWND;
//    IsRTL: Boolean;
  begin
    Handled := False;
    hUser32 := LoadLibraryEx(user32, 0, LOAD_LIBRARY_AS_DATAFILE);
    if (hUser32 <> 0) then
    try
      hmnu := LoadMenu(hUser32, MAKEINTRESOURCE(1));
      if (hmnu <> 0) then
      try
        hmenuTrackPopup := GetSubMenu(hmnu, 0);

        HasSelText := Length(re.TextSelected) <> 0;
        {{EnableMenuItem(hmnu, IDM_UNDO,   Enables[re.CanUndo]);}
        EnableMenuItem(hmnu, IDM_CUT,    Enables[HasSelText]);
        EnableMenuItem(hmnu, IDM_COPY,   Enables[HasSelText]);
        //EnableMenuItem(hmnu, IDM_PASTE,  Enables[Clipboard.HasFormat(CF_TEXT)]);
        EnableMenuItem(hmnu, IDM_DELETE, Enables[HasSelText]);
        EnableMenuItem(hmnu, IDM_SELALL, Enables[Length(re.Text) <> 0]);

        //IsRTL := GetWindowLong(re.Handle, GWL_EXSTYLE) and WS_EX_RTLREADING <> 0;
        //EnableMenuItem(hmnu, IDM_RTL, Enables[True]);
        //CheckMenuItem(hmnu, IDM_RTL, Checks[IsRTL]);

        FormHandle := GetParentForm(re).Handle;
        Flags := TPM_LEFTALIGN or TPM_RIGHTBUTTON or TPM_NONOTIFY or TPM_RETURNCMD;
        Cmd := DWORD(TrackPopupMenu(hmenuTrackPopup, Flags,
          LPoint.X, LPoint.Y, 0, FormHandle, nil));
        if Cmd <> 0 then
        begin
          case Cmd of
            //IDM_UNDO:   re.ExecuteCommand(ecUndo,#0,nil); //re.Undo;
            {{IDM_UNDO:   re.Undo;}
            {{IDM_CUT:    re.CutToClipboard;}
            {{IDM_COPY:   re.CopyToClipboard;}
            {{IDM_PASTE:  re.PasteFromClipboard;}
            //IDM_DELETE: re.ClearSelection;
            IDM_SELALL: re.DoSelect_All;
            //IDM_RTL:; // ?
          end;
        end;
      finally
        DestroyMenu(hmnu);
        Handled := True;
      end;
    finally
      FreeLibrary(hUser32);
    end;
  end;
var
  LPoint: TPoint;
  LMessage: TMessage;
  Handled: Boolean;
begin
  SetFocus;

  if PopupMenu = nil then
  begin
    LPoint := SmallPointToPoint(Message.Pos);
{    if not InvalidPoint(LPoint) then
      LPoint := ScreenToClient(LPoint);}

    Handled := False;
    //DoContextPopup(LPoint, Handled);
    CustomEditPopupMenu(Self, LPoint, Handled);
    Message.Result := Ord(Handled);
    if Handled then Exit;

{$IF DEFINED(CLR)}
    LMessage := UnwrapMessage(TObject(Message));
{$ELSE}
    LMessage := TMessage(Message);
{$ENDIF}
    with LMessage do
      Result := CallWindowProc(DefWndProc, WindowHandle, Msg, WParam, LParam)
  end
  else
    inherited;
end;

procedure TForm1.CMDialogKey(var Message: TCMDialogKey);
begin
  if GetAsyncKeyState(VK_MENU)>=0 then
  begin
    case Message.CharCode of
      VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT:
      if ActiveControl=BrowserContainer then
      begin
        Message.Result:=0;
        exit;
      end;
    end;
  end;
  inherited;
end;

procedure TForm1.tmrScrollSyncerTimer(Sender: TObject);
var
  ScrollInfo: TScrollInfo;
  percentage: integer;
begin

  if (Synceditwithpreview1.Checked) and (BCEditor1.Visible)
  and (BrowserContainer.Visible) then
  begin
    with ScrollInfo do
    begin
      cbSize:=sizeof(self);
      fMask:=SIF_POS or SIF_RANGE;
    end;
    GetScrollInfo(BCEditor1.Handle, SB_VERT, ScrollInfo);

    with ScrollInfo do
    begin
      if nMax<>0 then
      percentage:=trunc(nPos/nMax*100);

      if SyncPercentage<>percentage then
      begin
        SyncPercentage:=percentage;
        try
          if nMax > 5 then
          ExecuteScript(Browser.ComServer.Document as IHTMLDOcument2, 'document.documentElement.scrollTop='+inttostr(percentage)+'/100*document.documentElement.scrollHeight','javascript');
        except
        end;
      end;
    end;
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  vIn, vOut: OleVariant;
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
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  {{BCEditor1.Undo;}
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
    ExecuteScript(Browser.ComServer.Document as IHTMLDocument2, 'document.getElementById("wmd-input").value="";update();','javascript');
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
var
  vIn, vOut: OleVariant;
begin
  Browser.ComServer.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  {{BCEditor1.PasteFromClipboard;}
end;

procedure TForm1.Print1Click(Sender: TObject);
var
  vIn, vOut:OleVariant;
begin
  Browser.ComServer.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
end;

procedure TForm1.PrintPreview1Click(Sender: TObject);
var
  vIn, vOut: OleVariant;
begin
//thanks to http://delphi.about.com/cs/adptips2004/a/bltip0504_5.htm
  Browser.ComServer.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER, vIn, vOut);
end;

procedure TForm1.Waitafewsecondsbeforeupdatingthepreview1Click(Sender: TObject);
begin
  Waitafewsecondsbeforeupdatingthepreview1.Checked := not Waitafewsecondsbeforeupdatingthepreview1.Checked;
end;

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
      ShellExecute(GetDesktopWindow,'OPEN',pchar(string(URL)),nil,nil,SW_SHOWNA);
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

end.
