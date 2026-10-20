unit mddialogs;
{ The small insert dialogs of the editor: link, image (with an optional copy
  into an assets folder next to the document) and table.

  They are built at run time, like the Options dialog in mdoptions.pas: no .lfm
  means no widgetset-specific component got recorded in the form file, and the
  widgetset differences stay in one place. The palettes mirror
  ApplyChromeColors in the main unit; the buttons themselves belong to the
  widgetset and keep its look, like the menus do. }

{$mode delphi}
{$H+}

interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls, ExtCtrls, Graphics, Dialogs,
  Spin, LCLType, LazFileUtils;

// Text = the visible label, Target = the URL or file, Title = the optional
// title. The values come in prefilled when an existing link is being edited.
function MdShowLinkDialog(ADark: Boolean;
  var AText, ATarget, ATitle: string): Boolean;

// Alt/Src/Title build ![alt](src "title"). ADocFolder is the folder of the
// document ('' when it has not been saved yet); when ACopyToAssets is on and
// the folder is known, the picked file is copied into <folder>/assets and ASrc
// comes back as the relative path, which both preview backends resolve.
function MdShowImageDialog(ADark: Boolean; const ADocFolder: string;
  var AAlt, ASrc, ATitle: string; var ACopyToAssets: Boolean): Boolean;

function MdShowTableDialog(ADark: Boolean;
  var ARows, ACols: Integer): Boolean;

implementation

function MdRgb(ARed, AGreen, ABlue: Byte): TColor;
begin
  Result := TColor(ARed or (AGreen shl 8) or (ABlue shl 16));
end;

type
  TMdDialogPalette = record
    Bg: TColor;
    Fg: TColor;
    EditBg: TColor;
    Border: TColor;
  end;

  // Survives as long as the dialog (it is owned by it) and carries the few
  // handlers a run-time form needs: browse, and the OK validation that keeps
  // the dialog open when a field is wrong.
  TMdDialogHelper = class(TComponent)
  public
    BrowseDialog: TOpenDialog;
    BrowseEdit: TEdit;
    BrowseAlt: TEdit;
    BrowseImage: TImage;
    OkTarget: TEdit;
    OkFile: TEdit;
    OkFolder: string;
    procedure BrowseClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
  end;

procedure MdLoadPreview(AImage: TImage; const AFile: string);
begin
  AImage.Picture.Clear;
  if not FileExists(AFile) then
    Exit;
  try
    AImage.Picture.LoadFromFile(AFile);
  except
    AImage.Picture.Clear;
  end;
end;


procedure TMdDialogHelper.BrowseClick(Sender: TObject);
begin
  if not BrowseDialog.Execute then
    Exit;
  if BrowseEdit <> nil then
    BrowseEdit.Text := BrowseDialog.FileName;
  if (BrowseAlt <> nil) and (BrowseAlt.Text = '') then
    BrowseAlt.Text := ChangeFileExt(ExtractFileName(BrowseDialog.FileName), '');
  if BrowseImage <> nil then
    MdLoadPreview(BrowseImage, BrowseDialog.FileName);
end;

// An image source is either an http(s)/data URL (the canvas fetches those) or a
// file, absolute or relative to the document's folder.
function MdSourceExists(const ASrc, AFolder: string): Boolean;
begin
  Result := (Pos('://', ASrc) > 0) or (Copy(ASrc, 1, 5) = 'data:');
  if Result then
    Exit;
  Result := FileExists(ASrc);
  if not Result and (AFolder <> '') then
    Result := FileExists(IncludeTrailingPathDelimiter(AFolder) + ASrc);
end;

procedure TMdDialogHelper.OkClick(Sender: TObject);
begin
  if (OkTarget <> nil) and (Trim(OkTarget.Text) = '') then
  begin
    MessageDlg('Please enter a target.', mtWarning, [mbOK], 0);
    TButton(Sender).ModalResult := mrNone;
    OkTarget.SetFocus;
    Exit;
  end;
  if (OkFile <> nil) and not MdSourceExists(Trim(OkFile.Text), OkFolder) then
  begin
    MessageDlg('The image file does not exist:'#10 + Trim(OkFile.Text),
      mtError, [mbOK], 0);
    TButton(Sender).ModalResult := mrNone;
    OkFile.SetFocus;
  end;
