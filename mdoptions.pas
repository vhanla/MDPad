unit mdoptions;

// The Options dialog: a tabbed window that edits every editor setting MDPad
// persists, plus the application axes (theme, syntax, preview backend/engine,
// zoom, recent files). The dialog is built at run time on purpose: it is pure
// layout + a few dozen rows that map 1:1 to TATSynEdit properties, and a hand
// written .lfm of that size drifts from the code that reads it.
//
// The dialog never touches the editor. It edits a TEditorOptions / TMdAppOptions
// record and the main unit applies the record (ApplyEditorOptions) and stores it
// (SaveEditorOptions). That is what keeps an ini written by an older build, a
// hand edited ini and the dialog from disagreeing: the record is seeded from
// the live editor, so a missing key keeps the editor's own default.

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Spin,
  Graphics, Dialogs, ButtonPanel;

type
  // One row of a combo whose item order is not the stored value (preview
  // backends and engines have non-contiguous ids: 1..3 and 1..7 with gaps).
  TIdCaption = record
    Id: Integer;
    Caption: string;
  end;
  TIdCaptionArray = array of TIdCaption;

  // Everything the editor tab needs, in the order the tabs show it. The values
  // are ATSynEdit option values (enums are stored as their ordinal), so the
  // record is also what settings.ini stores.
  TEditorOptions = record
    // View
    ShowCurLine: Boolean;
    ShowCurLineMinimal: Boolean;
    ShowCurColumn: Boolean;
    LastLineOnTop: Boolean;
    ShowFullWidthSel: Boolean;
    ShowFullWidthHilite: Boolean;
    ShowIndentLines: Boolean;
    ZebraActive: Boolean;
    ZebraStep: Integer;
    ShowScrollHint: Boolean;
    TextHint: string;
    WrapMode: Integer;      // TATEditorWrapMode
    WrapIndented: Boolean;
    // Gutter / ruler
    GutterVisible: Boolean;
    GutterNumbers: Boolean;
    GutterBookmarks: Boolean;
    GutterFolding: Boolean;
    GutterStates: Boolean;
    GutterSeparator: Boolean;
    NumbersStyle: Integer;      // TATEditorNumbersStyle
    NumbersAlignment: Integer;  // TAlignment: 0 left, 1 right, 2 center
    NumbersShowFirst: Boolean;
    NumbersShowCarets: Boolean;
    GutterCaretBG: Boolean;
    RulerVisible: Boolean;
    RulerHeight: Integer;       // percents
    RulerFontSize: Integer;     // percents
    RulerTopIndent: Integer;    // percents
    RulerStyle: Integer;        // TATEditorRulerNumeration
    // Minimap
    MinimapVisible: Boolean;
    MinimapCharWidth: Integer;
    MinimapSelBorder: Boolean;
    MinimapSelAlways: Boolean;
    // Unprinted characters
    UnprintedVisible: Boolean;
    UnprintedSpaces: Boolean;
    UnprintedSpacesTrailing: Boolean;
    UnprintedSpacesBothEnds: Boolean;
    UnprintedEnds: Boolean;
    UnprintedEndsDetails: Boolean;
    UnprintedReplaceSpec: Boolean;  // ATEditorOptions (global)
    UnprintedEndSymbol: Integer;    // TATEditorUnptintedEolSymbol
    UnprintedTabScale: Integer;     // ATEditorOptions.UnprintedTabPointerScale
    // Keys / indents
    TabSpaces: Boolean;
    TabSize: Integer;
    IndentSize: Integer;    // >0 spaces, <0 tabs, 0 = from tab size
    AutoIndent: Boolean;
    AutoIndentKind: Integer; // TATEditorAutoIndentKind
    TabIndents: Boolean;
    BackspaceUnindent: Boolean;
    BackspaceGoesPrev: Boolean;
    IndentKeepsAlign: Boolean;
    OverwriteSel: Boolean;
    NavUpDownWrapped: Boolean;
    UpDownAllowToEdge: Boolean;
    UpDownKeepColumn: Boolean;
    NavHomeEndWrapped: Boolean;
    HomeToNonSpace: Boolean;
    EndToNonSpace: Boolean;
    PageKeepsRelative: Boolean;
    PageSize: Integer;      // TATEditorPageDownSize
    LeftRightSwapSel: Boolean;
    // Mouse
    MouseNormalSel: Boolean;
    MouseColumnSel: Boolean;
    Mouse2ClickAction: Integer;   // TATEditorDoubleClickAction
    Mouse3ClickSelectsLine: Boolean;
    Mouse2ClickDragSelectsWords: Boolean;
    MouseClickNumberSelectsLine: Boolean;
    MouseDragDrop: Boolean;
    MouseRightClickMovesCaret: Boolean;
    MouseMiddleClickAction: Integer; // TATEditorMiddleClickAction
    MouseHideCursorOnType: Boolean;
    MouseClickOpensURL: Boolean;
    // Carets
    CaretBlinkEnabled: Boolean;
    CaretBlinkTime: Integer;
    CaretVirtual: Boolean;
    CaretMany: Boolean;
    CaretStopUnfocused: Boolean;
    CaretPrimitiveColumn: Boolean;
    CaretTextInverted: Boolean;  // ATEditorOptions.CaretTextOverInvertedRect
    // Files / undo
    SaveForceFinalEol: Boolean;
    SaveTrimSpaces: Boolean;
    SaveTrimFinalEmptyLines: Boolean;
    CopyLinesIfNoSel: Boolean;
    CutLinesIfNoSel: Boolean;
    PasteOverwrite: Boolean;
    PasteSpread: Boolean;
    UndoLimit: Integer;
    UndoGrouped: Boolean;
    UndoAfterSave: Boolean;
    UndoForCaretJump: Boolean;
    // Font
    FontName: string;
    FontSize: Integer;
  end;

  // The application axes. They live in the main unit; the dialog only returns
  // the picked values.
  TMdAppOptions = record
    Theme: Integer;           // TAppTheme: 0 system, 1 light, 2 dark, 3 custom
    SyntaxEnabled: Boolean;
    CSSEnabled: Boolean;
    SyncScroll: Boolean;
    RemoteImages: Boolean;
    Preview: Integer;         // pvHTML / pvMARKDOWN4D / pvIE
    Engine: Integer;          // md* id
    Zoom: Integer;            // TrackBar1.Position, 0..5
    MRULimit: Integer;        // File > Open recent entries kept
  end;

