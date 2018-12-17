unit ULessOffset;

interface

uses Forms, Math, UPowerFlywheel, UMainForm, UCreateMainForm;

type

  TLessOffset = class (TPowerFlywheel)
  public
    constructor create(AOwner: TForm);
  end;

implementation

{ TLessOffset }

constructor TLessOffset.create(AOwner: TForm);
var i:integer;
begin
  try
  for i:=1 to 9 do begin
    XC[i]:=R*(1-COS(AL[i])-R*SIN(AL[i])*SIN(AL[i])/(2*L));
    XC[i]:=XC[i]*100;
    XC[i]:=INT(XC[i]);
    XC[i]:=XC[i]/100;
    VC[i]:=VB*(SIN(AL[i])-SIN(2*AL[i])*R/(2*L));
    VC[i]:=FLOOR(VC[i]*100)/100;
    VCB[i]:=VB*COS(AL[i])/(1-SIN(AL[i])*SIN(AL[i])*Power(R,2)/(2*Power(L,2)));
    V:=VCB[i]*100;
    V:=FLOOR(V);
    VCB[i]:=V/100;
    if i>=N then begin
      MF[i]:=FR*30*VC[i]/(3.14*N1);
      MF[i]:=ABS(FLOOR(MF[i]*100)/100);
    end;
  end;
  err:=0;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    err:=1;
  end;
end;

end.