unit UPowerFlywheel;

interface

uses
  SysUtils, Forms, StdCtrls, Generics.Collections, Math, Vcl.Grids,
  UObjects, UConstants;

type
  TPowerFlywheel = class(TObjects)
  private
    /// <link>aggregation</link>
    Offset: TPowerFlywheel;
  public
    constructor create(AOwner: TForm);
    procedure destroy; override;
    procedure Start1ButtonClick(Sender:TObject);
    procedure Start2ButtonClick(Sender:TObject);
    procedure Start3ButtonClick(Sender: TObject);
    procedure Start4ButtonClick(Sender: TObject);
    procedure Start5ButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender:TObject);

    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  end;

var
  A,AL,VS,VC,VCB,MF,MF1,XC,DA,AK,T1,T2,W2,M:array[1..10] of real;
  Z2: string; //engine type
  Z1,         //engine power
  R,          //crank length
  L,          //connection rod length
  BS,         //distance to the center of gravity of the connection rod
  N1,         //crank turns (rotation frequency)
  FR,         //cutting force
  AS1,        //distance to crank center of gravity
  N,          //cutting force start point number
  M1,         // mass of crank unbalanced part
  M2,         //connection rod weight
  M3,         //weight of the saw frame
  J2,         //connection rod moment of inertia
  DEL,        //stroke unevenness coefficient
  K,          //the offset of the saw frame (0 possible)
  VB, V, G10, G1, X0, X1, AR, PD, K5, ND, JD, U, MDP, WD, W1, J1, T10, T11, T22, P,
  DT1, JMAX, DE, K1, MMAX, B, MB, MB1, DW, DW1, TMAX :real;
  err,
  i,iK:integer;

implementation

uses UMainForm, UCreateMainForm, ULessOffset, ULargerOffset;


constructor TPowerFlywheel.create(AOwner: TForm);
begin
  LabelsList:= TList<TLabel>.create;
  fFileCreate.LabelsCreate(AOwner,14);
  fFileCreate.LabelsParametrs(PF,'Label0_',14);


  EditList:= TList<TEdit>.create;
  fFileCreate.EditCreate(AOwner,13);
  fFileCreate.EditParametrs(PF,'Edit0_',13);

  ButtonList:= TList<TButton>.create;
  fFileCreate.ButtonsCreate(AOwner,2);
  fFileCreate.ButtonsParametrs(PF,'Button0_',2);
  ButtonList.Items[0].OnClick:=Start1ButtonClick;
  ButtonList.Items[1].OnClick:=BackButtonClick;
  ButtonList.Items[0].Enabled:=False;

  StringGridList:=TList<TStringGrid>.create;
  fFileCreate.StringGridsCreate(AOwner,2);
  fFileCreate.StringGridsParametrs(PF,'StringGrid0_',2);
end;

procedure TPowerFlywheel.destroy;
begin
    for i:=0 to LabelsList.Count-1 do LabelsList.Items[i].Free;
    for i:=0 to EditList.Count-1 do EditList.Items[i].Free;
    for i:=0 to ButtonList.Count-1 do ButtonList.Items[i].Free;
    for i:=0 to StringGridList.Count-1 do StringGridList.Items[i].Free;
end;