// Shows the modal dialog. Returns True when OK was pressed, in which case E and
// A hold the picked values. APreviews/AEngines are the backends and engines this
// build can actually use (the Windows-only ones are not listed elsewhere).
function ShowOptionsDialog(var E: TEditorOptions; var A: TMdAppOptions;
  const APreviews, AEngines: TIdCaptionArray): Boolean;

implementation

type
  TfmOptions = class(TForm)
  private
    FPC: TPageControl;
    FButtons: TButtonPanel;
    FChecks: array of record
      Ctrl: TCheckBox;
      Ptr: PBoolean;
    end;
    FSpins: array of record
      Ctrl: TSpinEdit;
      Ptr: PInteger;
    end;
    FCombos: array of record
      Ctrl: TComboBox;
      Ptr: PInteger;
      Mapped: Boolean;
    end;
    FEdOut: ^TEditorOptions;
    FApOut: ^TMdAppOptions;
    FHint: TEdit;
    FFontName: string;
    FFontSize: Integer;
    FFontLabel: TLabel;
    procedure Build(var E: TEditorOptions; var A: TMdAppOptions;
      const APreviews, AEngines: TIdCaptionArray);
    function NewPage(const ACaption: string): TScrollBox;
    procedure AddHeader(AParent: TWinControl; var AY: Integer;
      const ACaption: string);
    function AddCheck(AParent: TWinControl; var AY: Integer;
      const ACaption: string; AValue: PBoolean): TCheckBox;
    function AddSpin(AParent: TWinControl; var AY: Integer;
      const ACaption: string; AValue: PInteger;
      AMin, AMax: Integer): TSpinEdit;
    function AddCombo(AParent: TWinControl; var AY: Integer;
      const ACaption: string; const AItems: array of string;
      AValue: PInteger): TComboBox;
    function AddMappedCombo(AParent: TWinControl; var AY: Integer;
      const ACaption: string; const AItems: TIdCaptionArray;
      AValue: PInteger): TComboBox;
    function AddEdit(AParent: TWinControl; var AY: Integer;
      const ACaption, AValue: string): TEdit;
    procedure AddFontRow(AParent: TWinControl; var AY: Integer);
    procedure FontClick(Sender: TObject);
    procedure UpdateFontLabel;
    procedure Commit;
  public
    constructor CreateNew(AOwner: TComponent; Num: Integer = 0); override;
  end;

