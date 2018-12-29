program Project1;

uses
  Vcl.Forms,
  UMainForm in 'UMainForm.pas',
  UObjects in 'UObjects.pas',
  UCreateMainForm in 'UCreateMainForm.pas',
  ULessOffset in 'PowerFlywheel\ULessOffset.pas',
  ULargerOffset in 'PowerFlywheel\ULargerOffset.pas',
  UPowerFlywheel in 'PowerFlywheel\UPowerFlywheel.pas',
  UFrameSaws in 'FrameSaws\UFrameSaws.pas' {,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res},
  Vcl.Themes,
  Vcl.Styles,
  UConstants in 'UConstants.pas';

{$R *.res}

 begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
