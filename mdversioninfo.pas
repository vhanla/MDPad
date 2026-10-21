unit mdversioninfo;

{$mode objfpc}{$H+}{$J-}

// The application's version, in one place:
//   - the About dialog and about the project links,
//   - the command line prints it (mdcliapp.pas, before the widgetset starts),
//   - the update checker compares it with the latest GitHub release.
//
// tools/build-release.sh reads MdVersion out of this file and refuses to build
// when it disagrees with the VERSION file, which is what the packages are named
// after; bump the two together.
//
// The comparison is semantic, not lexical: 1.10.0 is newer than 1.9.9 (a plain
// string compare says the opposite), a release is newer than its own
// prereleases (1.4.0 > 1.4.0-rc.1), and build metadata (+...) is ignored.
//
// A fourth numeric component is accepted on purpose (1.3.7.1 sorts after
// 1.3.7): this project has tagged releases that way, and the update check must
// be able to read its own release list. Strict semver has three components;
// everything above four is rejected.

interface

uses
  SysUtils;

const
  MdVersion = '1.4.0';
  MdProjectURL = 'https://github.com/vhanla/MDPad';
  MdReleasesURL = 'https://github.com/vhanla/MDPad/releases';
  // GitHub's public API. "latest" excludes drafts and prereleases, so a stable
  // build is never pointed at a beta (and a beta build simply sees the newest
  // stable, which its own prerelease compares below). The full list is the
  // fallback for a project that has no stable release yet: "latest" answers 404
  // in that case, while the list still names the newest published release.
  MdLatestReleaseAPI = 'https://api.github.com/repos/vhanla/MDPad/releases/latest';
  MdReleasesAPI = 'https://api.github.com/repos/vhanla/MDPad/releases';

type
  // A parsed semantic version. PreRelease is '' for a release, otherwise the
  // dot-separated identifiers after the first '-' ('beta', 'rc.1', ...).
  // Revision is the optional fourth number, 0 when the tag has three.
  TMdSemVer = record
    Major, Minor, Patch, Revision: Integer;
    HasRevision: Boolean;
    PreRelease: string;
  end;

// Parses '1.2.3', 'v1.2.3', '1.2', '1.2.3-beta.1', '1.2.3+build' (the build
// metadata is dropped, as semver says to) or '1.3.7.1' (the optional fourth
// component; see the unit's header). False for anything that is not a version,
// so an unknown tag can never be mistaken for an update.
function MdVersionParse(const AText: string; out AVersion: TMdSemVer): Boolean;

// <0 when A is older than B, 0 when they are the same version, >0 when A is
// newer. Text that does not parse compares as equal (the callers treat that as
// "cannot tell", never as an update).
function MdVersionCompare(const A, B: string): Integer;

// True only when both sides parse and ACandidate really is newer. This is the
// one question the update check asks.
function MdVersionIsNewer(const ACandidate, ACurrent: string): Boolean;

// Canonical form: no leading 'v', no build metadata, the patch filled in
// ('v1.4' -> '1.4.0'). '' when the text is not a version.
function MdVersionNormalize(const AText: string): string;

// True when the version carries a prerelease part ('1.4.0-beta').
function MdVersionHasPrerelease(const AText: string): Boolean;

implementation

function CompareSemVer(const A, B: TMdSemVer): Integer; forward;

// A prerelease is a series of dot-separated identifiers. Numeric identifiers
// compare as numbers (and sort before alphanumeric ones), the rest compare as
// text; a shorter series that is a prefix of the other sorts first.
function CompareNumericIdentifiers(const A, B: string): Integer;
var
  TA, TB: string;
begin
  TA := A;
  while (Length(TA) > 1) and (TA[1] = '0') do
    Delete(TA, 1, 1);
  TB := B;
  while (Length(TB) > 1) and (TB[1] = '0') do
    Delete(TB, 1, 1);
  if Length(TA) <> Length(TB) then
    Exit(Length(TA) - Length(TB));
  Result := CompareStr(TA, TB);
end;

function IsNumericIdentifier(const AText: string): Boolean;
var
  I: Integer;
begin
  Result := AText <> '';
  for I := 1 to Length(AText) do
    if not (AText[I] in ['0'..'9']) then
      Exit(False);
end;

function NextIdentifier(var AText: string): string;
var
  P: Integer;
begin
  P := Pos('.', AText);
  if P = 0 then
  begin
    Result := AText;
    AText := '';
  end
  else
  begin
    Result := Copy(AText, 1, P - 1);
    AText := Copy(AText, P + 1, MaxInt);
  end;
end;

function ComparePrerelease(const A, B: string): Integer;
var
  SA, SB, IA, IB: string;
  NA, NB: Boolean;