constructor TfmOptions.CreateNew(AOwner: TComponent; Num: Integer);
begin
  inherited CreateNew(AOwner, Num);
  Name := 'fmOptions';
  Caption := 'Options';
  BorderStyle := bsSizeable;
  Position := poMainFormCenter;
  Width := 700;
  Height := 580;
  Constraints.MinWidth := 580;
  Constraints.MinHeight := 420;
  ShowHint := True;
end;

function TfmOptions.NewPage(const ACaption: string): TScrollBox;
var
  Sheet: TTabSheet;
begin
  Sheet := TTabSheet.Create(FPC);
  Sheet.PageControl := FPC;
  Sheet.Caption := ACaption;
  Result := TScrollBox.Create(Self);
  Result.Parent := Sheet;
  Result.Align := alClient;
  Result.BorderStyle := bsNone;
  Result.Color := clWindow;
end;

procedure TfmOptions.AddHeader(AParent: TWinControl; var AY: Integer;
  const ACaption: string);
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 18;
  L.Top := AY + 8;
  L.Caption := ACaption;
  L.Font.Style := [fsBold];
  AY := AY + 30;
end;

function TfmOptions.AddCheck(AParent: TWinControl; var AY: Integer;
  const ACaption: string; AValue: PBoolean): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Parent := AParent;
  Result.Left := 26;
  Result.Top := AY;
  Result.Width := 560;
  Result.Height := 24;
  Result.Caption := ACaption;
  Result.Checked := AValue^;
  AY := AY + 24;
  SetLength(FChecks, Length(FChecks) + 1);
  FChecks[High(FChecks)].Ctrl := Result;
  FChecks[High(FChecks)].Ptr := AValue;
end;

function TfmOptions.AddSpin(AParent: TWinControl; var AY: Integer;
  const ACaption: string; AValue: PInteger;
  AMin, AMax: Integer): TSpinEdit;
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 26;
  L.Top := AY + 4;
  L.Width := 320;
  L.Caption := ACaption;
  Result := TSpinEdit.Create(Self);
  Result.Parent := AParent;
  Result.Left := 350;
  Result.Top := AY;
  Result.Width := 90;
  Result.MinValue := AMin;
  Result.MaxValue := AMax;
  Result.Value := AValue^;
  AY := AY + 30;
  SetLength(FSpins, Length(FSpins) + 1);
  FSpins[High(FSpins)].Ctrl := Result;
  FSpins[High(FSpins)].Ptr := AValue;
end;

function TfmOptions.AddCombo(AParent: TWinControl; var AY: Integer;
  const ACaption: string; const AItems: array of string;
  AValue: PInteger): TComboBox;
var
  L: TLabel;
  i: Integer;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 26;
  L.Top := AY + 4;
  L.Width := 320;
  L.Caption := ACaption;
  Result := TComboBox.Create(Self);
  Result.Parent := AParent;
  Result.Left := 350;
  Result.Top := AY;
  Result.Width := 260;
  Result.Style := csDropDownList;
  for i := 0 to High(AItems) do
    Result.Items.Add(AItems[i]);
  if (AValue^ >= 0) and (AValue^ < Result.Items.Count) then
    Result.ItemIndex := AValue^
  else if Result.Items.Count > 0 then
    Result.ItemIndex := 0;
  AY := AY + 30;
  SetLength(FCombos, Length(FCombos) + 1);
  FCombos[High(FCombos)].Ctrl := Result;
  FCombos[High(FCombos)].Ptr := AValue;
  FCombos[High(FCombos)].Mapped := False;
end;

function TfmOptions.AddMappedCombo(AParent: TWinControl; var AY: Integer;
  const ACaption: string; const AItems: TIdCaptionArray;
  AValue: PInteger): TComboBox;
