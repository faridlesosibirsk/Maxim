unit UCreateMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs, IniFiles,
  Generics.Collections, UInterface,UPowerFlywheel,UFrameSaws;

type

  TNilCreate = class(TInterfacedObject, TInterfaceMenuCreate)
  private
    PowerFlywheelButton, FrameSawsButton: TButton;
    fFileCreate: TInterfaceMenuCreate;
  public
    procedure PowerFlywheelButtonClick(Sender: TObject);
    procedure FrameSawsButtonClick(Sender: TObject);
    constructor create(AOwner: TForm);
    procedure destroy;
  end;

implementation

{ TNilCreate }

uses UMainForm;

constructor TNilCreate.create(AOwner: TForm);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  PowerFlywheelButton:=TButton.create(AOwner);
  FrameSawsButton:=TButton.create(AOwner);
  try
    Form1.Height := Ini.ReadInteger('Form', 'Height', 100);
    Form1.Width := Ini.ReadInteger('Form', 'Width', 100);
    Form1.caption := Ini.ReadString('Form', 'Caption', 'Form 1');

    PowerFlywheelButton.Left:=Ini.ReadInteger('PowerFlywheelButton', 'Left', 100);
    PowerFlywheelButton.Top:=Ini.ReadInteger('PowerFlywheelButton', 'Top', 100);
    PowerFlywheelButton.Height:=Ini.ReadInteger('PowerFlywheelButton', 'Height', 100);
    PowerFlywheelButton.Width:=Ini.ReadInteger('PowerFlywheelButton', 'Width', 100);
    PowerFlywheelButton.Caption:=Ini.ReadString('PowerFlywheelButton', 'Caption', 'Form 1');
    PowerFlyWheelButton.Font.Name:='Times New Roman';
    PowerFlyWheelButton.Font.Size:=12;

    FrameSawsButton.Left:=Ini.ReadInteger('FrameSawsButton', 'Left', 100);
    FrameSawsButton.Top:=Ini.ReadInteger('FrameSawsButton', 'Top', 100);
    FrameSawsButton.Height:=Ini.ReadInteger('FrameSawsButton', 'Height', 100);
    FrameSawsButton.Width:=Ini.ReadInteger('FrameSawsButton', 'Width', 100);
    FrameSawsButton.Caption:=Ini.ReadString('FrameSawsButton', 'Caption', 'Form 1');
    FrameSawsButton.Font.Name:='Times New Roman';
    FrameSawsButton.Font.Size:=12;
  finally
    Ini.Free;
  end;
  PowerFlywheelButton.Parent:=AOwner;
  PowerFlywheelButton.OnClick:=PowerFlywheelButtonClick;

  FrameSawsButton.Parent:=AOwner;
  FrameSawsButton.OnClick:=FrameSawsButtonClick;
end;

procedure TNilCreate.destroy;
begin
    PowerFlywheelButton.Free;
    FrameSawsButton.Free;
end;



procedure TNilCreate.PowerFlywheelButtonClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  fFileCreate:=TPowerFlywheel.create(Form1);
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Form1.Height:=Ini.ReadInteger('FormPowerFlywheel', 'Height', 100);
    Form1.Width:=Ini.ReadInteger('FormPowerFlywheel', 'Width', 100);
    Form1.caption:=Ini.ReadString('FormPowerFlywheel', 'Caption', 'Form 1');
  finally
    Ini.Free;
  end;
  destroy;
end;


procedure TNilCreate.FrameSawsButtonClick(Sender: TObject);
var
  Ini: TIniFile;
begin
  fFileCreate:=TFrameSaws.create(Form1);
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    Form1.Height:=Ini.ReadInteger('FormFrameSaws', 'Height', 100);
    Form1.Width:=Ini.ReadInteger('FormFrameSaws', 'Width', 100);
    Form1.caption:=Ini.ReadString('FormFrameSaws', 'Caption', 'Form 1');
  finally
    Ini.Free;
  end;
  destroy;
end;

end.