procedure TPowerFlywheel.Start1ButtonClick(Sender: TObject);
begin
  R:=StrToFloat(EditList.Items[0].Text);
  L:=StrToFloat(EditList.Items[1].Text);
  BS:=StrToFloat(EditList.Items[2].Text);
  N1:=StrToFloat(EditList.Items[3].Text);
  FR:=StrToFloat(EditList.Items[4].Text);
  AS1:=StrToFloat(EditList.Items[5].Text);
  N:=StrToFloat(EditList.Items[6].Text);
  M1:=StrToFloat(EditList.Items[7].Text);
  M2:=StrToFloat(EditList.Items[8].Text);
  M3:=StrToFloat(EditList.Items[9].Text);
  J2:=StrToFloat(EditList.Items[10].Text);
  DEL:=StrToFloat(EditList.Items[11].Text);
  K:=StrToFloat(EditList.Items[12].Text);
  //
  try
    AL[2]:=3.14/4;
    AL[1]:=0;
    for i:=2 to 9 do AL[i]:=AL[i-1]+AL[2];
    VB:=R*3.14*N1/30; VB:=FLOOR(VB*100)/100;
  //movements and speeds
  if K>0.01 then Offset:=TLargerOffset.create(Form1)
    else Offset:=TLessOffset.create(Form1);
  Offset.Free;
  if err=1 then exit;

  //cutting force work
  AR:=2*3.14*(MF[6]+MF[7]+MF[8])/4;
  AR:=FLOOR(AR*100)/100;
  if N=5 then AR:=0.5*AR;
  PD:=ABS(AR*N1/(0.8*60));
  K5:=K;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;

  for i:=7 to 13 do LabelsList.Items[i].Visible:=False;
  for i:=4 to 12 do EditList.Items[i].Visible:=False;

  Form1.Height:=300;
  Form1.Width:=465;

  fFileCreate.LabelsParametrs(PF,'Label1_',7);

  LabelsList.Items[0].Caption:=LabelsList.Items[0].Caption+' '+FloatToStr(FLOOR(PD))+' кВт';

  fFileCreate.EditParametrs(PF,'Edit1_',4);
  EditList.Items[3].OnKeyPress:=Edit2KeyPress;

  fFileCreate.ButtonsParametrs(PF,'Button1_',2);
  ButtonList.Items[0].OnClick:=Start2ButtonClick;
end;

procedure TPowerFlywheel.Start2ButtonClick(Sender: TObject);
begin
  ND:=StrToFloat(EditList.Items[0].Text);
  JD:=StrToFloat(EditList.Items[1].Text);
  Z1:=StrToFloat(EditList.Items[2].Text);
  Z2:=EditList.Items[3].Text;

  for i :=7 to 10 do begin
    LabelsList.Items[i].Visible:=True;
  end;

  for i :=0 to 3 do begin
    EditList.Items[i].Visible:=False;
  end;

  try
    U:=FLOOR(ND/N1*10)/10;
    MDP:=PD*0.8*30/(3.14*N1);
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;

  Form1.Height:=550;
  Form1.Width:=770;

  fFileCreate.LabelsParametrs(PF,'Label2_',11);

  LabelsList.Items[6].Caption:=LabelsList.Items[6].Caption+' '+FloatToStr(VB)+' м/с';
  LabelsList.Items[7].Caption:=LabelsList.Items[7].Caption+' '+FloatToStr(FR)+' кН';
  LabelsList.Items[8].Caption:=LabelsList.Items[8].Caption+' '+FloatToStr(ND)+' об/мин';
  LabelsList.Items[9].Caption:=LabelsList.Items[9].Caption+' '+FloatToStr(Z1)+' кВт/'+Z2;
  LabelsList.Items[10].Caption:=LabelsList.Items[10].Caption+' '+FloatToStr(U);

  fFileCreate.ButtonsParametrs(PF,'Button2_',2);
  ButtonList.Items[0].OnClick:=Start3ButtonClick;

  StringGridsCells(PF,'StringGrid0_',2);    
  StringGridList.Items[0].Visible:=True;   
  StringGridList.Items[1].Visible:=True;

  for i:=1 to 9 do begin
    StringGridList.Items[0].Cells[i,0]:=IntToStr(i);
    StringGridList.Items[0].Cells[i,1]:=FloatToStr(VCB[i]);
    StringGridList.Items[0].Cells[i,2]:=FloatToStr(VC[i]);

    StringGridList.Items[1].Cells[i,0]:=IntToStr(i);
    StringGridList.Items[1].Cells[i,1]:=FloatToStr(MF[i]);
  end;
  EditList.Items[3].OnKeyPress:=Edit1KeyPress;
end;

