program MarkDownPad;

{$mode objfpc}{$H+}{$J-}

uses
  {$IFDEF UNIX}
  cthreads, // Ahora sí se incluirá siempre que compiles en Linux/Unix
  {$ENDIF}
  // Before Interfaces on purpose: its initialization section parses the
  // command line, so --help/--version work with no display and a bad option
  // never opens a window (see mdcliapp.pas).
  mdcliapp,
  Interfaces, // Interfaces debe ser la primera unidad LCL
  Forms,
  SysUtils,
  LazUTF8,
  markdownviewer_src in 'markdownviewer_src.pas' {Form1};

{$IFDEF MSWINDOWS}
{$R *.res}
{$ENDIF}

begin
  {$if declared(UseHeapTrace)}
  //http://wiki.freepascal.org/heaptrc
  SetHeapTraceOutput(ExtractFilePath(ParamStrUTF8(0))+ 'trace.log');
  {$endif}

  RequireDerivedFormResource:=True;
  Application.Initialize;
  {$ifdef windows}
  Application.MainFormOnTaskbar := True;
  {$endif}
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
