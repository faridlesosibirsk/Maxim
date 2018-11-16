program Project1;

uses
  Vcl.Forms,
  UMainForm in 'UMainForm.pas' {Form1},
  UPowerFlywheel in 'UPowerFlywheel.pas',
  UInterface in 'UInterface.pas',
  UCreateMainForm in 'UCreateMainForm.pas';

{$R *.res}

 begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
