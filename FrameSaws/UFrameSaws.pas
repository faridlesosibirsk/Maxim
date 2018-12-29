unit UFrameSaws;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs, IniFiles,
  Generics.Collections, Math, Vcl.Grids, WinProcs,Vcl.ExtCtrls,
  UObjects;

type
  TFrameSaws = class(TObjects)
  private
    LabeledEdit1,LabeledEdit2,LabeledEdit3,LabeledEdit4:TLabeledEdit;
    Label1:TLabel;
    StartButton, BackButton: TButton;
    StringGrid1:TStringGrid;
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
  fFileCreate.LabeledEditCreate(AOwner, LabeledEdit1, 24, 272, 'Введите толщину полотна пилы (м)');
  fFileCreate.LabeledEditCreate(AOwner, LabeledEdit2, 57, 272, 'Введите ширину полотна пилы (м)');
  fFileCreate.LabeledEditCreate(AOwner, LabeledEdit3, 90, 272, 'Введите свободную длину полотна (м)');
  fFileCreate.LabeledEditCreate(AOwner, LabeledEdit4, 123, 272, 'Введите продольную силу (кН)');
  fFileCreate.LabelsCreate(AOwner, Label1, 12, 156, 135, 'Начальное смещение=0,01 м.');


  fFileCreate.ButtonsCreate(AOwner, StartButton, 194, 279, 177, 'Выполнить', False);
  StartButton.OnClick:=StartButtonClick;
  fFileCreate.ButtonsCreate(AOwner, BackButton, 194, 8, 177, 'К выбору программ', True);
  BackButton.OnClick:=BackButtonClick;


  fFileCreate.StringGridsCreate(AOwner, StringGrid1, 40, 8, 79, 955, 1, 1, 7, 3);

  for i:=Form1.ComponentCount-1 downto 0 do begin
  if (Form1.Components[i] is TLabeledEdit) then begin
       (Form1.Components[i] as TLabeledEdit).OnChange:=LabeledEdit1Change;
       (Form1.Components[i] as TLabeledEdit).OnKeyPress:=LabeledEdit1KeyPress;
      end;
  end;
end;

procedure TFrameSaws.destroy;
begin
  StartButton.Free;
  BackButton.Free;
  LabeledEdit1.Free;
  LabeledEdit2.Free;
  LabeledEdit3.Free;
  LabeledEdit4.Free;
  Label1.Free;
  StringGrid1.Destroy;
end;

procedure TFrameSaws.StartButtonClick(Sender: TObject);
var i:integer;
begin
  B:=StrToFloat(LabeledEdit1.Text);
  H:=StrToFloat(LabeledEdit2.Text);
  L:=StrToFloat(LabeledEdit3.Text);
  N:=StrToFloat(LabeledEdit4.Text);
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

      StringGrid1.Cells[i,0]:=FloatToStr(E1)+' м.';
      StringGrid1.Cells[i,1]:=FloatToStrF(A1[1,i],ffFixed,20,2);
      StringGrid1.Cells[i,2]:=FloatToStrF(A1[2,i],ffFixed,20,2);
      StringGrid1.ColWidths[i]:=135;

      E1:=E1+0.01;
    end;
  except
    Application.MessageBox('Попытка деления на 0!','Ошибка');
    exit;
  end;
  StartButton.Visible:=False;
  LabeledEdit1.Visible:=False;
  LabeledEdit2.Visible:=False;
  LabeledEdit3.Visible:=False;
  LabeledEdit4.Visible:=False;
  StringGrid1.Visible:=True;

  fFileCreate.LabelsParametrs(Label1,14,14,480,'Смещение');
  fFileCreate.ButtonParametrs(BackButton,130,8);

  Form1.Height:=200;
  Form1.Width:=1000;

  StringGrid1.ColWidths[0]:=135;

  StringGrid1.Cells[0,0]:='  Наименование';
  StringGrid1.Cells[0,1]:='   Крит. момент';
  StringGrid1.Cells[0,2]:='        Крит. сила';

end;

procedure TFrameSaws.BackButtonClick(Sender: TObject);
begin
  destroy;
  fFileCreate := TCreateMainForm.create(Form1);
end;

procedure TFrameSaws.LabeledEdit1Change(Sender: TObject); //if Edit='', don't continue
begin
  if (LabeledEdit1.Text='') or (LabeledEdit2.Text='')
    or (LabeledEdit3.Text='') or (LabeledEdit4.Text='')
    then StartButton.Enabled:=False else StartButton.Enabled:=True;
end;

procedure TFrameSaws.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,',']) then Key:=#0; //only numbers
end;

end.