var
  L: TLabel;
  i: Integer;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 26;
  L.Top := AY + 4;
  L.Width := 320;
  L.Caption := ACaption;
  Result := TComboBox.Create(Self);
  Result.Parent := AParent;
  Result.Left := 350;
  Result.Top := AY;
  Result.Width := 260;
  Result.Style := csDropDownList;
  AY := AY + 30;
  for i := 0 to High(AItems) do
  begin
    Result.Items.Add(AItems[i].Caption);
    // The id travels with the item: the index means nothing outside this combo
    // (preview 1,2,3 and engine 1..7 are not list positions).
    Result.Items.Objects[Result.Items.Count - 1] := TObject(PtrInt(AItems[i].Id));
  end;
  Result.ItemIndex := 0;
  for i := 0 to High(AItems) do
    if AItems[i].Id = AValue^ then
      Result.ItemIndex := i;
  if Result.ItemIndex < 0 then
    Result.ItemIndex := 0;
  SetLength(FCombos, Length(FCombos) + 1);
  FCombos[High(FCombos)].Ctrl := Result;
  FCombos[High(FCombos)].Ptr := AValue;
  FCombos[High(FCombos)].Mapped := True;
end;

function TfmOptions.AddEdit(AParent: TWinControl; var AY: Integer;
  const ACaption, AValue: string): TEdit;
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 26;
  L.Top := AY + 4;
  L.Width := 320;
  L.Caption := ACaption;
  Result := TEdit.Create(Self);
  Result.Parent := AParent;
  Result.Left := 350;
  Result.Top := AY;
  Result.Width := 260;
  Result.Text := AValue;
  AY := AY + 30;
end;

procedure TfmOptions.AddFontRow(AParent: TWinControl; var AY: Integer);
var
  B: TButton;
begin
  FFontLabel := TLabel.Create(Self);
  FFontLabel.Parent := AParent;
  FFontLabel.Left := 26;
  FFontLabel.Top := AY + 4;
  FFontLabel.Width := 320;
  UpdateFontLabel;
  B := TButton.Create(Self);
  B.Parent := AParent;
  B.Left := 350;
  B.Top := AY;
  B.Width := 120;
  B.Caption := 'Choose font...';
  B.OnClick := FontClick;
  AY := AY + 32;
end;

procedure TfmOptions.UpdateFontLabel;
begin
  if FFontLabel = nil then
    Exit;
  if FFontSize > 0 then
    FFontLabel.Caption := FFontName + ', ' + IntToStr(FFontSize) + ' pt'
  else
    FFontLabel.Caption := FFontName;
end;

procedure TfmOptions.FontClick(Sender: TObject);
var
  D: TFontDialog;
begin
  D := TFontDialog.Create(Self);
  try
    D.Font.Name := FFontName;
    if FFontSize > 0 then
      D.Font.Size := FFontSize;
    if D.Execute then
    begin
      FFontName := D.Font.Name;
      FFontSize := D.Font.Size;
      UpdateFontLabel;
    end;
  finally
    D.Free;
  end;
end;

procedure TfmOptions.Build(var E: TEditorOptions; var A: TMdAppOptions;
  const APreviews, AEngines: TIdCaptionArray);
var
  Y: Integer;
  Page: TScrollBox;
