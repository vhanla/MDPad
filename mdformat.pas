unit mdformat;
{ Markdown inline-editing engine for MDPad.

  Everything here is pure: it takes the text and offsets (in UTF-16 code units,
  the units ATSynEdit's CaretPosToOffset/OffsetToCaretPos use) and returns the
  edit that produces the result, so the UI layer only has to apply it. That is
  what makes every command testable without a window (see AGENTS.md).

  Offsets are 0-based, End is exclusive. Inside the routines string positions
  are 1-based, as usual in Pascal. The unit is LCL-free on purpose. }

{$mode delphi}
{$H+}

interface

uses
  SysUtils;

type
  TMdStringArray = array of UnicodeString;

  // Replace [StartOffset, EndOffset) in the original text with InsertText; the
  // editor should then select [SelStart, SelEnd) of the resulting text.
  // Changed = False means "leave the editor alone".
  TMdEdit = record
    Changed: Boolean;
    StartOffset: Integer;
    EndOffset: Integer;
    InsertText: UnicodeString;
    SelStart: Integer;
    SelEnd: Integer;
  end;

  // What Enter at the end of a list / quote line does.
  TMdContinuationKind = (
    mdNone,      // not a block that continues: the editor does its own thing
    mdContinue,  // insert the line break, then Prefix
    mdExitList   // remove the marker of the (empty) item, no line break
  );

  TMdContinuation = record
    Kind: TMdContinuationKind;
    Prefix: UnicodeString; // mdContinue: the marker, without the indent
  end;

function MdEmptyEdit: TMdEdit;

function MdTrim(const S: UnicodeString): UnicodeString;
function MdTrimLeft(const S: UnicodeString): UnicodeString;

// Line geometry over a plain string.
function MdLineStart(const AText: UnicodeString; AOffset: Integer): Integer;
function MdLineEndAt(const AText: UnicodeString; AOffset: Integer): Integer;
function MdIsFenceLine(const ALine: UnicodeString): Boolean;

// The word touching AOffset (the one to its left when it sits on a boundary).
function MdWordRange(const AText: UnicodeString; AOffset: Integer;
  out AStart, AEnd: Integer): Boolean;

// **bold**, *italic*, ~~strike~~, `code`: wraps, or unwraps when the markers
// are already there (just outside the selection or inside it). Without a
// selection it works on the word under the caret; without a word it inserts
// the pair and leaves the caret in the middle.
function MdToggleInline(const AText: UnicodeString; AStart, AEnd: Integer;
  const AMarker: UnicodeString): TMdEdit;

// > quote, - list, 1. list: adds the prefix to every selected line, or removes
// it from every line that has it.
function MdToggleLinePrefix(const AText: UnicodeString; AStart, AEnd: Integer;
  const APrefix: UnicodeString): TMdEdit;

// # -> ## -> ... -> ###### -> no heading, on every selected line.
function MdCycleHeading(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;

// - [ ] -> - [x] -> - [ ], adding the item when the line is not a list one.
function MdToggleTask(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;

// Fenced code block around the selected lines, or removes the fences when the
// block already has them.
function MdToggleFence(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;

// [text](url "title") / ![alt](src "title") at the selection. ALabel = '' means
// "use the selected text"; without a selection and label the caret lands
// inside the empty brackets.
function MdInsertLink(const AText: UnicodeString; AStart, AEnd: Integer;
  const ALabel, AUrl, ATitle: UnicodeString): TMdEdit;
function MdInsertImage(const AText: UnicodeString; AStart, AEnd: Integer;
  const AAlt, ASrc, ATitle: UnicodeString): TMdEdit;

// The markup alone, for the dialogs (an existing link/image is rebuilt in
// place with the edited values).
function MdBuildLink(const ATextPart, ATarget, ATitle: UnicodeString): UnicodeString;
function MdBuildImage(const AAlt, ASrc, ATitle: UnicodeString): UnicodeString;

// Case-insensitive comparison helpers (no widestring manager involved).
function MdEqualText(const A, B: UnicodeString): Boolean;
function MdStartsWithText(const AText, APrefix: UnicodeString): Boolean;

// A GFM table on its own line(s) at the caret, or --- at the caret line.
function MdInsertTable(const AText: UnicodeString; AOffset: Integer;
  ARows, ACols: Integer): TMdEdit;
function MdInsertRule(const AText: UnicodeString; AOffset: Integer): TMdEdit;

// Finds the link/image markup the caret is in or touching, so the dialog can
// show what is already there and the command can replace it.
function MdFindMarkupAt(const AText: UnicodeString; AOffset: Integer;
  AImage: Boolean; out AStart, AEnd: Integer;
  out ATextPart, ATarget, ATitle: UnicodeString): Boolean;

// Smart Enter. AInFence says the caret is inside a fenced block (see
// MdIsFenceLine), where lists do not continue.
function MdContinuation(const ALine: UnicodeString; ACaretX: Integer;
  AInFence: Boolean): TMdContinuation;

// Word completion: the word ending at AOffset, and the document's words, one
// entry per spelling (case-insensitive, sorted). The caller owns nothing: the
// array is managed.
function MdWordBeforeCaret(const AText: UnicodeString; AOffset: Integer;
  out AStart: Integer): UnicodeString;
function MdCollectWords(const AText: UnicodeString; AMinLen: Integer): TMdStringArray;

implementation

function MdEmptyEdit: TMdEdit;
begin
  Result.Changed := False;
  Result.StartOffset := 0;
  Result.EndOffset := 0;
  Result.InsertText := '';
  Result.SelStart := 0;
  Result.SelEnd := 0;
end;

function MdMakeEdit(AStart, AEnd: Integer; const AInsert: UnicodeString;
  ASelStart, ASelEnd: Integer): TMdEdit;
begin
  Result.Changed := True;
  Result.StartOffset := AStart;
  Result.EndOffset := AEnd;
  Result.InsertText := AInsert;
  Result.SelStart := ASelStart;
  Result.SelEnd := ASelEnd;
end;

function MdU(C: WideChar): UnicodeString;
begin
  Result := C;
end;

function MdIntToStr(AValue: Integer): UnicodeString;
var
  Digits: array[0..11] of WideChar;
  n: Integer;
  Neg: Boolean;
begin
  if AValue = 0 then
  begin
    Result := '0';
    Exit;
  end;
  Neg := AValue < 0;
  if Neg then
    AValue := -AValue;
  n := 0;
  while AValue > 0 do
  begin
    Digits[n] := WideChar(Ord('0') + (AValue mod 10));
    AValue := AValue div 10;
    Inc(n);
  end;
  Result := '';
  if Neg then
    Result := '-';
  while n > 0 do
  begin
    Dec(n);
    Result := Result + Digits[n];
  end;
end;

function MdTrimLeft(const S: UnicodeString): UnicodeString;
var
  p: Integer;
begin
  p := 1;
  while (p <= Length(S)) and (S[p] in [' ', #9, #10, #13]) do
    Inc(p);
  Result := Copy(S, p, MaxInt);
end;

function MdTrim(const S: UnicodeString): UnicodeString;
var
  p, q: Integer;
begin
  p := 1;
  while (p <= Length(S)) and (S[p] in [' ', #9, #10, #13]) do
    Inc(p);
  q := Length(S);
  while (q >= p) and (S[q] in [' ', #9, #10, #13]) do
    Dec(q);
  Result := Copy(S, p, q - p + 1);
end;

function MdClampOffset(const AText: UnicodeString; AOffset: Integer): Integer;
begin
  if AOffset < 0 then
    Result := 0
  else if AOffset > Length(AText) then
    Result := Length(AText)
  else
    Result := AOffset;
end;

function MdLineStart(const AText: UnicodeString; AOffset: Integer): Integer;
var
  p: Integer;
begin
  p := MdClampOffset(AText, AOffset);
  // AText[p] is the character just before the caret. When it is a line break
  // the caret is at the start of the next line, i.e. already the line start.
  while (p > 0) and (AText[p] <> #10) and (AText[p] <> #13) do
    Dec(p);
  Result := p;
end;

function MdLineEndAt(const AText: UnicodeString; AOffset: Integer): Integer;
var
  p: Integer;
begin
  p := MdLineStart(AText, AOffset);
  while (p < Length(AText)) and (AText[p + 1] <> #10) and (AText[p + 1] <> #13) do
    Inc(p);
  Result := p;
end;

function MdLineBreakLenAt(const AText: UnicodeString; AOffset: Integer): Integer;
begin
  Result := 0;
  if (AOffset >= Length(AText)) or (AOffset < 0) then
    Exit;
  if AText[AOffset + 1] = #13 then
    Inc(Result);
  if (AOffset + Result < Length(AText)) and (AText[AOffset + Result + 1] = #10) then
    Inc(Result);
end;

function MdEolAfter(const AText: UnicodeString; AOffset: Integer): UnicodeString;
var
  n: Integer;
begin
  n := MdLineBreakLenAt(AText, AOffset);
  Result := Copy(AText, AOffset + 1, n);
end;

function MdFirstEol(const AText: UnicodeString): UnicodeString;
var
  p: Integer;
begin
  for p := 1 to Length(AText) do
    if (AText[p] = #13) or (AText[p] = #10) then
    begin
      Result := MdEolAfter(AText, p - 1);
      Exit;
    end;
  // No line break to copy: use LF, which every editor and Markdown file reads
  // the same way. (sLineBreak would need a widestring manager just to be
  // converted from a runtime AnsiString, and this unit must stay LCL-free.)
  Result := #10;
end;

function MdIsFenceLine(const ALine: UnicodeString): Boolean;
var
  s: UnicodeString;
begin
  s := MdTrimLeft(ALine);
  Result := (Copy(s, 1, 3) = '```') or (Copy(s, 1, 3) = '~~~');
end;

function MdIsWordChar(C: WideChar): Boolean;
begin
  Result := ((C >= 'a') and (C <= 'z'))
    or ((C >= 'A') and (C <= 'Z'))
    or ((C >= '0') and (C <= '9'))
    or (C = '_')
    or (Ord(C) > 127); // letters outside ASCII; never split a word there
end;

function MdWordRange(const AText: UnicodeString; AOffset: Integer;
  out AStart, AEnd: Integer): Boolean;
var
  p, q: Integer;
begin
  AOffset := MdClampOffset(AText, AOffset);
  AStart := AOffset;
  AEnd := AOffset;
  Result := False;
  if (AOffset > 0) and MdIsWordChar(AText[AOffset]) then
  begin
    p := AOffset;
    while (p > 0) and MdIsWordChar(AText[p]) do
      Dec(p);
    q := AOffset;
    while (q < Length(AText)) and MdIsWordChar(AText[q + 1]) do
      Inc(q);
    AStart := p;
    AEnd := q;
    Result := True;
  end
  else if (AOffset < Length(AText)) and MdIsWordChar(AText[AOffset + 1]) then
  begin
    p := AOffset + 1;
    while (p > 0) and MdIsWordChar(AText[p]) do
      Dec(p);
    q := AOffset + 1;
    while (q < Length(AText)) and MdIsWordChar(AText[q + 1]) do
      Inc(q);
    AStart := p;
    AEnd := q;
    Result := True;
  end;
end;

function MdToggleInline(const AText: UnicodeString; AStart, AEnd: Integer;
  const AMarker: UnicodeString): TMdEdit;
var
  ML, Caret, WS, WE, Swap: Integer;
  Inner: UnicodeString;
  NoSel: Boolean;
begin
  Result := MdEmptyEdit;
  ML := Length(AMarker);
  if ML = 0 then
    Exit;
  AStart := MdClampOffset(AText, AStart);
  AEnd := MdClampOffset(AText, AEnd);
  if AEnd < AStart then
  begin
    Swap := AStart;
    AStart := AEnd;
    AEnd := Swap;
  end;

  NoSel := AStart = AEnd;
  Caret := AStart;
  if NoSel then
  begin
    if MdWordRange(AText, AStart, WS, WE) then
    begin
      AStart := WS;
      AEnd := WE;
    end
    else
    begin
      // Nothing to wrap: the pair, with the caret between the markers.
      Result := MdMakeEdit(AStart, AStart, AMarker + AMarker,
        AStart + ML, AStart + ML);
      Exit;
    end;
  end;

  // Already wrapped, markers just outside the selection? A marker that is part
  // of a longer run of the same character (the * of **bold**, say) is not this
  // marker, or toggling italic inside bold would strip the bold instead.
  if (AStart >= ML) and (AEnd + ML <= Length(AText))
    and (Copy(AText, AStart - ML + 1, ML) = AMarker)
    and (Copy(AText, AEnd + 1, ML) = AMarker)
    and ((AStart - ML = 0) or (AText[AStart - ML] <> AMarker[1]))
    and ((AEnd + ML = Length(AText)) or (AText[AEnd + ML + 1] <> AMarker[1])) then
  begin
    Result := MdMakeEdit(AStart - ML, AEnd + ML,
      Copy(AText, AStart + 1, AEnd - AStart),
      AStart - ML, AEnd - ML);
    if NoSel then
    begin
      Result.SelStart := Caret - ML;
      Result.SelEnd := Caret - ML;
    end;
    Exit;
  end;

  // Or does the selection include the markers itself?
  if (AEnd - AStart >= 2 * ML)
    and (Copy(AText, AStart + 1, ML) = AMarker)
    and (Copy(AText, AEnd - ML + 1, ML) = AMarker) then
  begin
    Inner := Copy(AText, AStart + ML + 1, AEnd - AStart - 2 * ML);
    if (Inner = '') or ((Inner[1] <> AMarker[1])
      and (Inner[Length(Inner)] <> AMarker[1])) then
    begin
      Result := MdMakeEdit(AStart, AEnd, Inner, AStart, AEnd - 2 * ML);
      Exit;
    end;
  end;

  Inner := Copy(AText, AStart + 1, AEnd - AStart);
  Result := MdMakeEdit(AStart, AEnd, AMarker + Inner + AMarker,
    AStart + ML, AEnd + ML);
  if NoSel then
  begin
    Result.SelStart := Caret + ML;
    Result.SelEnd := Caret + ML;
  end;
end;

function MdIndentLen(const ALine: UnicodeString): Integer;
begin
  Result := 0;
  while (Result < Length(ALine))
    and ((ALine[Result + 1] = ' ') or (ALine[Result + 1] = #9)) do
    Inc(Result);
end;

// Splits [AStart, AEnd) into lines: AStart is a line start, AEnd the end of
// the last line's content (no line break). ABreaks keeps the line breaks that
// were between the lines, so a rewrite never changes the document's EOLs.
procedure MdSplitBlock(const AText: UnicodeString; AStart, AEnd: Integer;
  var ALines, ABreaks: TMdStringArray);
var
  i, p, n: Integer;
  Eol: UnicodeString;
begin
  SetLength(ALines, 0);
  SetLength(ABreaks, 0);
  i := AStart;
  while i < AEnd do
  begin
    p := i;
    while (p < AEnd) and (AText[p + 1] <> #10) and (AText[p + 1] <> #13) do
      Inc(p);
    n := Length(ALines);
    SetLength(ALines, n + 1);
    ALines[n] := Copy(AText, i + 1, p - i);
    if p < AEnd then
    begin
      Eol := MdEolAfter(AText, p);
      Inc(p, Length(Eol));
      n := Length(ABreaks);
      SetLength(ABreaks, n + 1);
      ABreaks[n] := Eol;
    end;
    i := p;
  end;
  if Length(ALines) = 0 then
  begin
    SetLength(ALines, 1);
    ALines[0] := '';
  end;
end;

function MdJoinBlock(const ALines, ABreaks: TMdStringArray): UnicodeString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(ALines) - 1 do
  begin
    Result := Result + ALines[i];
    if i < Length(ABreaks) then
      Result := Result + ABreaks[i];
  end;
end;

// The whole-line block touched by [AStart, AEnd): LStart is the first line's
// start, LEnd the last line's content end.
procedure MdBlockBounds(const AText: UnicodeString; AStart, AEnd: Integer;
  out LStart, LEnd: Integer);
var
  last: Integer;
begin
  AStart := MdClampOffset(AText, AStart);
  AEnd := MdClampOffset(AText, AEnd);
  if AEnd < AStart then
    AEnd := AStart;
  LStart := MdLineStart(AText, AStart);
  if AEnd > AStart then
    last := AEnd - 1
  else
    last := AStart;
  LEnd := MdLineEndAt(AText, last);
end;

function MdToggleLinePrefix(const AText: UnicodeString; AStart, AEnd: Integer;
  const APrefix: UnicodeString): TMdEdit;
var
  LStart, LEnd, i, Ind: Integer;
  Lines, Breaks: TMdStringArray;
  Line, NewText: UnicodeString;
  AllHave, Some: Boolean;
begin
  Result := MdEmptyEdit;
  if APrefix = '' then
    Exit;
  MdBlockBounds(AText, AStart, AEnd, LStart, LEnd);

  MdSplitBlock(AText, LStart, LEnd, Lines, Breaks);
  AllHave := True;
  Some := False;
  for i := 0 to Length(Lines) - 1 do
    if MdTrim(Lines[i]) <> '' then
    begin
      Some := True;
      Ind := MdIndentLen(Lines[i]);
      if Copy(Lines[i], Ind + 1, Length(APrefix)) <> APrefix then
        AllHave := False;
    end;
  if not Some then
    Exit;
  for i := 0 to Length(Lines) - 1 do
  begin
    Line := Lines[i];
    Ind := MdIndentLen(Line);
    if AllHave then
    begin
      if Copy(Line, Ind + 1, Length(APrefix)) = APrefix then
        Lines[i] := Copy(Line, 1, Ind)
          + Copy(Line, Ind + Length(APrefix) + 1, MaxInt);
    end
    else
      Lines[i] := Copy(Line, 1, Ind) + APrefix + Copy(Line, Ind + 1, MaxInt);
  end;
  NewText := MdJoinBlock(Lines, Breaks);
  Result := MdMakeEdit(LStart, LEnd, NewText, LStart, LStart + Length(NewText));
end;

function MdCycleHeading(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;
var
  LStart, LEnd, i, N: Integer;
  Lines, Breaks: TMdStringArray;
  Line, NewText: UnicodeString;
  DidChange: Boolean;
begin
  Result := MdEmptyEdit;
  MdBlockBounds(AText, AStart, AEnd, LStart, LEnd);
  MdSplitBlock(AText, LStart, LEnd, Lines, Breaks);
  DidChange := False;
  for i := 0 to Length(Lines) - 1 do
  begin
    Line := Lines[i];
    if MdTrim(Line) = '' then
      Continue;
    N := 0;
    while (N < Length(Line)) and (Line[N + 1] = '#') do
      Inc(N);
    if (N > 0) and (N <= 6)
      and ((N = Length(Line)) or (Line[N + 1] = ' ')) then
    begin
      if N = 6 then
      begin
        if (Length(Line) >= 7) and (Line[7] = ' ') then
          Line := Copy(Line, 8, MaxInt)
        else
          Line := Copy(Line, 7, MaxInt);
      end
      else
        Line := '#' + Line;
    end
    else
      Line := '# ' + Line;
    Lines[i] := Line;
    DidChange := True;
  end;
  if not DidChange then
    Exit;
  NewText := MdJoinBlock(Lines, Breaks);
  Result := MdMakeEdit(LStart, LEnd, NewText, LStart, LStart + Length(NewText));
end;

// Rewrites one line's task marker. Returns False when the line is empty.
function MdToggleTaskLine(const ALine: UnicodeString; out ANew: UnicodeString): Boolean;
var
  i, MarkerEnd: Integer;
  Box: WideChar;
begin
  ANew := ALine;
  if MdTrim(ALine) = '' then
    Exit(False);
  i := MdIndentLen(ALine);
  MarkerEnd := i;
  if (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] in ['-', '*', '+']) then
  begin
    Inc(MarkerEnd);
    while (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] = ' ') do
      Inc(MarkerEnd);
  end
  else if (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] in ['0'..'9']) then
  begin
    while (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] in ['0'..'9']) do
      Inc(MarkerEnd);
    if (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] in ['.', ')']) then
    begin
      Inc(MarkerEnd);
      while (MarkerEnd < Length(ALine)) and (ALine[MarkerEnd + 1] = ' ') do
        Inc(MarkerEnd);
    end;
  end;
  if MarkerEnd = i then
  begin
    // Not a list item at all: turn the line into one.
    ANew := Copy(ALine, 1, i) + '- [ ] ' + Copy(ALine, i + 1, MaxInt);
    Exit(True);
  end;
  if (MarkerEnd + 3 <= Length(ALine))
    and (ALine[MarkerEnd + 1] = '[') and (ALine[MarkerEnd + 3] = ']')
    and ((ALine[MarkerEnd + 2] = ' ') or (ALine[MarkerEnd + 2] = 'x')
      or (ALine[MarkerEnd + 2] = 'X')) then
  begin
    Box := ALine[MarkerEnd + 2];
    if Box = ' ' then
      Box := 'x'
    else
      Box := ' ';
    ANew := Copy(ALine, 1, MarkerEnd + 1) + MdU(Box)
      + Copy(ALine, MarkerEnd + 3, MaxInt);
    Exit(True);
  end;
  ANew := Copy(ALine, 1, MarkerEnd) + '[ ] ' + Copy(ALine, MarkerEnd + 1, MaxInt);
  Result := True;
end;

function MdToggleTask(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;
var
  LStart, LEnd, i: Integer;
  Lines, Breaks: TMdStringArray;
  Line, NewText: UnicodeString;
  DidChange: Boolean;
begin
  Result := MdEmptyEdit;
  MdBlockBounds(AText, AStart, AEnd, LStart, LEnd);
  MdSplitBlock(AText, LStart, LEnd, Lines, Breaks);
  DidChange := False;
  for i := 0 to Length(Lines) - 1 do
    if MdToggleTaskLine(Lines[i], Line) then
    begin
      if Line <> Lines[i] then
        DidChange := True;
      Lines[i] := Line;
    end;
  if not DidChange then
    Exit;
  NewText := MdJoinBlock(Lines, Breaks);
  Result := MdMakeEdit(LStart, LEnd, NewText, LStart, LStart + Length(NewText));
end;

function MdToggleFence(const AText: UnicodeString; AStart, AEnd: Integer): TMdEdit;
var
  LStart, LEnd, PrevStart, NextStart, NextEnd, n: Integer;
  Lines, Breaks: TMdStringArray;
  Block, Eol, Fence, PrevLine, NextLine: UnicodeString;
begin
  Result := MdEmptyEdit;
  MdBlockBounds(AText, AStart, AEnd, LStart, LEnd);
  Eol := MdEolAfter(AText, LEnd);
  if Eol = '' then
    Eol := MdFirstEol(AText);

  MdSplitBlock(AText, LStart, LEnd, Lines, Breaks);
  Block := MdJoinBlock(Lines, Breaks);

  // A fence right above and right below the block means "remove them".
  PrevLine := '';
  NextLine := '';
  PrevStart := 0;
  if LStart > 0 then
  begin
    PrevStart := MdLineStart(AText, LStart - 1);
    PrevLine := Copy(AText, PrevStart + 1, (LStart - 1) - PrevStart);
  end;
  NextStart := LEnd + Length(MdEolAfter(AText, LEnd));
  NextEnd := NextStart;
  if NextStart < Length(AText) then
  begin
    NextEnd := MdLineEndAt(AText, NextStart);
    NextLine := Copy(AText, NextStart + 1, NextEnd - NextStart);
  end;
  if MdIsFenceLine(PrevLine) and MdIsFenceLine(NextLine) then
  begin
    Result := MdMakeEdit(PrevStart, NextEnd, Block,
      PrevStart, PrevStart + Length(Block));
    Exit;
  end;

  // Insert the fences as whole lines around the block.
  Fence := '```';
  if Block = '' then
  begin
    Result := MdMakeEdit(LStart, LEnd,
      Fence + Eol + Eol + Fence,
      LStart + Length(Fence) + Length(Eol),
      LStart + Length(Fence) + Length(Eol));
    Exit;
  end;
  n := Length(Fence) + Length(Eol);
  Result := MdMakeEdit(LStart, LEnd,
    Fence + Eol + Block + Eol + Fence,
    LStart + n, LStart + n + Length(Block));
end;

function MdTitleSuffix(const ATitle: UnicodeString): UnicodeString;
var
  i: Integer;
  s: UnicodeString;
begin
  if ATitle = '' then
  begin
    Result := '';
    Exit;
  end;
  s := ATitle;
  for i := 1 to Length(s) do
    if s[i] = '"' then
      s[i] := '''';
  Result := ' "' + s + '"';
end;

function MdBuildLink(const ATextPart, ATarget, ATitle: UnicodeString): UnicodeString;
begin
  Result := '[' + ATextPart + '](' + ATarget + MdTitleSuffix(ATitle) + ')';
end;

function MdBuildImage(const AAlt, ASrc, ATitle: UnicodeString): UnicodeString;
begin
  Result := '![' + AAlt + '](' + ASrc + MdTitleSuffix(ATitle) + ')';
end;

function MdInsertLink(const AText: UnicodeString; AStart, AEnd: Integer;
  const ALabel, AUrl, ATitle: UnicodeString): TMdEdit;
var
  Inner, Ins: UnicodeString;
  Swap: Integer;
begin
  AStart := MdClampOffset(AText, AStart);
  AEnd := MdClampOffset(AText, AEnd);
  if AEnd < AStart then
  begin
    Swap := AStart;
    AStart := AEnd;
    AEnd := Swap;
  end;
  Inner := ALabel;
  if (Inner = '') and (AEnd > AStart) then
    Inner := Copy(AText, AStart + 1, AEnd - AStart);
  Ins := MdBuildLink(Inner, AUrl, ATitle);
  if AStart = AEnd then
    Result := MdMakeEdit(AStart, AEnd, Ins, AStart + 1, AStart + 1)
  else
    Result := MdMakeEdit(AStart, AEnd, Ins, AStart + 1, AStart + 1 + Length(Inner));
end;

function MdInsertImage(const AText: UnicodeString; AStart, AEnd: Integer;
  const AAlt, ASrc, ATitle: UnicodeString): TMdEdit;
var
  Ins: UnicodeString;
begin
  AStart := MdClampOffset(AText, AStart);
  AEnd := MdClampOffset(AText, AEnd);
  if AEnd < AStart then
    AEnd := AStart;
  Ins := MdBuildImage(AAlt, ASrc, ATitle);
  Result := MdMakeEdit(AStart, AEnd, Ins, AStart + 2, AStart + 2 + Length(AAlt));
end;

function MdTableText(const AEol: UnicodeString; ARows, ACols: Integer): UnicodeString;
var
  i, j: Integer;
  Line: UnicodeString;
begin
  if ACols < 1 then
    ACols := 1;
  if ACols > 12 then
    ACols := 12;
  if ARows < 0 then
    ARows := 0;
  if ARows > 50 then
    ARows := 50;
  Result := '|';
  for j := 1 to ACols do
    Result := Result + ' Header ' + MdIntToStr(j) + ' |';
  Result := Result + AEol + '|';
  for j := 1 to ACols do
    Result := Result + ' --- |';
  for i := 1 to ARows do
  begin
    Line := '|';
    for j := 1 to ACols do
      Line := Line + '  |';
    Result := Result + AEol + Line;
  end;
end;

function MdInsertTable(const AText: UnicodeString; AOffset: Integer;
  ARows, ACols: Integer): TMdEdit;
var
  LStart, LEnd, SelAt: Integer;
  Eol, Table, Line: UnicodeString;
begin
  AOffset := MdClampOffset(AText, AOffset);
  Eol := MdFirstEol(AText);
  Table := MdTableText(Eol, ARows, ACols);
  LStart := MdLineStart(AText, AOffset);
  LEnd := MdLineEndAt(AText, AOffset);
  Line := Copy(AText, LStart + 1, LEnd - LStart);
  SelAt := LStart + 2; // "Header 1" starts after "| "
  if MdTrim(Line) = '' then
    Result := MdMakeEdit(LStart, LEnd, Table, SelAt, SelAt + Length('Header 1'))
  else
    Result := MdMakeEdit(LStart, LStart, Table + Eol, SelAt,
      SelAt + Length('Header 1'));
end;

function MdInsertRule(const AText: UnicodeString; AOffset: Integer): TMdEdit;
var
  LStart, LEnd: Integer;
  Line, Eol: UnicodeString;
begin
  AOffset := MdClampOffset(AText, AOffset);
  Eol := MdFirstEol(AText);
  LStart := MdLineStart(AText, AOffset);
  LEnd := MdLineEndAt(AText, AOffset);
  Line := Copy(AText, LStart + 1, LEnd - LStart);
  if MdTrim(Line) = '' then
    Result := MdMakeEdit(LStart, LEnd, '---', LStart + 3, LStart + 3)
  else
    Result := MdMakeEdit(LStart, LStart, '---' + Eol, LStart + 3, LStart + 3);
end;

function MdFindMarkupAt(const AText: UnicodeString; AOffset: Integer;
  AImage: Boolean; out AStart, AEnd: Integer;
  out ATextPart, ATarget, ATitle: UnicodeString): Boolean;
var
  LE, i, Open, CloseB, OpenP, CloseP, q: Integer;
  Inner, Tgt, Ttl: UnicodeString;
begin
  Result := False;
  AStart := 0;
  AEnd := 0;
  ATextPart := '';
  ATarget := '';
  ATitle := '';
  AOffset := MdClampOffset(AText, AOffset);
  LE := MdLineEndAt(AText, AOffset);

  // Find the '[' at or before the caret on this line.
  i := AOffset;
  while (i >= 1) and (AText[i] <> '[') do
    Dec(i);
  if i < 1 then
    Exit;
  Open := i;
  if AImage then
  begin
    if (Open < 2) or (AText[Open - 1] <> '!') then
      Exit;
  end
  else if (Open >= 2) and (AText[Open - 1] = '!') then
    Exit;

  CloseB := Open + 1;
  while (CloseB <= LE) and (AText[CloseB] <> ']') do
    Inc(CloseB);
  if CloseB > LE then
    Exit;
  if (CloseB + 1 > LE) or (AText[CloseB + 1] <> '(') then
    Exit;
  OpenP := CloseB + 1;
  CloseP := OpenP + 1;
  while (CloseP <= LE) and (AText[CloseP] <> ')') do
    Inc(CloseP);
  if CloseP > LE then
    Exit;

  if AImage then
    AStart := Open - 2
  else
    AStart := Open - 1;
  AEnd := CloseP; // 1-based CloseP is the exclusive offset
  if (AOffset < AStart) or (AOffset > AEnd) then
    Exit;

  ATextPart := Copy(AText, Open + 1, CloseB - Open - 1);
  Inner := MdTrim(Copy(AText, OpenP + 1, CloseP - OpenP - 1));
  if (Inner <> '') and (Inner[1] = '<') then
  begin
    q := Pos('>', Inner);
    if q > 0 then
    begin
      Tgt := Copy(Inner, 2, q - 2);
      Ttl := MdTrim(Copy(Inner, q + 1, MaxInt));
    end
    else
    begin
      Tgt := Inner;
      Ttl := '';
    end;
  end
  else
  begin
    q := 1;
    while (q <= Length(Inner)) and (Inner[q] > ' ') do
      Inc(q);
    Tgt := Copy(Inner, 1, q - 1);
    Ttl := MdTrim(Copy(Inner, q, MaxInt));
  end;
  if (Length(Ttl) >= 2)
    and ((Ttl[1] = '"') or (Ttl[1] = ''''))
    and (Ttl[Length(Ttl)] = Ttl[1]) then
    Ttl := Copy(Ttl, 2, Length(Ttl) - 2);
  ATarget := Tgt;
  ATitle := Ttl;
  Result := True;
end;

function MdParseInt(const S: UnicodeString; ADefault: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  if S = '' then
  begin
    Result := ADefault;
    Exit;
  end;
  for i := 1 to Length(S) do
  begin
    if not (S[i] in ['0'..'9']) then
    begin
      Result := ADefault;
      Exit;
    end;
    Result := Result * 10 + (Ord(S[i]) - Ord('0'));
  end;
end;

function MdContinuation(const ALine: UnicodeString; ACaretX: Integer;
  AInFence: Boolean): TMdContinuation;
var
  p, q, r, Num: Integer;
begin
  Result.Kind := mdNone;
  Result.Prefix := '';
  if AInFence then
    Exit;
  if ACaretX <> Length(ALine) then
    Exit; // only at the end of the line; splitting mid-line is the editor's job
  if MdTrim(ALine) = '' then
    Exit;

  p := MdIndentLen(ALine) + 1;

  // Block quote: continue with the same markers, exit when the item is empty.
  if (p <= Length(ALine)) and (ALine[p] = '>') then
  begin
    q := p;
    while (q <= Length(ALine)) and (ALine[q] = '>') do
    begin
      Inc(q);
      if (q <= Length(ALine)) and (ALine[q] = ' ') then
        Inc(q);
    end;
    Result.Prefix := Copy(ALine, p, q - p);
    if MdTrim(Copy(ALine, q, MaxInt)) = '' then
      Result.Kind := mdExitList
    else
      Result.Kind := mdContinue;
    Exit;
  end;

  // Bullet list, with or without a task box.
  if (p < Length(ALine)) and (ALine[p] in ['-', '*', '+'])
    and (ALine[p + 1] = ' ') then
  begin
    q := p + 1;
    while (q <= Length(ALine)) and (ALine[q] = ' ') do
      Inc(q);
    if (q + 2 <= Length(ALine)) and (ALine[q] = '[') and (ALine[q + 2] = ']')
      and ((ALine[q + 1] = ' ') or (ALine[q + 1] = 'x') or (ALine[q + 1] = 'X')) then
    begin
      Result.Prefix := MdU(ALine[p]) + ' ' + '[ ] ';
      r := q + 3;
      while (r <= Length(ALine)) and (ALine[r] = ' ') do
        Inc(r);
    end
    else
    begin
      Result.Prefix := MdU(ALine[p]) + ' ';
      r := q;
    end;
    if r > Length(ALine) then
      Result.Kind := mdExitList
    else
      Result.Kind := mdContinue;
    Exit;
  end;

  // Ordered list: continue with the next number.
  if (p < Length(ALine)) and (ALine[p] in ['0'..'9']) then
  begin
    q := p;
    while (q <= Length(ALine)) and (ALine[q] in ['0'..'9']) do
      Inc(q);
    if (q <= Length(ALine)) and (ALine[q] in ['.', ')'])
      and (q < Length(ALine)) and (ALine[q + 1] = ' ') then
    begin
      Num := MdParseInt(Copy(ALine, p, q - p), 0);
      Result.Prefix := MdIntToStr(Num + 1) + MdU(ALine[q]) + ' ';
      r := q + 1;
      while (r <= Length(ALine)) and (ALine[r] = ' ') do
        Inc(r);
      if r > Length(ALine) then
        Result.Kind := mdExitList
      else
        Result.Kind := mdContinue;
    end;
  end;
end;

function MdWordBeforeCaret(const AText: UnicodeString; AOffset: Integer;
  out AStart: Integer): UnicodeString;
var
  p: Integer;
begin
  AOffset := MdClampOffset(AText, AOffset);
  p := AOffset;
  while (p > 0) and MdIsWordChar(AText[p]) do
    Dec(p);
  AStart := p;
  Result := Copy(AText, p + 1, AOffset - p);
end;

// Case-insensitive compare that does not need a widestring manager (the unit
// is also compiled by the headless test program, which links no such thing).
function MdCompareTextI(const A, B: UnicodeString): Integer;
var
  i, n: Integer;
  ca, cb: WideChar;
begin
  n := Length(A);
  if Length(B) < n then
    n := Length(B);
  for i := 1 to n do
  begin
    ca := A[i];
    cb := B[i];
    if ca <> cb then
    begin
      ca := UpCase(ca);
      cb := UpCase(cb);
      if ca <> cb then
      begin
        if ca < cb then
          Exit(-1)
        else
          Exit(1);
      end;
    end;
  end;
  Result := Length(A) - Length(B);
end;

function MdEqualText(const A, B: UnicodeString): Boolean;
begin
  Result := MdCompareTextI(A, B) = 0;
end;

function MdStartsWithText(const AText, APrefix: UnicodeString): Boolean;
begin
  Result := (Length(APrefix) <= Length(AText))
    and (MdCompareTextI(Copy(AText, 1, Length(APrefix)), APrefix) = 0);
end;

function MdWordIsNumber(const AWord: UnicodeString): Boolean;
var
  i: Integer;
begin
  Result := AWord <> '';
  for i := 1 to Length(AWord) do
    if not (AWord[i] in ['0'..'9']) then
      Exit(False);
end;

function MdCollectWords(const AText: UnicodeString; AMinLen: Integer): TMdStringArray;
var
  i, j, k, Start, N: Integer;
  Word, Tmp: UnicodeString;
begin
  Result := nil;
  N := 0;
  Start := 0;
  i := 1;
  while i <= Length(AText) + 1 do
  begin
    if (i <= Length(AText)) and MdIsWordChar(AText[i]) then
    begin
      if Start = 0 then
        Start := i;
    end
    else if Start > 0 then
    begin
      Word := Copy(AText, Start, i - Start);
      if (Length(Word) >= AMinLen) and not MdWordIsNumber(Word) then
      begin
        SetLength(Result, N + 1);
        Result[N] := Word;
        Inc(N);
      end;
      Start := 0;
    end;
    Inc(i);
  end;

  // Insertion sort, case-insensitive; then drop the duplicate spellings.
  for i := 1 to N - 1 do
  begin
    Tmp := Result[i];
    j := i - 1;
    while (j >= 0) and (MdCompareTextI(Result[j], Tmp) > 0) do
    begin
      Result[j + 1] := Result[j];
      Dec(j);
    end;
    Result[j + 1] := Tmp;
  end;
  k := 0;
  for i := 0 to N - 1 do
    if (k = 0) or (MdCompareTextI(Result[k - 1], Result[i]) <> 0) then
    begin
      Result[k] := Result[i];
      Inc(k);
    end;
  SetLength(Result, k);
end;

end.
