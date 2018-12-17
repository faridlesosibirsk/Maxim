program Project1;

uses
  Vcl.Forms,
  UParametrsObjects in 'UParametrsObjects.pas',
  UCreateObjects in 'UCreateObjects.pas',
  UMainForm in 'UMainForm.pas',
  UInterface in 'UInterface.pas',
  UCreateMainForm in 'UCreateMainForm.pas',
  ULessOffset in 'PowerFlywheel\ULessOffset.pas',
  ULargerOffset in 'PowerFlywheel\ULargerOffset.pas',
  UPowerFlywheel in 'PowerFlywheel\UPowerFlywheel.pas',
  UFrameSaws in 'FrameSaws\UFrameSaws.pas';

{$R *.res}

 begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
