unit ULargerOffset;

interface

uses Forms, Math, UPowerFlywheel, UMainForm;

type
  TLargerOffset = class(TPowerFlywheel)
  public
    constructor create(AOwner: TForm);
  end;

implementation

{ TLargerOffset }

constructor TLargerOffset.create(AOwner: TForm);
var i:integer;
begin
  try
  G10:=K/(L-R);
  G1:=K/(L+R);
  X0:=2*ARCTAN((1-(Power((1-G10*G10),0.5)))/G10);
  X1:=2*ARCTAN((1-(Power((1-G1*G1),0.5)))/G1);
  AL[1]:=-X0;
  for i:=2 to 9 do AL[i]:=AL[i-1]-3.14/4;
  AL[5]:=-3.14-X1;
  AL[9]:=-X0;
  for i:=1 to 9 do begin
    XC[i]:=Power(Power(L,2)- Power((K-R*SIN(AL[i])),2),0.5)-R*COS(AL[i])-(L-R)*G10;
    XC[i]:=FLOOR(XC[i]*100)/100;
    VC[i]:=VB*(SIN(AL[i])+(K-R*SIN(AL[i]))*COS(AL[i])/(Power((Power(L,2)-Power((K-R*SIN(AL[i])),2)),0.5)));
    VC[i]:=FLOOR(VC[i]*100)/100;
    VCB[i]:=VB*COS(AL[i])/(Power(1-Power((K-R*SIN(AL[i])),2)/Power(L,2),0.5));
    VCB[i]:=FLOOR(VCB[i]*100)/100;
    if i>=N then begin
      MF[i]:=30*FR*VC[i]/(3.14*N1);
      MF[i]:=FLOOR(MF[i]*100)/100;
    end;
  end;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    err:=1;
  end;
end;

end.
