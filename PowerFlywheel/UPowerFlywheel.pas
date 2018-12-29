unit UPowerFlywheel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs, IniFiles,
  Generics.Collections, Math, Vcl.Grids, WinProcs,
  UObjects, UConstants;

type
  TPowerFlywheel = class(TObjects)
  private
    OneLabels: TList<TLabel>;

    /// <link>aggregation</link>
    Offset: TPowerFlywheel;

    Labels:TLabel;
    Edit1, Edit2, Edit3, Edit4, Edit5,
    Edit6, Edit7, Edit8, Edit9, Edit10,
    Edit11, Edit12, Edit13: TEdit;

    StartButton, BackButton: TButton;
    StringGrid1, StringGrid2: TStringGrid;
  public
    constructor create(AOwner: TForm);
    procedure destroy; override;
    procedure Start1ButtonClick(Sender:TObject);
    procedure Start2ButtonClick(Sender:TObject);
    procedure Start3ButtonClick(Sender: TObject);
    procedure Start4ButtonClick(Sender: TObject);
    procedure Start5ButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender:TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
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
var Ini: TIniFile;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    OneLabels := TList<TLabel>.create;
    for i := 0 to 13 do begin
      Labels:= TLabel.create(AOwner);
      Labels.Parent:=AOwner;
      Labels.Left := Ini.ReadInteger('Label0_' + inttostr(i + 1), 'Left', 0);
      Labels.Top := Ini.ReadInteger('Label0_' + inttostr(i + 1), 'Top', 0);
      Labels.Caption := Ini.ReadString('Label0_' + inttostr(i + 1), 'Caption', '0');
      Labels.Font.Name:='Times New Roman';
      Labels.Font.Size:=12;
      OneLabels.Add(Labels);
    end;
  finally
    Ini.Free;
  end;
  OneLabels.Items[0].Font.Size:=14;

  fFileCreate.EditCreate(AOwner, Edit1, 43);
  fFileCreate.EditCreate(AOwner, Edit2, 76);
  fFileCreate.EditCreate(AOwner, Edit3, 109);
  fFileCreate.EditCreate(AOwner, Edit4, 142);
  fFileCreate.EditCreate(AOwner, Edit5, 175);
  fFileCreate.EditCreate(AOwner, Edit6, 208);
  fFileCreate.EditCreate(AOwner, Edit7, 241);
  fFileCreate.EditCreate(AOwner, Edit8, 274);
  fFileCreate.EditCreate(AOwner, Edit9, 307);
  fFileCreate.EditCreate(AOwner, Edit10, 340);
  fFileCreate.EditCreate(AOwner, Edit11, 373);
  fFileCreate.EditCreate(AOwner, Edit12, 406);
  fFileCreate.EditCreate(AOwner, Edit13, 439);
  for i:=Form1.ComponentCount-1 downto 0 do begin
  if (Form1.Components[i] is TEdit) then begin
       (Form1.Components[i] as TEdit).OnChange:=Edit1Change;
       (Form1.Components[i] as TEdit).OnKeyPress:=Edit1KeyPress;
      end;
  end;
  fFileCreate.ButtonsCreate(AOwner, StartButton, 478, 325, 121, 'Выполнить', False);
  StartButton.OnClick:=Start1ButtonClick;
  fFileCreate.ButtonsCreate(AOwner, BackButton, 478, 8, 177, 'К выбору программ', True);
  BackButton.OnClick:=BackButtonClick;

  fFileCreate.StringGridsCreate(AOwner, StringGrid1, 90, 8, 80, 725, 1, 1, 10, 3);
  fFileCreate.StringGridsCreate(AOwner, StringGrid2, 270, 8, 51, 721, 1, 1, 10, 2);
end;

procedure TPowerFlywheel.destroy;
begin
    for i:=Form1.ComponentCount-1 downto 0 do begin
      if (Form1.Components[i] is TEdit) then begin
       (Form1.Components[i] as TEdit).Free;
      end;
    end;
    StartButton.Free;
    BackButton.Free;
    StringGrid1.Free;
    StringGrid2.Free;
    for i:=0 to OneLabels.Count-1 do OneLabels.Items[i].Free;

