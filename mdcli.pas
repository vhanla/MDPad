unit mdcli;

{$mode objfpc}{$H+}{$J-}

// Command line parsing for MDPad.
//
// Deliberately free of LCL and of the form unit: the program parses the
// command line before Application.Initialize, so --help and --version work
// without a display (and without loading the editor at all).
//
// The options are one-session overrides. The form reads TMdCliOptions through
// the global MdCliOpts and marks each applied axis, so SaveINI leaves the stored
// settings.ini value alone until the same pick is made in the GUI.

interface

uses
  SysUtils, mdversioninfo;

type
  TMdCliView = (cvKeep, cvBoth, cvEditor, cvResult);
  // The ordinals of the preview and engine choices are the pv* / md* ids the
  // app already stores in settings.ini, so the form can map them with Ord().
  TMdCliPreview = (cpKeep, cpHtml, cpMd4d, cpIE);
  TMdCliEngine = (ceKeep, cePageDown, ceMarkdownJS, ceMarked, ceShowDown,
    ceMarkdownIt, ceNative, ceMd4d);
  TMdCliSwitch = (csKeep, csOn, csOff);
  TMdCliTheme = (ctKeep, ctSystem, ctLight, ctDark, ctCustom);
  TMdCliAction = (caRun, caHelp, caVersion, caError);

  TMdCliOptions = record
    FileName: string;       // first positional argument, '' when there is none
    View: TMdCliView;
    Preview: TMdCliPreview;
    Engine: TMdCliEngine;
    Theme: TMdCliTheme;
    Tree: TMdCliSwitch;
    Syntax: TMdCliSwitch;
    Sync: TMdCliSwitch;
    RemoteImages: TMdCliSwitch;
    Zoom: Integer;          // 0 = keep, otherwise 50..200 (percent)
    // Session-only, with no settings key: --no-update-check keeps this run from
    // checking GitHub automatically (useful for scripts and tests too). An
    // explicit Help > Check for updates still works.
    NoUpdateCheck: Boolean;
  end;

// MdVersion lives in mdversioninfo.pas, which is also what the About dialog and
// tools/build-release.sh read; --version prints it below.

var
  // Filled by MdCliParse; the form reads it at startup.
  MdCliOpts: TMdCliOptions;

// Parses the process command line into MdCliOpts. Returns caRun for a normal
// start, caHelp/caVersion when the program should print and exit, and caError
// with AError set for a bad argument.
function MdCliParse(out AError: string): TMdCliAction;

// The --help text (without a trailing newline).
function MdCliUsage: string;

// True for the extensions MDPad treats as a markdown document. Used for the
// "preview only when a markdown file is passed" default; a file of any other
// extension keeps the menu's default layout.
function MdIsMarkdownFileName(const AFileName: string): Boolean;

implementation

function MdCliUsage: string;
begin
  Result :=
    'MDPad ' + MdVersion + ' - a fast Markdown editor and viewer' + LineEnding +
    '' + LineEnding +
    'Usage: mdpad [options] [file]' + LineEnding +
    '' + LineEnding +
    'A markdown file passed on the command line opens in the preview only (the' + LineEnding +
    'same as View > Result only, F9), with the table of contents as it was last' + LineEnding +
    'left. The options below change this session only: settings.ini keeps its' + LineEnding +
    'stored values unless the same pick is made in the menus or the Options' + LineEnding +
    'dialog.' + LineEnding +
    '' + LineEnding +
    '  --view=result|both|editor' + LineEnding +
    '                          Preview only (the default with a markdown file),' + LineEnding +
    '                          editor and preview, or editor only.' + LineEnding +
    '  --preview=html|md4d|ie  Preview backend: THtmlViewer, Markdown4D canvas, or' + LineEnding +
    '                          the IE ActiveX viewer (Windows only).' + LineEnding +
    '  --engine=native|md4d|pagedown|markdownjs|marked|showdown|markdownit' + LineEnding +
    '                          Markdown engine; the numeric id settings.ini uses' + LineEnding +
    '                          (1..7) works too. The JavaScript ones need Windows.' + LineEnding +
    '  --tree=on|off           Table of contents pane.' + LineEnding +
    '  --theme=system|light|dark|custom' + LineEnding +
    '  --zoom=50..200          Preview zoom, snapped to 50, 75, 100, 125, 150 or' + LineEnding +
    '                          200 percent.' + LineEnding +
    '  --syntax=on|off         Editor syntax highlighting.' + LineEnding +
    '  --sync=on|off           Two-way scroll sync between editor and preview.' + LineEnding +
    '  --remote-images=on|off  Fetch remote images in the canvas preview.' + LineEnding +
    '  --no-update-check       Do not check for updates automatically this run.' + LineEnding +
    '  -h, --help              This help.' + LineEnding +
    '  --version               Print the version and exit.' + LineEnding +
    '' + LineEnding +
    'Use -- before a file name that starts with a dash.';
