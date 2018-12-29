unit UObjects;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs,Vcl.Grids,Vcl.ExtCtrls,
  Generics.Collections;

type
  TObjects = class
  public

    procedure destroy; virtual; abstract;

    procedure LabeledEditCreate(AOwner: TForm; var LabeledEdit_: TLabeledEdit; Top,Left: integer;
                Caption: string);

    procedure LabelsCreate(AOwner: TForm; var Label_: TLabel; FontSize,Top,Left: integer;
                Caption: string);
    procedure EditCreate(AOwner: TForm; var Edit_: TEdit; Top: integer);
    procedure ButtonsCreate(AOwner: TForm; var Button_: TButton;
                      Top,Left,Width: integer; Caption: string; Enabled:boolean);
    procedure StringGridsCreate(AOwner: TForm; var StringGrid_: TStringGrid; Top,
                Left,Height,Width, FixedCols, FixedRows, ColCount, RowCount: integer);

    procedure LabelsParametrs(var Label__: TLabel; FontSize,Top,Left: integer; Caption: string);
    procedure EditParametrs(var Edit_: TEdit; Top,Left,Width,MaxLength: integer);
    procedure ButtonParametrs(var Button_:TButton; Top,Left:integer);
    procedure CreateObjects(var OneLabels: TList<TLabel>; i:integer);
  end;

var
  fFileCreate: TObjects;

implementation

{ TInterfaceMenuCreate }

procedure TObjects.ButtonsCreate(AOwner: TForm;
  var Button_: TButton; Top, Left, Width: integer; Caption: string;
  Enabled: boolean);
begin
  Button_:=TButton.create(AOwner);
  Button_.Left:=Left;
  Button_.Top:=Top;
  Button_.Height:=33;
  Button_.Width:=Width;
  Button_.Parent:= AOwner;
  Button_.Caption:=Caption;
  Button_.Font.Name:='Times New Roman';
  Button_.Font.Size:=14;
  Button_.Enabled:=Enabled;
end;

procedure TObjects.CreateObjects(var OneLabels: TList<TLabel>; i: integer);
begin
  //
end;

procedure TObjects.EditCreate(AOwner: TForm; var Edit_: TEdit;
  Top: integer);
begin
  Edit_:=TEdit.Create(AOwner);
  Edit_.Width:=92;
  Edit_.Font.Size:=12;
  Edit_.Top:=Top;
  Edit_.Left:=341;
  Edit_.Font.Name:='Times New Roman';
  Edit_.Parent:=AOwner;
  Edit_.MaxLength:=8;
  Edit_.Text:='';
end;



procedure TObjects.LabeledEditCreate(AOwner: TForm; var LabeledEdit_: TLabeledEdit;
  Top, Left: integer; Caption: string);
begin
  LabeledEdit_:=TLabeledEdit.Create(AOwner);
  LabeledEdit_.Parent:=AOwner;
  LabeledEdit_.Width:=92;
  LabeledEdit_.Top:=Top;
  LabeledEdit_.Left:=Left;
  LabeledEdit_.Font.Size:=12;
  LabeledEdit_.EditLabel.Font.Size:=12;
  LabeledEdit_.Font.Name:='Times New Roman';
  LabeledEdit_.EditLabel.Font.Name:='Times New Roman';
  LabeledEdit_.EditLabel.Caption:=Caption;
  LabeledEdit_.MaxLength:=8;
  LabeledEdit_.LabelPosition:=lpLeft;

end;

procedure TObjects.LabelsCreate(AOwner: TForm; var Label_: TLabel;
  FontSize, Top, Left: integer; Caption: string);
begin
  Label_:=TLabel.create(AOwner);
  Label_.Font.Size:=FontSize;
  Label_.Top:=Top;
  Label_.Left:=Left;
  Label_.Font.Name:='Times New Roman';
  Label_.Caption:=Caption;
  Label_.Parent:=AOwner;
end;



procedure TObjects.StringGridsCreate(AOwner: TForm;
  var StringGrid_: TStringGrid; Top, Left, Height, Width, FixedCols, FixedRows,
  ColCount, RowCount: integer);
begin
  StringGrid_:=TStringGrid.Create(AOwner);
  StringGrid_.Top:=Top;
  StringGrid_.Left:=Left;
  StringGrid_.Height:=Height;
  StringGrid_.Width:=Width;
  StringGrid_.FixedCols:=FixedCols;
  StringGrid_.FixedRows:=FixedRows;
  StringGrid_.ColCount:=ColCount;
  StringGrid_.RowCount:=RowCount;
  StringGrid_.Visible:=False;
  StringGrid_.Font.Name:='Times New Roman';
  StringGrid_.Font.Size:=14;
  StringGrid_.Parent:= AOwner;
  StringGrid_.DrawingStyle:=gdsGradient;
end;

procedure TObjects.ButtonParametrs(var Button_: TButton; Top,
  Left: integer);
begin
  Button_.Top:=Top;
  Button_.Left:=Left;
end;

procedure TObjects.LabelsParametrs(var Label__: TLabel; FontSize,
  Top, Left: integer; Caption: string);
begin
  Label__.Font.Size:=FontSize;
  Label__.Top:=Top;
  Label__.Left:=Left;
  //Label__.Font.Name:='Times New Roman';
  Label__.Caption:=Caption;
end;

procedure TObjects.EditParametrs(var Edit_: TEdit; Top, Left, Width,
  MaxLength: integer);
begin
  Edit_.Top:=Top;
  Edit_.Left:=Left;
  Edit_.Width:=Width;
  Edit_.Text:='';
  Edit_.MaxLength:=MaxLength;
end;

end.