begin
  FEdOut := @E;
  FApOut := @A;
  FFontName := E.FontName;
  FFontSize := E.FontSize;

  // The buttons go in first: alBottom takes its space before alClient fills
  // the rest, whatever the creation order.
  FButtons := TButtonPanel.Create(Self);
  FButtons.Parent := Self;
  FButtons.Align := alBottom;
  FButtons.ShowButtons := [pbOK, pbCancel];
  FButtons.ShowBevel := False;

  FPC := TPageControl.Create(Self);
  FPC.Parent := Self;
  FPC.Align := alClient;
  FPC.TabPosition := tpTop;

  // ---------------------------------------------------------------- View
  Page := NewPage('View');
  Y := 10;
  AddHeader(Page, Y, 'Display');
  AddCheck(Page, Y, 'Highlight the current line', @E.ShowCurLine);
  AddCheck(Page, Y, 'Minimal current-line highlight (gutter and underline only)', @E.ShowCurLineMinimal);
  AddCheck(Page, Y, 'Highlight the current column', @E.ShowCurColumn);
  AddCheck(Page, Y, 'Allow the last line to scroll to the top', @E.LastLineOnTop);
  AddCheck(Page, Y, 'Selection background across the full row', @E.ShowFullWidthSel);
  AddCheck(Page, Y, 'Syntax-highlight background across the full row', @E.ShowFullWidthHilite);
  AddCheck(Page, Y, 'Show indent guides', @E.ShowIndentLines);
  AddCheck(Page, Y, 'Alternate line background (zebra)', @E.ZebraActive);
  AddSpin(Page, Y, 'Zebra stripe height (lines)', @E.ZebraStep, 2, 50);
  AddCheck(Page, Y, 'Show a hint while dragging the vertical scrollbar', @E.ShowScrollHint);
  AddHeader(Page, Y, 'Empty document');
  FHint := AddEdit(Page, Y, 'Text shown in an empty editor', E.TextHint);
  AddHeader(Page, Y, 'Word wrap');
  AddCombo(Page, Y, 'Wrap long lines',
    ['Off', 'On (at the window width)', 'At the window width or right margin'],
    @E.WrapMode);
  AddCheck(Page, Y, 'Indent wrapped continuation lines', @E.WrapIndented);

  // -------------------------------------------------------------- Gutter
  Page := NewPage('Gutter and ruler');
  Y := 10;
  AddHeader(Page, Y, 'Gutter');
  AddCheck(Page, Y, 'Show the gutter', @E.GutterVisible);
  AddCheck(Page, Y, 'Line numbers', @E.GutterNumbers);
  AddCheck(Page, Y, 'Bookmark column', @E.GutterBookmarks);
  AddCheck(Page, Y, 'Folding column', @E.GutterFolding);
  AddCheck(Page, Y, 'Line-state column (modified/saved)', @E.GutterStates);
  AddCheck(Page, Y, 'Separator line', @E.GutterSeparator);
  AddHeader(Page, Y, 'Line numbers');
  AddCombo(Page, Y, 'Numbers on every line',
    ['Every line', 'No numbers', 'Every 10th line', 'Every 5th line', 'Relative'],
    @E.NumbersStyle);
  AddCombo(Page, Y, 'Alignment', ['Left', 'Right', 'Center'], @E.NumbersAlignment);
  AddCheck(Page, Y, 'Show the number of the first line', @E.NumbersShowFirst);
  AddCheck(Page, Y, 'Show numbers for all carets', @E.NumbersShowCarets);
  AddCheck(Page, Y, 'Draw the caret background behind the numbers', @E.GutterCaretBG);
  AddHeader(Page, Y, 'Ruler');
  AddCheck(Page, Y, 'Show the ruler', @E.RulerVisible);
  AddSpin(Page, Y, 'Ruler height (% of the line height)', @E.RulerHeight, 20, 200);
  AddSpin(Page, Y, 'Ruler font size (% of the editor font)', @E.RulerFontSize, 30, 150);
  AddSpin(Page, Y, 'Ruler top indent (%)', @E.RulerTopIndent, 0, 100);
  AddCombo(Page, Y, 'Ruler numbering', ['0 10 20', '1 11 21', '1 10 20'], @E.RulerStyle);

  // ---------------------------------------------------- Minimap & unprinted
  Page := NewPage('Minimap and unprinted');
  Y := 10;
  AddHeader(Page, Y, 'Minimap');
  AddCheck(Page, Y, 'Show the minimap', @E.MinimapVisible);
  AddSpin(Page, Y, 'Minimap character width (0 = automatic)', @E.MinimapCharWidth, 0, 30);
  AddCheck(Page, Y, 'Draw a border around the visible area', @E.MinimapSelBorder);
  AddCheck(Page, Y, 'Always show the visible area marker', @E.MinimapSelAlways);
  AddHeader(Page, Y, 'Unprinted characters');
  AddCheck(Page, Y, 'Show unprinted characters', @E.UnprintedVisible);
  AddCheck(Page, Y, 'Spaces', @E.UnprintedSpaces);
  AddCheck(Page, Y, 'Trailing spaces only', @E.UnprintedSpacesTrailing);
  AddCheck(Page, Y, 'Spaces at both ends of the line', @E.UnprintedSpacesBothEnds);
  AddCheck(Page, Y, 'End-of-line marks', @E.UnprintedEnds);
  AddCheck(Page, Y, 'End-of-line details (wrapped / last line)', @E.UnprintedEndsDetails);
  AddCheck(Page, Y, 'Replace special characters with a readable symbol', @E.UnprintedReplaceSpec);
  AddCombo(Page, Y, 'End-of-line symbol', ['Dot', 'Arrow down', 'Pilcrow'],
    @E.UnprintedEndSymbol);
  AddSpin(Page, Y, 'Tab arrow size', @E.UnprintedTabScale, 0, 100);

  // ------------------------------------------------------- Keys and indents
  Page := NewPage('Keys and indents');
  Y := 10;
  AddHeader(Page, Y, 'Indentation');
  AddCheck(Page, Y, 'Insert spaces instead of tabs', @E.TabSpaces);
  AddSpin(Page, Y, 'Tab size (columns)', @E.TabSize, 1, 32);
  AddSpin(Page, Y, 'Indent size (negative = that many tabs)', @E.IndentSize, -16, 32);
  AddCombo(Page, Y, 'Auto-indent style', ['As the previous line', 'Spaces only',
    'Tabs and spaces', 'Tabs only', 'Up to the opening bracket'], @E.AutoIndentKind);
  AddCheck(Page, Y, 'Auto-indent a new line', @E.AutoIndent);
  AddCheck(Page, Y, 'Tab and Shift+Tab indent the selection', @E.TabIndents);
  AddCheck(Page, Y, 'Backspace unindents', @E.BackspaceUnindent);
  AddCheck(Page, Y, 'Backspace at the start of a line goes to the previous line',
    @E.BackspaceGoesPrev);
  AddCheck(Page, Y, 'Keep the indentation of unindented lines aligned', @E.IndentKeepsAlign);
  AddHeader(Page, Y, 'Navigation');
  AddCheck(Page, Y, 'Up/Down move through wrapped lines', @E.NavUpDownWrapped);
  AddCheck(Page, Y, 'Up/Down may move past the first/last line', @E.UpDownAllowToEdge);
  AddCheck(Page, Y, 'Up/Down keep the column', @E.UpDownKeepColumn);
  AddCheck(Page, Y, 'Home/End move through wrapped lines', @E.NavHomeEndWrapped);
  AddCheck(Page, Y, 'Home goes to the first non-space character', @E.HomeToNonSpace);
  AddCheck(Page, Y, 'End goes to the last non-space character', @E.EndToNonSpace);
  AddCheck(Page, Y, 'PageUp/PageDown keep the relative top line', @E.PageKeepsRelative);
  AddCombo(Page, Y, 'Page size', ['Full page', 'Full page minus one line', 'Half page'],
    @E.PageSize);
  AddHeader(Page, Y, 'Selection');
  AddCheck(Page, Y, 'Typing overwrites the selection', @E.OverwriteSel);
  AddCheck(Page, Y, 'Left/Right swap the selection edge', @E.LeftRightSwapSel);

  // --------------------------------------------------------- Mouse & carets
  Page := NewPage('Mouse and carets');
  Y := 10;
  AddHeader(Page, Y, 'Mouse');
  AddCheck(Page, Y, 'Select with the mouse', @E.MouseNormalSel);
  AddCheck(Page, Y, 'Column selection with the mouse', @E.MouseColumnSel);
  AddCheck(Page, Y, 'Right click moves the caret', @E.MouseRightClickMovesCaret);
  AddCheck(Page, Y, 'Clicking a line number selects the line', @E.MouseClickNumberSelectsLine);
  AddCombo(Page, Y, 'Double click selects',
    ['Nothing', 'Word characters', 'Any characters', 'The whole line'],
    @E.Mouse2ClickAction);
  AddCheck(Page, Y, 'Dragging after a double click selects word by word',
    @E.Mouse2ClickDragSelectsWords);
  AddCheck(Page, Y, 'Triple click selects the line', @E.Mouse3ClickSelectsLine);
  AddCheck(Page, Y, 'Drag and drop text', @E.MouseDragDrop);
  AddCombo(Page, Y, 'Middle click', ['Nothing', 'Scrolling', 'Paste', 'Go to definition'],
    @E.MouseMiddleClickAction);
  AddCheck(Page, Y, 'Hide the mouse cursor while typing', @E.MouseHideCursorOnType);
  AddCheck(Page, Y, 'Ctrl+click opens links', @E.MouseClickOpensURL);
  AddHeader(Page, Y, 'Caret');
  AddCheck(Page, Y, 'Blink the caret', @E.CaretBlinkEnabled);
  AddSpin(Page, Y, 'Blink time (ms)', @E.CaretBlinkTime, 100, 2000);
  AddCheck(Page, Y, 'Allow the caret past the end of the line (virtual caret)',
    @E.CaretVirtual);
  AddCheck(Page, Y, 'Allow multiple carets', @E.CaretMany);
  AddCheck(Page, Y, 'Stop blinking when the editor loses focus', @E.CaretStopUnfocused);
  AddCheck(Page, Y, 'Primitive column selection with multiple carets',
    @E.CaretPrimitiveColumn);
  AddCheck(Page, Y, 'Draw the character over an inverted caret', @E.CaretTextInverted);

  // --------------------------------------------------------- Files and undo
  Page := NewPage('Files and undo');
  Y := 10;
  AddHeader(Page, Y, 'Saving');
  AddCheck(Page, Y, 'Force a final end-of-line when saving', @E.SaveForceFinalEol);
  AddCheck(Page, Y, 'Trim trailing spaces when saving', @E.SaveTrimSpaces);
  AddCheck(Page, Y, 'Trim trailing empty lines when saving', @E.SaveTrimFinalEmptyLines);
  AddHeader(Page, Y, 'Clipboard');
  AddCheck(Page, Y, 'Copy the whole line when nothing is selected', @E.CopyLinesIfNoSel);
  AddCheck(Page, Y, 'Cut the whole line when nothing is selected', @E.CutLinesIfNoSel);
  AddCheck(Page, Y, 'Pasting overwrites the selection', @E.PasteOverwrite);
  AddCheck(Page, Y, 'Pasting lines spreads them across the carets', @E.PasteSpread);
  AddHeader(Page, Y, 'Undo');
  AddSpin(Page, Y, 'Undo limit (steps, 0 = unlimited)', @E.UndoLimit, 0, 100000);
  AddCheck(Page, Y, 'Group the undo steps', @E.UndoGrouped);
  AddCheck(Page, Y, 'Keep undo history after saving', @E.UndoAfterSave);
  AddCheck(Page, Y, 'Record caret jumps in the undo history', @E.UndoForCaretJump);

  // --------------------------------------------------------- Application
  Page := NewPage('Application');
  Y := 10;
  AddHeader(Page, Y, 'Appearance');
  AddCombo(Page, Y, 'Theme', ['System', 'Light', 'Dark', 'Custom'],
    @A.Theme);
  AddCheck(Page, Y, 'Enable syntax highlighting', @A.SyntaxEnabled);
  AddCheck(Page, Y, 'Enable custom style (style.css) in the HTML preview', @A.CSSEnabled);
  AddHeader(Page, Y, 'Preview');
  AddMappedCombo(Page, Y, 'Backend', APreviews, @A.Preview);
  AddMappedCombo(Page, Y, 'Markdown engine', AEngines, @A.Engine);
  AddCombo(Page, Y, 'Zoom', ['50%', '75%', '100%', '125%', '150%', '200%'], @A.Zoom);
  AddCheck(Page, Y, 'Sync editor and preview scrolling', @A.SyncScroll);
  AddCheck(Page, Y, 'Load remote images (canvas preview)', @A.RemoteImages);
  AddHeader(Page, Y, 'Editor font');
  AddFontRow(Page, Y);
  AddHeader(Page, Y, 'Recent files');
  AddSpin(Page, Y, 'Entries kept in File > Open recent', @A.MRULimit, 1, 30);

  FPC.ActivePageIndex := 0;
