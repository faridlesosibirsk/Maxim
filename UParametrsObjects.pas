unit UParametrsObjects;

interface

uses
  Forms,StdCtrls,Vcl.Grids;

type
  TParametrsObjects = class
  public
    procedure LabelsParametrs(var Label_: TLabel; FontSize,Top,Left: integer; Caption: string);
    procedure EditParametrs(var Edit_: TEdit; Top,Left,Width,MaxLength: integer);
    procedure ButtonParametrs(var Button_:TButton; Top,Left:integer);
  end;
implementation

{ TParametrsObjects }

procedure TParametrsObjects.ButtonParametrs(var Button_: TButton; Top,
  Left: integer);
begin
  Button_.Top:=Top;
  Button_.Left:=Left;
end;

procedure TParametrsObjects.EditParametrs(var Edit_: TEdit; Top, Left, Width,
  MaxLength: integer);
begin
  Edit_.Top:=Top;
  Edit_.Left:=Left;
  Edit_.Width:=Width;
  Edit_.Text:='';
  Edit_.MaxLength:=MaxLength;
end;

procedure TParametrsObjects.LabelsParametrs(var Label_: TLabel; FontSize, Top,
  Left: integer; Caption: string);
begin
  Label_.Font.Size:=FontSize;
  Label_.Top:=Top;
  Label_.Left:=Left;
  Label_.Font.Name:='Times New Roman';
  Label_.Caption:=Caption;
end;

end.