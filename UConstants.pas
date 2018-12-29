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
  TNR='Times New Roman';
  TNR12=12;
  TNR14=14;

  IniPath ='\IniFiles\';



  PFLabels = 'PowerFlywheel\PowerFlywheelLabels.INI';

implementation

{ TConstants }

function TConstants.GetDirectory: string;
var sPath:string;
begin
  GetDir(0,sPath);
  result:=sPath;
end;

end.