begin
  // No prerelease means a release, which is newer than any prerelease of the
  // same core version.
  if A = B then
    Exit(0);
  if A = '' then
    Exit(1);
  if B = '' then
    Exit(-1);

  SA := A;
  SB := B;
  repeat
    if (SA = '') and (SB = '') then
      Exit(0);
    if SA = '' then
      Exit(-1);
    if SB = '' then
      Exit(1);
    IA := NextIdentifier(SA);
    IB := NextIdentifier(SB);
    NA := IsNumericIdentifier(IA);
    NB := IsNumericIdentifier(IB);
    if NA and NB then
      Result := CompareNumericIdentifiers(IA, IB)
    else if NA then
      Result := -1 // numeric identifiers have lower precedence
    else if NB then
      Result := 1
    else
      Result := CompareStr(IA, IB);
    if Result <> 0 then
      Exit;
  until False;
end;

function CompareSemVer(const A, B: TMdSemVer): Integer;
begin
  if A.Major <> B.Major then
    Exit(A.Major - B.Major);
  if A.Minor <> B.Minor then
    Exit(A.Minor - B.Minor);
  if A.Patch <> B.Patch then
    Exit(A.Patch - B.Patch);
  if A.Revision <> B.Revision then
    Exit(A.Revision - B.Revision);
  Result := ComparePrerelease(A.PreRelease, B.PreRelease);
end;

function MdVersionParse(const AText: string; out AVersion: TMdSemVer): Boolean;
var
  S, Part, Pre: string;
  P, I, Value, PartCount: Integer;
begin
  Result := False;
  AVersion.Major := 0;
  AVersion.Minor := 0;
  AVersion.Patch := 0;
  AVersion.Revision := 0;
  AVersion.HasRevision := False;
  AVersion.PreRelease := '';

  S := Trim(AText);
  if (S <> '') and (S[1] in ['v', 'V']) then
    Delete(S, 1, 1);

  // Build metadata is irrelevant for precedence: 1.2.3+a and 1.2.3+b are the
  // same version.
  P := Pos('+', S);
  if P > 0 then
    S := Copy(S, 1, P - 1);

  Pre := '';
  P := Pos('-', S);
  if P > 0 then
  begin
    Pre := Copy(S, P + 1, MaxInt);
    S := Copy(S, 1, P - 1);
  end;

  // The core is one to four dot-separated numbers. A missing minor/patch is
  // treated as 0, because release tags ('v1.4') are common; the optional fourth
  // one is this project's own convention (see the unit's header).
  PartCount := 0;
  while S <> '' do
  begin
    P := Pos('.', S);
    if P = 0 then
    begin
      Part := S;
      S := '';
    end
    else
    begin
      Part := Copy(S, 1, P - 1);
      S := Copy(S, P + 1, MaxInt);
    end;
    if (Part = '') or (PartCount > 3) or (Length(Part) > 9) then
      Exit;
    for I := 1 to Length(Part) do
      if not (Part[I] in ['0'..'9']) then
        Exit;
    if not TryStrToInt(Part, Value) then
      Exit;
    case PartCount of
      0: AVersion.Major := Value;
      1: AVersion.Minor := Value;
      2: AVersion.Patch := Value;
      3:
        begin
          AVersion.Revision := Value;
          AVersion.HasRevision := True;
        end;
    end;
    Inc(PartCount);
  end;
  if PartCount = 0 then
    Exit;

  // Empty identifiers ('1.0.0-alpha..1', '1.0.0-') are not versions. The
  // identifier characters themselves are left alone: lenient parsing of tags
  // such as '-rc1' or '-dev' matters more than semver purity here.
  if Pre <> '' then
  begin
    S := Pre;
    repeat
      Part := NextIdentifier(S);
      if Part = '' then
        Exit;
    until S = '';
    AVersion.PreRelease := Pre;
  end;

  Result := True;
end;

function MdVersionCompare(const A, B: string): Integer;
var
  VA, VB: TMdSemVer;
begin
  if not (MdVersionParse(A, VA) and MdVersionParse(B, VB)) then
    Exit(0);
  Result := CompareSemVer(VA, VB);
end;

function MdVersionIsNewer(const ACandidate, ACurrent: string): Boolean;
var
  Candidate, Current: TMdSemVer;
begin
  Result := MdVersionParse(ACandidate, Candidate)
    and MdVersionParse(ACurrent, Current);
  if Result then
    Result := CompareSemVer(Candidate, Current) > 0;
end;

function MdVersionNormalize(const AText: string): string;
var
  V: TMdSemVer;
begin
  Result := '';
  if not MdVersionParse(AText, V) then
    Exit;
  Result := IntToStr(V.Major) + '.' + IntToStr(V.Minor) + '.' + IntToStr(V.Patch);
  if V.HasRevision then
    Result := Result + '.' + IntToStr(V.Revision);
  if V.PreRelease <> '' then
    Result := Result + '-' + V.PreRelease;
end;

function MdVersionHasPrerelease(const AText: string): Boolean;
var
  V: TMdSemVer;
begin
  Result := MdVersionParse(AText, V) and (V.PreRelease <> '');
end;

end.
