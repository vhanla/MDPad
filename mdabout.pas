unit mdabout;

{$mode delphi}{$H+}

// The About window: version, author, credits and the licenses of the libraries
// MDPad is built on.
//
// Built at run time like the other dialogs (mddialogs.pas, mdoptions.pas), so
// no widgetset-specific component ends up in an .lfm. The dialog itself never
// talks to the network and never opens a document: it returns the button the
// user pressed, and the form does that (the update check is the form's thread,
// the readme/notices are its OpenMDFile).

interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls, Graphics, ExtCtrls, LCLType,
  LCLIntf, mdversioninfo;

type
  TMdAboutAction = (aaClose, aaCheckUpdates, aaReadme, aaThirdParty);

// Shows the dialog. ALatestVersion is the newest release the update check knows
// about ('' when it never ran). The result says what the user asked for; the
// caller performs it after the dialog has closed.
function MdShowAboutDialog(ADark: Boolean; const AVersion,
  ALatestVersion: string): TMdAboutAction;

implementation

const
  MdCredits =
    'MDPad is a native Markdown editor and viewer written in Free Pascal' + LineEnding +
    'with the Lazarus Component Library.' + LineEnding +
    '' + LineEnding +
    'AUTHOR' + LineEnding +
    '  Victor Alberto Gil (vhanla)' + LineEnding +
    '  https://github.com/vhanla/MDPad' + LineEnding +
    '  https://apps.codigobit.info' + LineEnding +
    '' + LineEnding +
    'MARKDOWN ENGINES' + LineEnding +
    '  MyWiki / WikiConverter            MIT' + LineEnding +
    '    (c) 2025 MASUDA Takashi' + LineEnding +
    '  Markdown4D                        MIT' + LineEnding +
    '    (c) 2026 GDK Software' + LineEnding +
    '  PageDown, markdown-js, Marked, ShowDown, markdown-it    MIT' + LineEnding +
    '    the JavaScript engines of the Windows (IE) preview' + LineEnding +
    '' + LineEnding +
    'EDITOR' + LineEnding +
    '  ATSynEdit                         MPL 2.0 or LGPL' + LineEnding +
    '    (c) Alexey Torgashin (UVviewsoft)' + LineEnding +
    '  EControl Syntax Editor SDK' + LineEnding +
    '    (c) 2004-2015 Michael Zakharov' + LineEnding +
    '    changes (c) 2015-2026 Alexey Yu. Torgashin' + LineEnding +
    '    used under its open-source-only permission' + LineEnding +
    '' + LineEnding +
    'PREVIEW' + LineEnding +
    '  THtmlViewer / FrameViewer 09      MIT-style' + LineEnding +
    '    (c) 1995-2008 L. David Baldwin' + LineEnding +
    '    (c) 2008-2009 Sebastian Zierer' + LineEnding +
    '    (c) 2008-2010 Arvid Winkelsdorf' + LineEnding +
    '    (c) 2009-2022 Bernd Gabriel' + LineEnding +
    '' + LineEnding +
    'FRAMEWORK' + LineEnding +
    '  Free Pascal Compiler, RTL and FCL' + LineEnding +
    '    GPL 2.0 (compiler), LGPL 2.1 with linking exception (libraries)' + LineEnding +
    '  Lazarus LCL, LazUtils and printer4lazarus' + LineEnding +
    '    modified LGPL, (c) the Lazarus team' + LineEnding +
    '  FreeType (through Lazarus)' + LineEnding +
    '    FreeType License (FTL) or GPL 2.0' + LineEnding +
    '' + LineEnding +
    'The update check uses the system TLS stack: WinInet on Windows,' + LineEnding +
    'FPC fphttpclient with OpenSSL elsewhere.' + LineEnding +
    '' + LineEnding +
    'Full copyright notices and license texts are in THIRDPARTY.md, installed' + LineEnding +
    'next to the program; MDPad itself is MIT licensed (see LICENSE).';

type
  TMdAboutPalette = record
    Bg, Fg, EditBg, Border: TColor;
  end;

  TMdAboutHelper = class(TComponent)
  public
    Dialog: TForm;
    Action: TMdAboutAction;
    procedure ProjectClick(Sender: TObject);
    procedure ReadmeClick(Sender: TObject);
    procedure NoticesClick(Sender: TObject);
    procedure CheckClick(Sender: TObject);
  end;

function MdRgb(ARed, AGreen, ABlue: Byte): TColor;
begin
  Result := TColor(ARed or (AGreen shl 8) or (ABlue shl 16));
end;

function MdPalette(ADark: Boolean): TMdAboutPalette;
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