procedure TPowerFlywheel.Start3ButtonClick(Sender: TObject);
begin
  try
    for i:=1 to 9 do begin
      MF1[i]:=MDP-ABS(MF[i]);
      MF1[i]:=FLOOR(MF1[i]*100)/100;
    end;
    //work of external forces
    DA[1]:=0;
    AK[i]:=0;
    for i:=1 to 8 do begin
      M[i]:=(MF1[i]+MF1[i+1])/2;
      DA[i]:=M[i]*3.14/4;
      AK[i+1]:=AK[i]+DA[i];
      AK[i]:=FLOOR(AK[i]*100)/100;
    end;
    //flywheel calculation
    WD:=3.14*ND/30;
    W1:=3.14*N1/30;
    for i:=1 to 9 do begin
      VS[i]:=VB*(L-BS)/L+ABS(VC[i])*BS/L;
      VS[i]:=FLOOR(VS[i]*100)/100;
      W2[i]:=VCB[i]/L;
      W2[i]:=FLOOR(W2[i]*100)/100;
    end;
    J1:=M1*Power(AS1,2);
    T10:=JD*Power(WD,2)/2+J1*Power(W1,2)/2+M2*Power(VS[1],2)/2+J2*Power(W2[1],2)/2+M3*Power(VC[1],2)/2;
    T10:=FLOOR(T10/10)/100;
    for i:=1 to 9 do begin
      T2[i]:=M2*Power(VS[i],2)+J2*Power(W2[i],2)/2+M3*Power(VC[i],2)/2;
      T2[i]:=FLOOR(T2[i]/10)/100;
      T1[i]:=T10+AK[i]-T2[i];
    end;

    //max t1 and min t1
    //max
    T11:=T1[1];
    iK:=1;
    for i:=2 to 9 do begin
      if T11<T1[i] then begin
        iK:=i;
        T11:=T1[i];
      end;
    end;
    //min
    T22:=T1[1];
    iK:=1;
    for i:=2 to 9 do begin
      if T22>T1[i] then begin
        iK:=i;
        T22:=T1[i];
      end;
    end;
    //
    DT1:=T11-T22;
    DT1:=FLOOR(DT1*100)/100;
    JMAX:=1000*DT1/(DEL*Power(W1,2))-JD*Power(U,2)-J1;
    JMAX:=FLOOR(JMAX*10)/10;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;
  ButtonList.Items[1].Visible:=False;

  for i :=6 to 10 do begin
    LabelsList.Items[i].Visible:=False;
  end;

  for i :=0 to 1 do begin
    EditList.Items[i].Visible:=True;
  end;

  StringGridList.Items[0].Visible:=False;
  StringGridList.Items[1].Visible:=False;

  Form1.Height:=330;
  Form1.Width:=695;

  fFileCreate.LabelsParametrs(PF,'Label3_',6);

  LabelsList.Items[0].Caption:=LabelsList.Items[0].Caption+FloatToStr(T11)+' кДж находится вположении кривошипа №'+IntToStr(iK);
  LabelsList.Items[1].Caption:=LabelsList.Items[1].Caption+FloatToStr(T22)+' кДж находится вположении кривошипа №'+IntToStr(iK);
  LabelsList.Items[2].Caption:=LabelsList.Items[2].Caption+FloatToStr(DT1)+' кДж';

  fFileCreate.EditParametrs(PF,'Edit2_',2);

  fFileCreate.ButtonsParametrs(PF,'Button3_',1);
  ButtonList.Items[0].OnClick:=Start4ButtonClick;
end;

procedure TPowerFlywheel.Start4ButtonClick(Sender: TObject);
begin
  DE:=StrToFloat(EditList.Items[0].Text);
  K1:=StrToFloat(EditList.Items[1].Text);
  try
    MMAX:=8*JMAX/(Power(DE,2)*(1+Power(K1,2)));
    MMAX:=FLOOR(MMAX*10)/10;
    B:=4*MMAX/(3.14*7800*Power(DE,2)*(1-Power(K1,2)));
    B:=FLOOR(B*1000)/1000;
    for i:=1 to 8 do A[i]:=ABS(T1[i+1]-T1[i])*4/3.14;
    //max A[i]
    P:=A[1];
    iK:=1;
    for i:=2 to 9 do begin
      if P<A[i] then begin
        iK:=i;
        P:=A[iK];
      end;
    end;
    MB:=1000*A[iK];
    MB1:=MB/2;
    DW:=MB/(0.2*20);
    if DW<0 then begin
      DW:=Power(ABS((MB/(0.2*20))),0.333);
      DW:=-DW/100;
    end else begin
      DW:=Power((MB/(0.2*20)),0.333)/100;
    end;
    DW:=FLOOR(DW*1000)/1000;
    if DW1<0 then begin
      DW1:=Power(ABS((MB1/(0.2*20))),0.333);
      DW1:=-DW1/100;
    end else begin
      DW1:=Power((MB1/(0.2*20)),0.333)/100;
    end;
    DW1:=FLOOR(DW1*1000)/1000;
    TMAX:=JMAX*Power(W1,2)/2;
    TMAX:=FLOOR(TMAX/1000);
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;

  for i :=0 to 1 do begin
    EditList.Items[i].Visible:=False;
  end;

  LabelsList.Items[6].Visible:=False;

  ButtonList.Items[1].Visible:=True;

  Form1.Height:=267;
  Form1.Width:=510;


  fFileCreate.LabelsParametrs(PF,'Label4_',7);

  LabelsList.Items[0].Caption:=LabelsList.Items[0].Caption+FloatToStr(MMAX)+' кг';
  LabelsList.Items[1].Caption:=LabelsList.Items[1].Caption+FloatToStr(JMAX)+' кг*м2';
  LabelsList.Items[2].Caption:=LabelsList.Items[2].Caption+FloatToStr(B)+' м';
  LabelsList.Items[3].Caption:=LabelsList.Items[3].Caption+FloatToStr(T1[iK+1]-T1[iK])+' K='+FloatToStr(iK);
  LabelsList.Items[4].Caption:=LabelsList.Items[4].Caption+FloatToStr(DW)+' м';
  LabelsList.Items[5].Caption:=LabelsList.Items[5].Caption+FloatToStr(DW1)+' м';
  LabelsList.Items[6].Caption:=LabelsList.Items[6].Caption+FloatToStr(TMAX)+' кДж';

  fFileCreate.ButtonsParametrs(PF,'Button4_',2);
  ButtonList.Items[0].OnClick:=Start5ButtonClick;