end;

function MdIsMarkdownFileName(const AFileName: string): Boolean;
const
  Extensions: array[0..8] of string = (
    '.md', '.markdown', '.mdown', '.mkd', '.mkdn', '.mdwn', '.mkdown',
    '.mdtext', '.mdtxt');
var
  Ext: string;
  I: Integer;
begin
  Result := False;
  Ext := LowerCase(ExtractFileExt(AFileName));
  for I := Low(Extensions) to High(Extensions) do
    if Ext = Extensions[I] then
      Exit(True);
end;

function MdCliParse(out AError: string): TMdCliAction;
var
  I, P, N: Integer;
  Arg, Name, Inline, Value: string;
  NoMoreOptions: Boolean;
  Switch: TMdCliSwitch;

  function TakeValue(const AName, AInline: string; out AValue: string): Boolean;
  begin
    Result := True;
    if AInline <> '' then
      AValue := AInline
    else if I < ParamCount then
    begin
      Inc(I);
      AValue := ParamStr(I);
    end
    else
    begin
      AError := 'option --' + AName + ' needs a value';
      Result := False;
    end;
  end;

  function ParseOnOff(const AText: string; out ASwitch: TMdCliSwitch): Boolean;
  begin
    Result := True;
    if (AText = 'on') or (AText = 'true') or (AText = 'yes') or (AText = '1') then
      ASwitch := csOn
    else if (AText = 'off') or (AText = 'false') or (AText = 'no') or (AText = '0') then
      ASwitch := csOff
    else
    begin
      AError := 'expected on or off, got "' + AText + '"';
      Result := False;
    end;
  end;

  function AddFile(const AFile: string): Boolean;
  begin
    Result := True;
    if MdCliOpts.FileName = '' then
      MdCliOpts.FileName := AFile
    else
    begin
      AError := 'only one file can be opened (already got "' + MdCliOpts.FileName + '")';
      Result := False;
    end;
  end;