end;

procedure TPowerFlywheel.Start1ButtonClick(Sender: TObject);
var Ini:TIniFile;
begin
  //
  R:=StrToFloat(Edit1.Text);
  L:=StrToFloat(Edit2.Text);
  BS:=StrToFloat(Edit3.Text);
  N1:=StrToFloat(Edit4.Text);
  FR:=StrToFloat(Edit5.Text);
  AS1:=StrToFloat(Edit6.Text);
  N:=StrToFloat(Edit7.Text);
  M1:=StrToFloat(Edit8.Text);
  M2:=StrToFloat(Edit9.Text);
  M3:=StrToFloat(Edit10.Text);
  J2:=StrToFloat(Edit11.Text);
  DEL:=StrToFloat(Edit12.Text);
  K:=StrToFloat(Edit13.Text);
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

  for i :=7 to 13 do begin
    OneLabels.Items[i].Visible:=False;
  end;

  Edit5.Visible:=False;
  Edit6.Visible:=False;
  Edit7.Visible:=False;
  Edit8.Visible:=False;
  Edit9.Visible:=False;
  Edit10.Visible:=False;
  Edit11.Visible:=False;
  Edit12.Visible:=False;
  Edit13.Visible:=False;

  Form1.Height:=300;
  Form1.Width:=465;
  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    for i :=0 to 6 do begin
      OneLabels.Items[i].Left := Ini.ReadInteger('Label1_' + inttostr(i + 1), 'Left', 0);
      OneLabels.Items[i].Top := Ini.ReadInteger('Label1_' + inttostr(i + 1), 'Top', 0);
      OneLabels.Items[i].Caption := Ini.ReadString('Label1_' + inttostr(i + 1), 'Caption', '0');
      OneLabels.Items[i].Font.Size:=12;
    end;
  finally
    Ini.Free;
  end;
  OneLabels.Items[0].Caption:=OneLabels.Items[0].Caption+' '+FloatToStr(FLOOR(PD))+' кВт';

  fFileCreate.EditParametrs(Edit1,94,260,92,8);
  fFileCreate.EditParametrs(Edit2,127,260,92,8);
  fFileCreate.EditParametrs(Edit3,160,260,92,8);
  fFileCreate.EditParametrs(Edit4,193,260,92,14);
  Edit4.OnKeyPress:=Edit2KeyPress;

  fFileCreate.ButtonParametrs(StartButton,230,330);
  StartButton.OnClick:=Start2ButtonClick;
  fFileCreate.ButtonParametrs(BackButton,230,8);
end;