end;

function MdDialogPalette(ADark: Boolean): TMdDialogPalette;
begin
  if ADark then
  begin
    Result.Bg := MdRgb($0D, $11, $17);
    Result.Fg := MdRgb($C9, $D1, $D9);
    Result.EditBg := MdRgb($16, $1B, $22);
    Result.Border := MdRgb($30, $36, $3D);
  end
  else
  begin
    Result.Bg := MdRgb($FF, $FF, $FF);
    Result.Fg := MdRgb($1F, $23, $28);
    Result.EditBg := MdRgb($F6, $F8, $FA);
    Result.Border := MdRgb($D0, $D7, $DE);
  end;
end;

procedure MdApplyPalette(AForm: TForm; const APal: TMdDialogPalette);
var
  i: Integer;
  C: TControl;
begin
  AForm.Color := APal.Bg;
  AForm.Font.Color := APal.Fg;
  for i := 0 to AForm.ControlCount - 1 do
  begin
    C := AForm.Controls[i];
    if C is TLabel then
      TLabel(C).Font.Color := APal.Fg
    else if C is TCheckBox then
      TCheckBox(C).Font.Color := APal.Fg
    else if C is TEdit then
    begin
      TEdit(C).Color := APal.EditBg;
      TEdit(C).Font.Color := APal.Fg;
    end
    else if C is TSpinEdit then
    begin
      TSpinEdit(C).Color := APal.EditBg;
      TSpinEdit(C).Font.Color := APal.Fg;
    end;
  end;
end;

function MdNewForm(ADark: Boolean; const ACaption: string;
  AWidth, AHeight: Integer): TForm;
begin
  Result := TForm.CreateNew(nil);
  Result.Caption := ACaption;
  Result.BorderStyle := bsDialog;
  Result.Position := poScreenCenter;
  Result.ClientWidth := AWidth;
  Result.ClientHeight := AHeight;
  MdApplyPalette(Result, MdDialogPalette(ADark));
end;

function MdAddLabel(AForm: TForm; const ACaption: string;
  AX, AY, AWidth: Integer): TLabel;
begin
  Result := TLabel.Create(AForm);
  Result.Parent := AForm;
  Result.Caption := ACaption;
  Result.Left := AX;
  Result.Top := AY + 4;
  Result.Width := AWidth;
end;

function MdAddEdit(AForm: TForm; const AInitial: string;
  AX, AY, AWidth: Integer): TEdit;
begin
  Result := TEdit.Create(AForm);
  Result.Parent := AForm;
  Result.Text := AInitial;
  Result.Left := AX;
  Result.Top := AY;
  Result.Width := AWidth;
end;

function MdAddButton(AForm: TForm; const ACaption: string;
  AX, AY, AWidth: Integer): TButton;
begin
  Result := TButton.Create(AForm);
  Result.Parent := AForm;
  Result.Caption := ACaption;
  Result.Left := AX;
  Result.Top := AY;
  Result.Width := AWidth;
end;

procedure MdAddOkCancel(AForm: TForm; AHelper: TMdDialogHelper);
var
  B: TButton;
begin
  B := MdAddButton(AForm, 'OK', AForm.ClientWidth - 190,
    AForm.ClientHeight - 38, 80);
  B.Default := True;
  B.ModalResult := mrOk;
  if AHelper <> nil then
    B.OnClick := AHelper.OkClick;

  B := MdAddButton(AForm, 'Cancel', AForm.ClientWidth - 102,
    AForm.ClientHeight - 38, 80);
  B.Cancel := True;
  B.ModalResult := mrCancel;
end;

function MdCopyStream(const AFrom, ATo: string): Boolean;
var
  S, D: TFileStream;
begin
  Result := False;
  try
    S := TFileStream.Create(AFrom, fmOpenRead or fmShareDenyWrite);
    try
      D := TFileStream.Create(ATo, fmCreate);
      try
        D.CopyFrom(S, 0);
        Result := True;
      finally
        D.Free;
      end;
    finally
      S.Free;
    end;
  except
    Result := False;
  end;
