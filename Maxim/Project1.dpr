program Project1;

uses
  Vcl.Forms,
  UMainForm in 'UMainForm.pas' {Form1},
  UInterface in 'UInterface.pas',
  UCreateMainForm in 'UCreateMainForm.pas',
  UPowerFlywheel in 'PowerFlywheel\UPowerFlywheel.pas',
  ULessOffset in 'PowerFlywheel\ULessOffset.pas',
  ULargerOffset in 'PowerFlywheel\ULargerOffset.pas',
  UFrameSaws in 'FrameSaws\UFrameSaws.pas',
  UCreateObjects in 'PowerFlywheel\UCreateObjects.pas',
  UParametrsObjects in 'PowerFlywheel\UParametrsObjects.pas';

{$R *.res}

 begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