procedure TPowerFlywheel.Start2ButtonClick(Sender: TObject);
var Ini:TIniFile;
begin
  ND:=StrToFloat(Edit1.Text);
  JD:=StrToFloat(Edit2.Text);
  Z1:=StrToFloat(Edit3.Text);
  Z2:=Edit4.Text;

  for i :=7 to 10 do begin
    OneLabels.Items[i].Visible:=True;
  end;

  Edit1.Visible:=False;
  Edit2.Visible:=False;
  Edit3.Visible:=False;
  Edit4.Visible:=False;

  try
    U:=FLOOR(ND/N1*10)/10;
    MDP:=PD*0.8*30/(3.14*N1);
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;

  Form1.Height:=550;
  Form1.Width:=770;

  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    for i :=0 to 10 do begin
      OneLabels.Items[i].Left := Ini.ReadInteger('Label2_' + inttostr(i + 1), 'Left', 0);
      OneLabels.Items[i].Top := Ini.ReadInteger('Label2_' + inttostr(i + 1), 'Top', 0);
      OneLabels.Items[i].Caption := Ini.ReadString('Label2_' + inttostr(i + 1), 'Caption', '0');
      OneLabels.Items[i].Font.Size:=12;
    end;
  finally
    Ini.Free;
  end;
  OneLabels.Items[6].Caption:=OneLabels.Items[6].Caption+' '+FloatToStr(VB)+' м/с';
  OneLabels.Items[7].Caption:=OneLabels.Items[7].Caption+' '+FloatToStr(FR)+' кН';
  OneLabels.Items[8].Caption:=OneLabels.Items[8].Caption+' '+FloatToStr(ND)+' об/мин';
  OneLabels.Items[9].Caption:=OneLabels.Items[9].Caption+' '+FloatToStr(Z1)+' кВт/'+Z2;
  OneLabels.Items[10].Caption:=OneLabels.Items[10].Caption+' '+FloatToStr(U);

  fFileCreate.ButtonParametrs(StartButton,477,640);
  StartButton.Caption:='Вперед';
  StartButton.OnClick:=Start3ButtonClick;
  fFileCreate.ButtonParametrs(BackButton,477,8);

  StringGrid1.ColWidths[0]:=135;
  StringGrid1.Cells[0,0]:='скорости точек';
  StringGrid1.Cells[0,1]:='           Vcb, м/с';
  StringGrid1.Cells[0,2]:='             Vc, м/с';
  StringGrid1.Visible:=True;

  StringGrid2.ColWidths[0]:=130;
  StringGrid2.Cells[0,0]:='Наименование';
  StringGrid2.Cells[0,1]:='         Mf, кН*м';
  StringGrid2.Visible:=True;

  for i:=1 to 9 do begin
    StringGrid1.Cells[i,0]:=IntToStr(i);
    StringGrid1.Cells[i,1]:=FloatToStr(VCB[i]);
    StringGrid1.Cells[i,2]:=FloatToStr(VC[i]);

    StringGrid2.Cells[i,0]:=IntToStr(i);
    StringGrid2.Cells[i,1]:=FloatToStr(MF[i]);
  end;
  Edit4.OnKeyPress:=Edit1KeyPress;
end;

procedure TPowerFlywheel.Start3ButtonClick(Sender: TObject);
var Ini: TIniFile;
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
  BackButton.Visible:=False;

  for i :=6 to 10 do begin
    OneLabels.Items[i].Visible:=False;
  end;


  StringGrid1.Visible:=False;
  StringGrid2.Visible:=False;
  Edit1.Visible:=True;
  Edit2.Visible:=True;

  Form1.Height:=330;
  Form1.Width:=695;

  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    for i :=0 to 5 do begin
      OneLabels.Items[i].Left := Ini.ReadInteger('Label3_' + inttostr(i + 1), 'Left', 0);
      OneLabels.Items[i].Top := Ini.ReadInteger('Label3_' + inttostr(i + 1), 'Top', 0);
      OneLabels.Items[i].Caption := Ini.ReadString('Label3_' + inttostr(i + 1), 'Caption', '0');
      OneLabels.Items[i].Font.Size:=12;
    end;
  finally
    Ini.Free;
  end;
  OneLabels.Items[0].Caption:=OneLabels.Items[0].Caption+FloatToStr(T11)+' кДж находится вположении кривошипа №'+IntToStr(iK);
  OneLabels.Items[1].Caption:=OneLabels.Items[1].Caption+FloatToStr(T22)+' кДж находится вположении кривошипа №'+IntToStr(iK);
  OneLabels.Items[2].Caption:=OneLabels.Items[2].Caption+FloatToStr(DT1)+' кДж';

  fFileCreate.EditParametrs(Edit1,187,257,121,Edit1.MaxLength);
  fFileCreate.EditParametrs(Edit2,220,257,121,Edit2.MaxLength);

  fFileCreate.ButtonParametrs(StartButton,256,550);
  StartButton.OnClick:=Start4ButtonClick;
end;