end;

// <doc>/assets/<name>, with a numbered name when a different file of the same
// name is already there; an identical one (same name and size) is reused.
function MdAssetTarget(const ADocFolder, ASource: string): string;
var
  Dir, Base, Ext, Candidate: string;
  n: Integer;
begin
  Dir := IncludeTrailingPathDelimiter(ADocFolder) + 'assets';
  ForceDirectories(Dir);
  Base := ChangeFileExt(ExtractFileName(ASource), '');
  Ext := ExtractFileExt(ASource);
  Candidate := IncludeTrailingPathDelimiter(Dir) + Base + Ext;
  n := 0;
  while FileExists(Candidate)
    and (CompareFilenames(Candidate, ASource) <> 0) do
  begin
    if FileSizeUtf8(Candidate) = FileSizeUtf8(ASource) then
      Break; // assume it is the same picture
    Inc(n);
    Candidate := IncludeTrailingPathDelimiter(Dir) + Base + '-' + IntToStr(n) + Ext;
  end;
  Result := Candidate;
end;

function MdResolveImageFile(const ADocFolder, ASrc: string): string;
begin
  Result := ASrc;
  if (Result = '') or FileExists(Result) then
    Exit;
  if (ADocFolder <> '') and FileExists(IncludeTrailingPathDelimiter(ADocFolder) + Result) then
    Result := IncludeTrailingPathDelimiter(ADocFolder) + Result;
end;

// ---------------------------------------------------------------------------
// Link

function MdShowLinkDialog(ADark: Boolean;
  var AText, ATarget, ATitle: string): Boolean;
var
  F: TForm;
  EText, ETarget, ETitle: TEdit;
  B: TButton;
  Helper: TMdDialogHelper;
begin
  F := MdNewForm(ADark, 'Link', 520, 200);
  try
    Helper := TMdDialogHelper.Create(F);
    Helper.BrowseDialog := TOpenDialog.Create(F);
    Helper.BrowseDialog.Filter := 'All files|*.*';
    Helper.BrowseDialog.Options := [ofFileMustExist];

    MdAddLabel(F, 'Text', 16, 18, 100);
    EText := MdAddEdit(F, AText, 120, 14, 380);
    MdAddLabel(F, 'Target', 16, 54, 100);
    ETarget := MdAddEdit(F, ATarget, 120, 50, 300);
    MdAddLabel(F, 'Title', 16, 90, 100);
    ETitle := MdAddEdit(F, ATitle, 120, 86, 380);

    B := MdAddButton(F, 'Browse...', 426, 49, 74);
    Helper.BrowseEdit := ETarget;
    B.OnClick := Helper.BrowseClick;

    Helper.OkTarget := ETarget;
    MdAddOkCancel(F, Helper);

    Result := F.ShowModal = mrOk;
    if Result then
    begin
      AText := EText.Text;
      ATarget := Trim(ETarget.Text);
      ATitle := Trim(ETitle.Text);
    end;
  finally
    F.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Image

function MdShowImageDialog(ADark: Boolean; const ADocFolder: string;
  var AAlt, ASrc, ATitle: string; var ACopyToAssets: Boolean): Boolean;
var
  F: TForm;
  EFile, EAlt, ETitle: TEdit;
  Chk: TCheckBox;
  Img: TImage;
  B: TButton;
  Helper: TMdDialogHelper;
  Target, SrcFile, Resolved: string;
