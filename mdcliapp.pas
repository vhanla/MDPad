unit mdcliapp;

{$mode objfpc}{$H+}{$J-}

// Parses the command line in this unit's initialization section, i.e. before
// the LCL widgetset units initialize. That is what makes --help and --version
// work on a machine with no display (a build box, a release script) and keeps
// a bad option from opening a window at all.
//
// The program lists this unit *before* Interfaces for that reason; mdcli.pas
// itself stays free of LCL, so a headless test can use it directly.

interface

implementation

uses
  SysUtils, mdcli, mdversioninfo;

var
  CliError: string;

initialization
  case MdCliParse(CliError) of
    caHelp:
      begin
        WriteLn(MdCliUsage);
        Flush(Output);
        Halt(0);
      end;
    caVersion:
      begin
        WriteLn('MDPad ', MdVersion);
        Flush(Output);
        Halt(0);
      end;
    caError:
      begin
        WriteLn(StdErr, 'mdpad: ', CliError);
        WriteLn(StdErr, 'Try "mdpad --help".');
        Flush(Output);
        Flush(StdErr);
        Halt(2);
      end;
    caRun: ;
  end;

end.