end;

procedure TfmOptions.Commit;
var
  i: Integer;
begin
  for i := 0 to High(FChecks) do
    FChecks[i].Ptr^ := FChecks[i].Ctrl.Checked;
  for i := 0 to High(FSpins) do
    FSpins[i].Ptr^ := FSpins[i].Ctrl.Value;
  for i := 0 to High(FCombos) do
  begin
    if FCombos[i].Mapped then
      FCombos[i].Ptr^ := PtrInt(FCombos[i].Ctrl.Items.Objects[FCombos[i].Ctrl.ItemIndex])
    else
      FCombos[i].Ptr^ := FCombos[i].Ctrl.ItemIndex;
  end;
  FEdOut^.TextHint := FHint.Text;
  FEdOut^.FontName := FFontName;
  FEdOut^.FontSize := FFontSize;
end;

function ShowOptionsDialog(var E: TEditorOptions; var A: TMdAppOptions;
  const APreviews, AEngines: TIdCaptionArray): Boolean;
var
  Dlg: TfmOptions;
begin
  Dlg := TfmOptions.CreateNew(nil);
  try
    Dlg.Build(E, A, APreviews, AEngines);
    Result := Dlg.ShowModal = mrOk;
    if Result then
      Dlg.Commit;
  finally
    Dlg.Free;
  end;
end;

end.