// A data file the dialog may offer to open. '' when it is not installed next
// to the binary (a development build, for instance).
function MdLocalFile(const AName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + AName;
  if not FileExists(Result) then
    Result := '';
end;

procedure TMdAboutHelper.ProjectClick(Sender: TObject);
begin
  OpenURL(MdProjectURL);
end;

procedure TMdAboutHelper.ReadmeClick(Sender: TObject);
begin
  Action := aaReadme;
  Dialog.ModalResult := mrOk;
end;

procedure TMdAboutHelper.NoticesClick(Sender: TObject);
begin
  Action := aaThirdParty;
  Dialog.ModalResult := mrOk;
end;

procedure TMdAboutHelper.CheckClick(Sender: TObject);
begin
  Action := aaCheckUpdates;
  Dialog.ModalResult := mrOk;
end;

function MdShowAboutDialog(ADark: Boolean; const AVersion,
  ALatestVersion: string): TMdAboutAction;
var
  F: TForm;
  Helper: TMdAboutHelper;
  Pal: TMdAboutPalette;
  L: TLabel;
  Memo: TMemo;
  B: TButton;
  Readme, Notices: string;
  Latest: string;

  function NewLabel(const AText: string; AX, AY, AWidth, ASize: Integer;
    ABold: Boolean): TLabel;
  begin
    Result := TLabel.Create(F);
    Result.Parent := F;
    Result.Caption := AText;
    Result.Left := AX;
    Result.Top := AY;
    Result.Width := AWidth;
    Result.Font.Size := ASize;
    if ABold then
      Result.Font.Style := [fsBold];
    Result.Font.Color := Pal.Fg;
  end;

  function NewButton(const ACaption: string; AX, AWidth: Integer): TButton;
  begin
    Result := TButton.Create(F);
    Result.Parent := F;
    Result.Caption := ACaption;
    Result.Left := AX;
    Result.Top := 540;
    Result.Height := 28;
    Result.Width := AWidth;
    // The font color is left to the widgetset: forcing the form's own color
    // would make a disabled button look enabled (and would be unreadable on a
    // light widgetset while the app is dark). The labels and the memo above
    // carry the palette.
  end;

begin
  Pal := MdPalette(ADark);
  Readme := MdLocalFile('Readme.md');
  Notices := MdLocalFile('THIRDPARTY.md');

  F := TForm.CreateNew(nil);
  try
    F.Caption := 'About MDPad';
    F.BorderStyle := bsDialog;
    F.Position := poScreenCenter;
    F.ClientWidth := 700;
    F.ClientHeight := 600;
    F.Color := Pal.Bg;
    F.Font.Color := Pal.Fg;

    Helper := TMdAboutHelper.Create(F);
    Helper.Dialog := F;
    Helper.Action := aaClose;

    // The application icon, when this build has one (the resource is Windows
    // only; on Linux Application.Icon can be empty).
    if not Application.Icon.Empty then
    begin
      with TImage.Create(F) do
      begin
        Parent := F;
        Left := 18;
        Top := 16;
        Width := 48;
        Height := 48;
        Center := True;
        Picture.Icon.Assign(Application.Icon);
      end;
    end;

    NewLabel('MDPad', 84, 10, 300, 18, True);
    NewLabel('Version ' + AVersion, 86, 40, 300, 10, False);
    NewLabel('Victor Alberto Gil (vhanla)  -  ' + MdProjectURL, 86, 58, 560, 9, False);

    Memo := TMemo.Create(F);
    Memo.Parent := F;
    Memo.Left := 16;
    Memo.Top := 92;
    Memo.Width := 668;
    Memo.Height := 386;
    Memo.ScrollBars := ssAutoBoth;
    Memo.WordWrap := False;
    Memo.ReadOnly := True;
    Memo.Color := Pal.EditBg;
    Memo.Font.Color := Pal.Fg;
    {$IFDEF MSWINDOWS}
    Memo.Font.Name := 'Consolas';
    {$ELSE}
    Memo.Font.Name := 'Monospace';
    {$ENDIF}
    Memo.Font.Size := 9;
    Memo.Lines.Text := MdCredits;
    // A read-only memo starts with the whole text selected and the caret at the
    // end; both are noise for a window that is only meant to be read.
    Memo.SelStart := 0;
    Memo.SelLength := 0;

    Latest := '';
    if ALatestVersion <> '' then
    begin
      if MdVersionIsNewer(ALatestVersion, AVersion) then
        Latest := 'New release available: ' + ALatestVersion
          + ' (this build is ' + AVersion + ').'
      else
        Latest := 'Latest known release: ' + ALatestVersion
          + ' (this build is ' + AVersion + ').';
    end
    else
      Latest := 'Updates: not checked yet.';
    L := NewLabel(Latest, 16, 490, 430, 9, False);
    L.AutoSize := False;
    L.WordWrap := True;
    L.Height := 34;

    B := NewButton('Project page', 16, 110);
    B.OnClick := Helper.ProjectClick;

    B := NewButton('Readme', 132, 82);
    B.Enabled := Readme <> '';
    B.OnClick := Helper.ReadmeClick;
    B.Hint := Readme;

    B := NewButton('Notices', 220, 82);
    B.Enabled := Notices <> '';
    B.OnClick := Helper.NoticesClick;
    B.Hint := Notices;

    B := NewButton('Check for updates', 440, 160);
    B.OnClick := Helper.CheckClick;

    B := NewButton('Close', 608, 76);
    B.ModalResult := mrCancel;
    B.Cancel := True;

    Result := aaClose;
    if F.ShowModal = mrOk then
      Result := Helper.Action;
  finally
    F.Free;
  end;
end;

end.