end;

procedure TPowerFlywheel.Start5ButtonClick(Sender: TObject);
begin
  Form1.Height:=630;
  Form1.Width:=880;

  ButtonList.Items[0].Visible:=False;


  for i :=7 to 8 do begin
    LabelsList.Items[i].Visible:=True;
  end;

  fFileCreate.LabelsParametrs(PF,'Label5_',9);

  LabelsList.Items[7].Caption:=LabelsList.Items[7].Caption+FloatToStr(T10)+' кДж';

  LabelsList.Items[0].Font.Size:=14;
  LabelsList.Items[1].Font.Size:=14;
  LabelsList.Items[7].Font.Size:=14;
  LabelsList.Items[8].Font.Size:=14;

  fFileCreate.ButtonsParametrs(PF,'Button5_',2);

  fFileCreate.StringGridsParametrs(PF,'StringGrid1_',2);
  fFileCreate.StringGridsCells(PF,'StringGrid1_',2);
    
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,0]:=IntToStr(i);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,1]:=FloatToStr(MF1[i]);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,2]:=FloatToStr(AK[i]);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,3]:=FloatToStr(T2[i]);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,4]:=FloatToStr(T1[i]);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,5]:=FloatToStr(VS[i]);
  for i:=1 to 9 do StringGridList.Items[0].Cells[i,6]:=FloatToStr(W2[i]);  
  
  StringGridList.Items[1].Cells[0,1]:=FloatToStr(R);  
  StringGridList.Items[1].Cells[1,1]:=FloatToStr(L); 
  StringGridList.Items[1].Cells[2,1]:=FloatToStr(BS); 
  StringGridList.Items[1].Cells[3,1]:=FloatToStr(N1);
  StringGridList.Items[1].Cells[4,1]:=FloatToStr(FR);  
  StringGridList.Items[1].Cells[5,1]:=FloatToStr(AS1);  
  StringGridList.Items[1].Cells[6,1]:=FloatToStr(N);  
  StringGridList.Items[1].Cells[7,1]:=FloatToStr(M1); 
  StringGridList.Items[1].Cells[8,1]:=FloatToStr(M2);  
  StringGridList.Items[1].Cells[9,1]:=FloatToStr(M3);  
  StringGridList.Items[1].Cells[10,1]:=FloatToStr(J2);  
  StringGridList.Items[1].Cells[11,1]:=FloatToStr(DEL);  
  StringGridList.Items[1].Cells[12,1]:=FloatToStr(K);  
end;

procedure TPowerFlywheel.BackButtonClick(Sender: TObject);
begin
  destroy;
  fFileCreate := TCreateMainForm.create(Form1);
end;

procedure TPowerFlywheel.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9',#8,',','a'..'z','A'..'Z'])
    or (ord(Key) >= 1040) and (ord(Key) <= 1103)) then Key:=#0; //only numbers and letters
end;

end.
