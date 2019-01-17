unit UConstants;

interface

type
  TConstants = class
  public
    function GetDirectory():string;
  end;

var
  Constant:TConstants;
const
  FontName='Times New Roman';
  FontSize12=12;
  FontSize14=14;

  PF = '\IniFiles\PowerFlywheel\';
  FS = '\IniFiles\FrameSaws\';
  BR = '\IniFiles\Bearings\';

  LabelsINI = 'Labels.INI';
  EditINI = 'Edit.INI';
  ButtonINI = 'Button.INI';
  StringGridINI = 'StringGrid.INI';
  LabeledEditINI = 'LabeledEdit.INI';
  RadioGroupINI = 'RadioGroup.INI';

implementation

{ TConstants }

function TConstants.GetDirectory: string; //путь к программе
var sPath:string;
begin
  GetDir(0,sPath);
  result:=sPath;
end;

end.