procedure TPowerFlywheel.Start4ButtonClick(Sender: TObject);
var Ini: TIniFile;
begin
  DE:=StrToFloat(Edit1.Text);
  K1:=StrToFloat(Edit2.Text);
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
  Edit1.Visible:=False;
  Edit2.Visible:=False;

  OneLabels.Items[6].Visible:=False;

  BackButton.Visible:=True;

  Form1.Height:=267;
  Form1.Width:=510;


  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    for i :=0 to 6 do begin
      OneLabels.Items[i].Left := Ini.ReadInteger('Label4_' + inttostr(i + 1), 'Left', 0);
      OneLabels.Items[i].Top := Ini.ReadInteger('Label4_' + inttostr(i + 1), 'Top', 0);
      OneLabels.Items[i].Caption := Ini.ReadString('Label4_' + inttostr(i + 1), 'Caption', '0');
      OneLabels.Items[i].Font.Size:=12;
    end;
  finally
    Ini.Free;
  end;

  OneLabels.Items[0].Caption:=OneLabels.Items[0].Caption+FloatToStr(MMAX)+' кг';
  OneLabels.Items[1].Caption:=OneLabels.Items[1].Caption+FloatToStr(JMAX)+' кг*м2';
  OneLabels.Items[2].Caption:=OneLabels.Items[2].Caption+FloatToStr(B)+' м';
  OneLabels.Items[3].Caption:=OneLabels.Items[3].Caption+FloatToStr(T1[iK+1]-T1[iK])+' K='+FloatToStr(iK);
  OneLabels.Items[4].Caption:=OneLabels.Items[4].Caption+FloatToStr(DW)+' м';
  OneLabels.Items[5].Caption:=OneLabels.Items[5].Caption+FloatToStr(DW1)+' м';
  OneLabels.Items[6].Caption:=OneLabels.Items[6].Caption+FloatToStr(TMAX)+' кДж';

  fFileCreate.ButtonParametrs(StartButton,197,375);
  StartButton.OnClick:=Start5ButtonClick;
  fFileCreate.ButtonParametrs(BackButton,194,8);
end;