begin
  AError := '';

  // MdCliOpts is a global record, already zeroed when the program starts; these
  // assignments keep a second call (a test driver) safe as well.
  MdCliOpts.FileName := '';
  MdCliOpts.View := cvKeep;
  MdCliOpts.Preview := cpKeep;
  MdCliOpts.Engine := ceKeep;
  MdCliOpts.Theme := ctKeep;
  MdCliOpts.Tree := csKeep;
  MdCliOpts.Syntax := csKeep;
  MdCliOpts.Sync := csKeep;
  MdCliOpts.RemoteImages := csKeep;
  MdCliOpts.Zoom := 0;
  MdCliOpts.NoUpdateCheck := False;

  NoMoreOptions := False;
  I := 1;
  while I <= ParamCount do
  begin
    Arg := ParamStr(I);

    if NoMoreOptions then
    begin
      if not AddFile(Arg) then
        Exit(caError);
    end
    else if Arg = '--' then
      NoMoreOptions := True
    else if (Arg = '-h') or (Arg = '--help') then
      Exit(caHelp)
    else if (Arg = '-V') or (Arg = '--version') then
      Exit(caVersion)
    else if Copy(Arg, 1, 2) = '--' then
    begin
      Name := Copy(Arg, 3, MaxInt);
      Inline := '';
      P := Pos('=', Name);
      if P > 0 then
      begin
        Inline := Copy(Name, P + 1, MaxInt);
        Name := Copy(Name, 1, P - 1);
      end;
      Name := LowerCase(Name);
      if Name = '' then
      begin
        AError := 'bad option "' + Arg + '"';
        Exit(caError);
      end;

      if Name = 'view' then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        Value := LowerCase(Value);
        if (Value = 'result') or (Value = 'result-only') or (Value = 'f9') then
          MdCliOpts.View := cvResult
        else if (Value = 'both') or (Value = 'editor-and-result') then
          MdCliOpts.View := cvBoth
        else if (Value = 'editor') or (Value = 'editor-only') then
          MdCliOpts.View := cvEditor
        else
        begin
          AError := '--view expects result, both or editor (got "' + Value + '")';
          Exit(caError);
        end;
      end

      else if Name = 'preview' then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        Value := LowerCase(Value);
        if Value = 'html' then
          MdCliOpts.Preview := cpHtml
        else if (Value = 'md4d') or (Value = 'markdown4d') or (Value = 'canvas') then
          MdCliOpts.Preview := cpMd4d
        else if (Value = 'ie') or (Value = 'browser') then
          MdCliOpts.Preview := cpIE
        else if TryStrToInt(Value, N) and (N >= Ord(cpHtml)) and (N <= Ord(cpIE)) then
          MdCliOpts.Preview := TMdCliPreview(N)
        else
        begin
          AError := '--preview expects html, md4d or ie (got "' + Value + '")';
          Exit(caError);
        end;
      end

      else if Name = 'engine' then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        Value := LowerCase(Value);
        if Value = 'pagedown' then
          MdCliOpts.Engine := cePageDown
        else if (Value = 'markdownjs') or (Value = 'markdown.js') then
          MdCliOpts.Engine := ceMarkdownJS
        else if Value = 'marked' then
          MdCliOpts.Engine := ceMarked
        else if Value = 'showdown' then
          MdCliOpts.Engine := ceShowDown
        else if Value = 'markdownit' then
          MdCliOpts.Engine := ceMarkdownIt
        else if Value = 'native' then
          MdCliOpts.Engine := ceNative
        else if (Value = 'md4d') or (Value = 'markdown4d') then
          MdCliOpts.Engine := ceMd4d
        else if TryStrToInt(Value, N) and (N >= Ord(cePageDown)) and (N <= Ord(ceMd4d)) then
          MdCliOpts.Engine := TMdCliEngine(N)
        else
        begin
          AError := '--engine expects native, md4d, pagedown, markdownjs, marked, '
            + 'showdown or markdownit (got "' + Value + '")';
          Exit(caError);
        end;
      end

      else if Name = 'theme' then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        Value := LowerCase(Value);
        if Value = 'system' then
          MdCliOpts.Theme := ctSystem
        else if Value = 'light' then
          MdCliOpts.Theme := ctLight
        else if Value = 'dark' then
          MdCliOpts.Theme := ctDark
        else if Value = 'custom' then
          MdCliOpts.Theme := ctCustom
        else
        begin
          AError := '--theme expects system, light, dark or custom (got "' + Value + '")';
          Exit(caError);
        end;
      end

      else if (Name = 'tree') or (Name = 'syntax') or (Name = 'sync')
        or (Name = 'remote-images') then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        if not ParseOnOff(LowerCase(Value), Switch) then
          Exit(caError);
        if Name = 'tree' then
          MdCliOpts.Tree := Switch
        else if Name = 'syntax' then
          MdCliOpts.Syntax := Switch
        else if Name = 'sync' then
          MdCliOpts.Sync := Switch
        else
          MdCliOpts.RemoteImages := Switch;
      end

      else if Name = 'no-update-check' then
        MdCliOpts.NoUpdateCheck := True

      else if Name = 'zoom' then
      begin
        if not TakeValue(Name, Inline, Value) then
          Exit(caError);
        if (Value <> '') and (Value[Length(Value)] = '%') then
          Delete(Value, Length(Value), 1);
        if not TryStrToInt(Value, N) or (N < 50) or (N > 200) then
        begin
          AError := '--zoom expects a percentage between 50 and 200 (got "' + Value + '")';
          Exit(caError);
        end;
        MdCliOpts.Zoom := N;
      end

      else
      begin
        AError := 'unknown option "--' + Name + '"';
        Exit(caError);
      end;
    end
    else if (Arg <> '') and (Arg[1] = '-') then
    begin
      AError := 'unknown option "' + Arg + '"';
      Exit(caError);
    end
    else if not AddFile(Arg) then
      Exit(caError);

    Inc(I);
  end;

  // Off Windows neither the IE backend nor the JavaScript engines exist: the
  // app would silently fall back to the native pipeline, which is exactly the
  // kind of "the option did nothing" a command line should not have.
  {$IFNDEF MSWINDOWS}
  if MdCliOpts.Preview = cpIE then
  begin
    AError := '--preview=ie is Windows only (use html or md4d here)';
    Exit(caError);
  end;
  if (MdCliOpts.Engine >= cePageDown) and (MdCliOpts.Engine <= ceMarkdownIt) then
  begin
    AError := 'the JavaScript engines need Internet Explorer, i.e. Windows '
      + '(use native or md4d here)';
    Exit(caError);
  end;
  {$ENDIF}

  Result := caRun;
end;

end.
