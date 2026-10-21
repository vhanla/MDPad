unit mdupdate;

{$mode objfpc}{$H+}{$J-}

// The update check: ask GitHub for the latest published release of MDPad and
// decide whether it is newer than the running build.
//
// Deliberately free of LCL and of the form unit, like mdcli.pas: the parsing
// and the comparison can be exercised by a headless test program, and the form
// only owns the thread and the settings.
//
// The HTTP side is the system's TLS stack where there is one: WinInet on
// Windows (no DLLs to ship) and FPC's fphttpclient + OpenSSL elsewhere. The
// OpenSSL unit loads libssl lazily, when a request is made, so a machine
// without it still starts and runs; the check just fails, silently.

interface

uses
  SysUtils, Classes, mdversioninfo;

type
  // The outcome of one check. Checked means the request and the JSON came back
  // (even if the release turned out not to be newer); Error says why not.
  // Available is only set when both versions parse and the remote one is newer.
  TMdUpdateResult = record
    Checked: Boolean;
    Available: Boolean;
    Version: string; // normalized remote version, e.g. '1.4.0'
    URL: string;     // release page (https only)
    Error: string;   // '' when Checked
  end;

  // Runs MdCheckForUpdates on its own thread. It never touches the UI and never
  // synchronizes: the owner polls Finished and then reads UpdateResult, which
  // is what keeps a closing program from waiting on a callback into a freed
  // form (see tmrUpdateCheckTimer in the main unit).
  TMdUpdateCheckThread = class(TThread)
  private
    FCurrentVersion: string;
    FUpdateResult: TMdUpdateResult;
  protected
    procedure Execute; override;
  public
    constructor Create(const ACurrentVersion: string);
    property UpdateResult: TMdUpdateResult read FUpdateResult;
  end;

// Blocking check. Called by the thread, and by the headless test.
function MdCheckForUpdates(const ACurrentVersion: string): TMdUpdateResult;

// Parses a GitHub "releases/latest" body. Public so the test can feed it saved
// responses without the network. AURL falls back to the releases page when the
// API does not give an https one.
function MdParseLatestRelease(const ABody: RawByteString;
  out AVersion, AURL: string): Boolean;

// Parses the "releases" list (an array, newest first) and picks the newest
// non-draft entry. Used when "latest" answers 404: GitHub only answers that
// endpoint when a stable release exists, and a project whose releases are all
// prereleases still has a newest one.
function MdParseLatestReleaseList(const ABody: RawByteString;
  out AVersion, AURL: string): Boolean;

// A short User-Agent GitHub accepts ('MDPad/<version> (+https://github.com/...)').
function MdUpdateUserAgent: string;

implementation

uses
  {$IFDEF MSWINDOWS}
  Windows, wininet,
  {$ELSE}
  fphttpclient, opensslsockets,
  {$ENDIF}
  fpjson, jsonparser;

function MdUpdateUserAgent: string;
begin
  Result := 'MDPad/' + MdVersion + ' (+' + MdProjectURL + ')';
end;

{$IFDEF MSWINDOWS}
// WinInet is part of Windows and uses the system's TLS/certificate store, so a
// Windows build needs no OpenSSL DLLs next to it.
function MdHttpGet(const AURL, AUserAgent, AAccept: string;
  out AStatus: Integer; out AError: string): RawByteString;
var
  hNet, hURL: HINTERNET;
  Headers: string;
  Buf: array[0..8191] of Byte;
  ReadCount: DWORD;
  Code, CodeLen, Index: DWORD;
  Stream: TMemoryStream;