procedure TPowerFlywheel.Start5ButtonClick(Sender: TObject);
var Ini:TIniFile;
begin
  Form1.Height:=630;
  Form1.Width:=880;

  StartButton.Visible:=False;


  for i :=7 to 8 do begin
    OneLabels.Items[i].Visible:=True;
  end;

  try
    Ini := TIniFile.create(Constant.GetDirectory+IniPath+PFLabels);
    for i :=0 to 8 do begin
      OneLabels.Items[i].Left := Ini.ReadInteger('Label5_' + inttostr(i + 1), 'Left', 0);
      OneLabels.Items[i].Top := Ini.ReadInteger('Label5_' + inttostr(i + 1), 'Top', 0);
      OneLabels.Items[i].Caption := Ini.ReadString('Label5_' + inttostr(i + 1), 'Caption', '0');
      OneLabels.Items[i].Font.Size:=12;
    end;
  finally
    Ini.Free;
  end;
  OneLabels.Items[7].Caption:=OneLabels.Items[7].Caption+FloatToStr(T10)+' кДж';

  OneLabels.Items[0].Font.Size:=14;
  OneLabels.Items[1].Font.Size:=14;
  OneLabels.Items[7].Font.Size:=14;
  OneLabels.Items[8].Font.Size:=14;

  fFileCreate.ButtonParametrs(BackButton,550,8);

  StringGrid1.Left:=112;
  StringGrid1.Top:=96;
  StringGrid1.Height:=181;
  StringGrid1.Width:=705;
  StringGrid1.Font.Name:='Times New Roman';
  StringGrid1.Font.Size:=14;
  StringGrid1.FixedCols:=1;
  StringGrid1.FixedRows:=1;
  StringGrid1.ColCount:=10;
  StringGrid1.RowCount:=7;
  StringGrid1.Cells[0,0]:='';
  StringGrid1.Cells[0,1]:='     Мпр, кНм';
  StringGrid1.Cells[0,2]:='         А, кДж';
  StringGrid1.Cells[0,3]:='        T2, кДж';
  StringGrid1.Cells[0,4]:='        T1, кДж';
  StringGrid1.Cells[0,5]:='          Vs, м/с';
  StringGrid1.Cells[0,6]:='                W2';
  StringGrid1.ColWidths[0]:=115;
  for i:=1 to 9 do StringGrid1.Cells[i,0]:=IntToStr(i);
  for i:=1 to 9 do StringGrid1.Cells[i,1]:=FloatToStr(MF1[i]);
  for i:=1 to 9 do StringGrid1.Cells[i,2]:=FloatToStr(AK[i]);
  for i:=1 to 9 do StringGrid1.Cells[i,3]:=FloatToStr(T2[i]);
  for i:=1 to 9 do StringGrid1.Cells[i,4]:=FloatToStr(T1[i]);
  for i:=1 to 9 do StringGrid1.Cells[i,5]:=FloatToStr(VS[i]);
  for i:=1 to 9 do StringGrid1.Cells[i,6]:=FloatToStr(W2[i]);
  StringGrid1.Visible:=True;

  StringGrid2.Left:=8;
  StringGrid2.Top:=490;
  StringGrid2.Height:=53;
  StringGrid2.Width:=848;
  StringGrid2.FixedCols:=0;
  StringGrid2.FixedRows:=1;
  StringGrid2.ColCount:=13;
  StringGrid2.RowCount:=2;
  StringGrid2.ColWidths[0]:=StringGrid2.ColWidths[1];
  StringGrid2.Cells[0,0]:='R';
  StringGrid2.Cells[0,1]:=FloatToStr(R);
  StringGrid2.Cells[1,0]:='L';
  StringGrid2.Cells[1,1]:=FloatToStr(L);
  StringGrid2.Cells[2,0]:='BS';
  StringGrid2.Cells[2,1]:=FloatToStr(BS);
  StringGrid2.Cells[3,0]:='N1';
  StringGrid2.Cells[3,1]:=FloatToStr(N1);
  StringGrid2.Cells[4,0]:='FR';
  StringGrid2.Cells[4,1]:=FloatToStr(FR);
  StringGrid2.Cells[5,0]:='AS1';
  StringGrid2.Cells[5,1]:=FloatToStr(AS1);
  StringGrid2.Cells[6,0]:='N';
  StringGrid2.Cells[6,1]:=FloatToStr(N);
  StringGrid2.Cells[7,0]:='M1';
  StringGrid2.Cells[7,1]:=FloatToStr(M1);
  StringGrid2.Cells[8,0]:='M2';
  StringGrid2.Cells[8,1]:=FloatToStr(M2);
  StringGrid2.Cells[9,0]:='M3';
  StringGrid2.Cells[9,1]:=FloatToStr(M3);
  StringGrid2.Cells[10,0]:='J2';
  StringGrid2.Cells[10,1]:=FloatToStr(J2);
  StringGrid2.Cells[11,0]:='DEL';
  StringGrid2.Cells[11,1]:=FloatToStr(DEL);
  StringGrid2.Cells[12,0]:='K';
  StringGrid2.Cells[12,1]:=FloatToStr(K);
  StringGrid2.Visible:=True;
end;

procedure TPowerFlywheel.BackButtonClick(Sender: TObject);
begin
  destroy;
  fFileCreate := TCreateMainForm.create(Form1);
end;

procedure TPowerFlywheel.Edit1Change(Sender: TObject); //if Edit='', don't continue
begin
  if (Edit1.Text='') or (Edit2.Text='') or (Edit3.Text='')
    or (Edit4.Text='') or (Edit5.Text='') or (Edit6.Text='')
      or (Edit7.Text='') or (Edit8.Text='') or (Edit9.Text='')
        or (Edit10.Text='') or (Edit11.Text='') or (Edit12.Text='')
          or (Edit13.Text='') then StartButton.Enabled:=False else StartButton.Enabled:=True;
end;

procedure TPowerFlywheel.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,',']) then Key:=#0; //only numbers
end;

procedure TPowerFlywheel.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9',#8,',','a'..'z','A'..'Z'])
    or (ord(Key) >= 1040) and (ord(Key) <= 1103)) then Key:=#0; //only numbers and letters
end;

end.
