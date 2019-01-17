unit UFrameSaws;

interface

uses
  SysUtils, Forms, StdCtrls, Generics.Collections, Math, Vcl.Grids,Vcl.ExtCtrls,
  UObjects, UConstants;

type
  TFrameSaws = class(TObjects)
  public
    constructor create(AOwner: TForm);
    procedure destroy; override;
    procedure BackButtonClick(Sender:TObject);
    procedure StartButtonClick(Sender:TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
  end;

var
  B, //толщина полотна
  H, //ширина полотна
  L, //свободная длина полотна
  N,  //продольная сила
  E1,  //начальное смещение
  EY, G, EJ, GJ, R, Q, P:real;
  A1:array[1..2,1..6] of real;



implementation

uses UMainForm, UCreateMainForm;

{ TFrameSaws }

constructor TFrameSaws.create(AOwner: TForm);
var i:integer;
begin
  LabeledEditList := TList<TLabeledEdit>.create;
  fFileCreate.LabeledEditCreate(AOwner,4);
  fFileCreate.LabeledEditParametrs(FS,'LabeledEdit',4);

  LabelsList := TList<TLabel>.create;
  fFileCreate.LabelsCreate(AOwner,1);
  fFileCreate.LabelsParametrs(FS,'Label0_',1);

  ButtonList := TList<TButton>.create;
  fFileCreate.ButtonsCreate(AOwner,2);
  fFileCreate.ButtonsParametrs(FS,'Button0_',2);
  ButtonList.Items[0].OnClick:=StartButtonClick;
  ButtonList.Items[1].OnClick:=BackButtonClick;
  ButtonList.Items[0].Enabled:=False;

  StringGridList:=TList<TStringGrid>.create;
  fFileCreate.StringGridsCreate(AOwner,1);
  fFileCreate.StringGridsParametrs(FS,'StringGrid0_',1);

  for i:=0 to 3 do begin
    LabeledEditList.Items[i].OnChange:=LabeledEdit1Change;
    LabeledEditList.Items[i].OnKeyPress:=LabeledEdit1KeyPress;
  end;

end;

procedure TFrameSaws.destroy;
var i:integer;
begin
  for i:=0 to LabeledEditList.Count-1 do LabeledEditList.Items[i].Free;
  for i:=0 to LabelsList.Count-1 do LabelsList.Items[i].Free;
  for i:=0 to ButtonList.Count-1 do ButtonList.Items[i].Free;
  for i:=0 to StringGridList.Count-1 do StringGridList.Items[i].Free;
end;

procedure TFrameSaws.StartButtonClick(Sender: TObject);
var i:integer;
begin
  B:=StrToFloat(LabeledEditList.Items[0].Text);
  H:=StrToFloat(LabeledEditList.Items[1].Text);
  L:=StrToFloat(LabeledEditList.Items[2].Text);
  N:=StrToFloat(LabeledEditList.Items[3].Text);
  try
    E1:=0.01;
    EY:=2E+08;
    G:=8E+07;
    EJ:=EY*H*Power(B,3)/12;
    GJ:=G*H*Power(B,3)/3;
    for i:=1 to 6 do begin
      A1[2,i]:=4*(N*E1+GJ/H)/L;
      R:=GJ/Power(E1,2);
      Q:=EJ*GJ*Power(3.14,2)/Power((E1*L),2);
      P:=R*(1+Power((1-Q/Power((R/2),2)),0.51))/2;
      A1[1,i]:=P*E1;

      StringGridList.Items[0].Cells[i,0]:=FloatToStr(E1)+' м.';
      StringGridList.Items[0].Cells[i,1]:=FloatToStrF(A1[1,i],ffFixed,20,2);
      StringGridList.Items[0].Cells[i,2]:=FloatToStrF(A1[2,i],ffFixed,20,2);
      StringGridList.Items[0].ColWidths[i]:=135;

      E1:=E1+0.01;
    end;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;
  ButtonList.Items[0].Visible:=False;
  for i:=0 to 3 do LabeledEditList.Items[i].Visible:=False;
  StringGridList.Items[0].Visible:=True;

  fFileCreate.LabelsParametrs(FS,'Label1_',1);
  LabelsList.Items[0].Font.Size:=14;

  fFileCreate.ButtonsParametrs(FS,'Button1_',2);

  Form1.Height:=200;
  Form1.Width:=1000;

  StringGridList.Items[0].ColWidths[0]:=135;

  StringGridList.Items[0].Cells[0,0]:='  Наименование';
  StringGridList.Items[0].Cells[0,1]:='   Крит. момент';
  StringGridList.Items[0].Cells[0,2]:='        Крит. сила';

end;

procedure TFrameSaws.BackButtonClick(Sender: TObject);
begin
  destroy;
  fFileCreate := TCreateMainForm.create(Form1);
end;

procedure TFrameSaws.LabeledEdit1Change(Sender: TObject); //if Edit='', don't continue
begin
  if (LabeledEditList.Items[0].Text='') or (LabeledEditList.Items[1].Text='')
    or (LabeledEditList.Items[2].Text='') or (LabeledEditList.Items[3].Text='')
    then ButtonList.Items[0].Enabled:=False else ButtonList.Items[0].Enabled:=True;
end;

procedure TFrameSaws.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,',']) then Key:=#0; //only numbers
end;

end.
