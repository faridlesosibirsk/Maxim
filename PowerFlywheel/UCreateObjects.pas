unit UCreateObjects;

interface

uses
  Forms,StdCtrls,Vcl.Grids;
type
  TCreateObjects = class
  public
    procedure LabelsCreate(AOwner: TForm; var Label_: TLabel; FontSize,Top,Left: integer;
                Caption: string);
    procedure EditCreate(AOwner: TForm; var Edit_: TEdit; Top: integer);
    procedure ButtonsCreate(AOwner: TForm; var Button_: TButton;
                      Top,Left,Width: integer; Caption: string; Enabled:boolean);
    procedure StringGridsCreate(AOwner: TForm; var StringGrid_: TStringGrid; Top,
                Left,Height,Width, FixedCols, FixedRows, ColCount, RowCount: integer);
  end;

implementation

{ TCreateObjects }

procedure TCreateObjects.EditCreate(AOwner: TForm; var Edit_: TEdit; Top: integer);
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

procedure TCreateObjects.LabelsCreate(AOwner: TForm; var Label_: TLabel; FontSize,
  Top, Left: integer; Caption: string);
begin
  Label_:=TLabel.create(AOwner);
  Label_.Font.Size:=FontSize;
  Label_.Top:=Top;
  Label_.Left:=Left;
  Label_.Font.Name:='Times New Roman';
  Label_.Caption:=Caption;
  Label_.Parent:=AOwner;
end;

procedure TCreateObjects.ButtonsCreate(AOwner: TForm; var Button_: TButton; Top,
  Left, Width: integer; Caption: string; Enabled: boolean);
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

  procedure TCreateObjects.StringGridsCreate(AOwner: TForm; var StringGrid_: TStringGrid;
  Top, Left, Height, Width, FixedCols, FixedRows, ColCount,
  RowCount: integer);
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
end;

end.