begin
  Result := '';
  AError := '';
  AStatus := 0;
  Headers := 'User-Agent: ' + AUserAgent + #13#10
    + 'Accept: ' + AAccept + #13#10;

  hNet := InternetOpenA(PAnsiChar(AnsiString(AUserAgent)),
    INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hNet = nil then
  begin
    AError := 'WinInet could not start';
    Exit;
  end;
  try
    hURL := InternetOpenUrlA(hNet, PAnsiChar(AnsiString(AURL)),
      PAnsiChar(AnsiString(Headers)), Length(Headers),
      INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_UI, 0);
    if hURL = nil then
    begin
      AError := 'the release page could not be reached';
      Exit;
    end;
    try
      Code := 0;
      CodeLen := SizeOf(Code);
      Index := 0;
      if HttpQueryInfoA(hURL,
        HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER, @Code, CodeLen, Index) then
      begin
        AStatus := Code;
        if (Code < 200) or (Code >= 300) then
        begin
          AError := 'HTTP ' + IntToStr(Code);
          Exit;
        end;
      end;

      Stream := TMemoryStream.Create;
      try
        repeat
          if not InternetReadFile(hURL, @Buf[0], SizeOf(Buf), @ReadCount) then
          begin
            AError := 'the connection was interrupted';
            Break;
          end;
          if ReadCount = 0 then
            Break;
          Stream.WriteBuffer(Buf[0], ReadCount);
        until False;
        if AError <> '' then
          Exit;
        SetLength(Result, Stream.Size);
        if Stream.Size > 0 then
        begin
          Stream.Position := 0;
          Stream.ReadBuffer(Result[1], Stream.Size);
        end;
      finally
        Stream.Free;
      end;
    finally
      InternetCloseHandle(hURL);
    end;
  finally
    InternetCloseHandle(hNet);
  end;
end;
{$ELSE}
function MdHttpGet(const AURL, AUserAgent, AAccept: string;
  out AStatus: Integer; out AError: string): RawByteString;
var
  Client: TFPHTTPClient;
begin
  Result := '';
  AError := '';
  AStatus := 0;
  Client := TFPHTTPClient.Create(nil);
  try
    Client.AllowRedirect := True;
    Client.ConnectTimeout := 5000;
    Client.IOTimeout := 8000;
    Client.AddHeader('User-Agent', AUserAgent);
    Client.AddHeader('Accept', AAccept);
    try
      Result := Client.Get(AURL);
      AStatus := Client.ResponseStatusCode;
      if (AStatus < 200) or (AStatus >= 300) then
        AError := 'HTTP ' + IntToStr(AStatus);
    except
      on E: Exception do
      begin
        // ResponseStatusCode is set before fphttpclient raises on an
        // unexpected code, so a 404 (no stable release) stays recognizable.
        AStatus := Client.ResponseStatusCode;
        AError := E.Message;
      end;
    end;
  finally
    Client.Free;
  end;
end;
{$ENDIF}

// The shared part of both parsers: read tag_name/html_url out of one release
// object. False when the object has no version this build can read.
function MdReadReleaseObject(AObj: TJSONObject;
  out AVersion, AURL: string): Boolean;
var
  Tag, HtmlUrl: string;
  V: TMdSemVer;
begin
  Result := False;
  AVersion := '';
  AURL := '';
  Tag := AObj.Get('tag_name', '');
  if not MdVersionParse(Tag, V) then
    Exit;
  HtmlUrl := AObj.Get('html_url', '');
  // The API answers https://github.com/...; a body from anywhere else (or a
  // proxy) must not be able to send the browser to another scheme.
  if Copy(HtmlUrl, 1, 8) <> 'https://' then
    HtmlUrl := MdReleasesURL;
  AVersion := MdVersionNormalize(Tag);
  AURL := HtmlUrl;
  Result := True;
end;

function MdParseLatestRelease(const ABody: RawByteString;
  out AVersion, AURL: string): Boolean;
var
  Data: TJSONData;
  Text: UTF8String;
begin
  Result := False;
  AVersion := '';
  AURL := '';
  Text := ABody;
  try
    Data := GetJSON(Text);
  except
    Exit;
  end;
  try
    if Data is TJSONObject then
      Result := MdReadReleaseObject(TJSONObject(Data), AVersion, AURL);
  finally
    Data.Free;
  end;
end;

function MdParseLatestReleaseList(const ABody: RawByteString;
  out AVersion, AURL: string): Boolean;
var
  Data: TJSONData;
  Item: TJSONData;
  Obj: TJSONObject;
  Text: UTF8String;
  V, Best: string;
  U, BestURL: string;
  I: Integer;
begin
  Result := False;
  AVersion := '';
  AURL := '';
  V := '';
  U := '';
  Best := '';
  BestURL := '';
  Text := ABody;
  try
    Data := GetJSON(Text);
  except
    Exit;
  end;
  try
    if not (Data is TJSONArray) then
      Exit;
    // Newest first, but do not rely on the order: keep the greatest version.
    for I := 0 to TJSONArray(Data).Count - 1 do
    begin
      Item := TJSONArray(Data).Items[I];
      if not (Item is TJSONObject) then
        Continue;
      Obj := TJSONObject(Item);
      if Obj.Get('draft', False) then
        Continue;
      if not MdReadReleaseObject(Obj, V, U) then
        Continue;
      if (Best = '') or MdVersionIsNewer(V, Best) then
      begin
        Best := V;
        BestURL := U;
      end;
    end;
    if Best = '' then
      Exit;
    AVersion := Best;
    AURL := BestURL;
    Result := True;
  finally
    Data.Free;
  end;
end;

function MdCheckForUpdates(const ACurrentVersion: string): TMdUpdateResult;
var
  Body: RawByteString;
  Error, RemoteVersion, RemoteURL: string;
  Status: Integer;
  FromList: Boolean;
begin
  Result.Checked := False;
  Result.Available := False;
  Result.Version := '';
  Result.URL := '';
  Result.Error := '';

  Body := MdHttpGet(MdLatestReleaseAPI, MdUpdateUserAgent,
    'application/vnd.github+json', Status, Error);
  FromList := False;
  if (Error <> '') and (Status = 404) then
  begin
    // No stable release yet: "latest" answers 404 whenever every published
    // release is a draft or a prerelease. The list still names the newest one,
    // which is what a beta user should be offered.
    Body := MdHttpGet(MdReleasesAPI, MdUpdateUserAgent,
      'application/vnd.github+json', Status, Error);
    FromList := True;
  end;
  if Error <> '' then
  begin
    Result.Error := Error;
    Exit;
  end;

  Result.Checked := True;
  if FromList then
  begin
    if not MdParseLatestReleaseList(Body, RemoteVersion, RemoteURL) then
    begin
      Result.Error := 'no published release was found';
      Exit;
    end;
  end
  else if not MdParseLatestRelease(Body, RemoteVersion, RemoteURL) then
  begin
    Result.Error := 'the release information could not be read';
    Exit;
  end;

  Result.Version := RemoteVersion;
  Result.URL := RemoteURL;
  Result.Available := MdVersionIsNewer(RemoteVersion, ACurrentVersion);
end;

constructor TMdUpdateCheckThread.Create(const ACurrentVersion: string);
begin
  inherited Create(True);
  // The owner (the form) keeps the object and frees it once Finished, so a
  // shutdown can wait for the socket without racing a self-free.
  FreeOnTerminate := False;
  FCurrentVersion := ACurrentVersion;
  FUpdateResult.Checked := False;
  FUpdateResult.Available := False;
  FUpdateResult.Version := '';
  FUpdateResult.URL := '';
  FUpdateResult.Error := '';
  Start;
end;

procedure TMdUpdateCheckThread.Execute;
begin
  try
    FUpdateResult := MdCheckForUpdates(FCurrentVersion);
  except
    on E: Exception do
    begin
      FUpdateResult.Checked := False;
      FUpdateResult.Available := False;
      FUpdateResult.Version := '';
      FUpdateResult.URL := '';
      FUpdateResult.Error := E.Message;
    end;
  end;
end;

end.