begin
  F := MdNewForm(ADark, 'Image', 660, 300);
  try
    Helper := TMdDialogHelper.Create(F);
    Helper.BrowseDialog := TOpenDialog.Create(F);
    Helper.BrowseDialog.Filter :=
      'Images|*.png;*.jpg;*.jpeg;*.gif;*.bmp;*.webp;*.svg|All files|*.*';
    Helper.BrowseDialog.Options := [ofFileMustExist];

    MdAddLabel(F, 'File', 16, 18, 100);
    EFile := MdAddEdit(F, ASrc, 120, 14, 300);
    MdAddLabel(F, 'Alt text', 16, 54, 100);
    EAlt := MdAddEdit(F, AAlt, 120, 50, 300);
    MdAddLabel(F, 'Title', 16, 90, 100);
    ETitle := MdAddEdit(F, ATitle, 120, 86, 300);

    B := MdAddButton(F, 'Browse...', 426, 13, 80);
    Helper.BrowseEdit := EFile;
    Helper.BrowseAlt := EAlt;
    B.OnClick := Helper.BrowseClick;

    Img := TImage.Create(F);
    Img.Parent := F;
    Img.Left := 470;
    Img.Top := 50;
    Img.Width := 174;
    Img.Height := 130;
    Img.Stretch := True;
    Img.Proportional := True;
    Img.Center := True;
    Helper.BrowseImage := Img;

    Chk := TCheckBox.Create(F);
    Chk.Parent := F;
    Chk.Caption := 'Copy into the document''s assets folder';
    Chk.Left := 120;
    Chk.Top := 126;
    Chk.Width := 340;
    Chk.Checked := ACopyToAssets and (ADocFolder <> '');
    Chk.Enabled := ADocFolder <> '';
    if ADocFolder = '' then
      Chk.Caption := 'Copy into assets/ (save the file first)';

    Resolved := MdResolveImageFile(ADocFolder, ASrc);
    if Resolved <> '' then
      MdLoadPreview(Img, Resolved);

    Helper.OkFile := EFile;
    Helper.OkFolder := ADocFolder;
    MdAddOkCancel(F, Helper);

    Result := F.ShowModal = mrOk;
    if not Result then
      Exit;
    SrcFile := Trim(EFile.Text);
    if FileExists(SrcFile) then
      SrcFile := ExpandFileName(SrcFile)
    else if (ADocFolder <> '') and FileExists(IncludeTrailingPathDelimiter(ADocFolder) + SrcFile) then
      SrcFile := ExpandFileName(IncludeTrailingPathDelimiter(ADocFolder) + SrcFile);

    ACopyToAssets := Chk.Checked and (ADocFolder <> '') and FileExists(SrcFile);
    if ACopyToAssets then
    begin
      Target := MdAssetTarget(ADocFolder, SrcFile);
      if CompareFilenames(Target, SrcFile) <> 0 then
        if not MdCopyStream(SrcFile, Target) then
        begin
          MessageDlg('Could not copy the image into:'#10 + Target,
            mtError, [mbOK], 0);
          Result := False;
          Exit;
        end;
      // Forward slashes: a Markdown file written on one platform is read on
      // the others, and both preview backends accept them.
      ASrc := 'assets/' + ExtractFileName(Target);
    end
    else
      ASrc := SrcFile;
    AAlt := EAlt.Text;
    ATitle := Trim(ETitle.Text);
  finally
    F.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Table

function MdShowTableDialog(ADark: Boolean;
  var ARows, ACols: Integer): Boolean;
var
  F: TForm;
  SpR, SpC: TSpinEdit;
begin
  F := MdNewForm(ADark, 'Table', 320, 150);
  try
    MdAddLabel(F, 'Columns', 16, 20, 100);
    SpC := TSpinEdit.Create(F);
    SpC.Parent := F;
    SpC.Left := 120;
    SpC.Top := 16;
    SpC.Width := 80;
    SpC.MinValue := 1;
    SpC.MaxValue := 12;
    SpC.Value := ACols;

    MdAddLabel(F, 'Rows', 16, 52, 100);
    SpR := TSpinEdit.Create(F);
    SpR.Parent := F;
    SpR.Left := 120;
    SpR.Top := 48;
    SpR.Width := 80;
    SpR.MinValue := 0;
    SpR.MaxValue := 50;
    SpR.Value := ARows;

    MdAddOkCancel(F, nil);
    Result := F.ShowModal = mrOk;
    if Result then
    begin
      ARows := SpR.Value;
      ACols := SpC.Value;
    end;
  finally
    F.Free;
  end;
end;

end.
