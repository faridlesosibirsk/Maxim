unit UObjects;

interface

uses
  SysUtils, Forms, StdCtrls, Vcl.Grids,Vcl.ExtCtrls, Generics.Collections, IniFiles,
  UConstants;

type
  TObjects = class
  public
    procedure destroy; virtual; abstract;

    procedure LabeledEditCreate (AOwner: TForm; Count:integer);
    procedure LabeledEditParametrs(ProgName,Name: string; Count:integer);

    procedure LabelsCreate(AOwner: TForm; Count:integer);
    procedure LabelsParametrs(ProgName,Name: string; Count:integer);

    procedure EditCreate(AOwner: TForm; Count:integer);
    procedure EditParametrs(ProgName,Name: string; Count:integer);

    procedure ButtonsCreate(AOwner: TForm; Count:integer);
    procedure ButtonsParametrs(ProgName,Name: string; Count:integer);

    procedure StringGridsCreate(AOwner: TForm; Count:integer);
    procedure StringGridsParametrs(ProgName,Name: string; Count:integer);
    procedure StringGridsCells(ProgName, Name:string; Count:integer);

    procedure RadioGroupCreate(AOwner: TForm; Count:integer);
    procedure RadioGroupParametrs(ProgName,Name: string; Count:integer);

    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  end;

var
  fFileCreate: TObjects;
  Ini: TIniFile;

  LabelsList: TList<TLabel>;
  EditList: TList<TEdit>;
  LabeledEditList: TList<TLabeledEdit>;
  ButtonList: TList<TButton>;
  StringGridList: TList<TStringGrid>;
  RadioGroupList:TList<TRadioGroup>;

implementation

{ TObjects }

procedure TObjects.ButtonsCreate(AOwner: TForm; Count:integer);
var Button:TButton;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    Button:=TButton.create(AOwner);
    Button.Parent:= AOwner;
    Button.Height:=33;
    Button.Font.Name:=FontName;
    Button.Font.Size:=14;
    ButtonList.Add(Button);
  end;
end;
procedure TObjects.ButtonsParametrs(ProgName,Name: string; Count:integer);
var i:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+ButtonINI);
    for i := 0 to Count-1 do begin
      ButtonList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', ButtonList.Items[i].Left);
      ButtonList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', ButtonList.Items[i].Top);
      ButtonList.Items[i].Width := Ini.ReadInteger(Name + inttostr(i + 1), 'Width', ButtonList.Items[i].Width);
      ButtonList.Items[i].Caption := Ini.ReadString(Name + inttostr(i + 1), 'Caption', ButtonList.Items[i].Caption);
    end;
  finally
    Ini.Free;
  end;
end;


procedure TObjects.EditCreate(AOwner: TForm; Count:integer);
var Edit:TEdit;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    Edit:=TEdit.Create(AOwner);
    Edit.Parent:=AOwner;
    Edit.Font.Name:=FontName;
    Edit.MaxLength:=8;
    Edit.Text:='';
    Edit.Width:=92;
    Edit.Font.Size:=12;
    EditList.Add(Edit);
  end;
end;
procedure TObjects.EditParametrs(ProgName,Name: string; Count:integer);
var i:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+EditINI);
    for i := 0 to Count-1 do begin
      EditList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', EditList.Items[i].Left);
      EditList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', EditList.Items[i].Top);
      EditList.Items[i].Text:='';
      EditList.Items[i].OnChange:=Edit1Change;
      EditList.Items[i].OnKeyPress:=Edit1KeyPress;
    end;
  finally
    Ini.Free;
  end;
end;


procedure TObjects.LabeledEditCreate(AOwner: TForm; Count:integer);
var LabeledEdit:TLabeledEdit;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    LabeledEdit:= TLabeledEdit.create(AOwner);
    LabeledEdit.Parent:=AOwner;
    LabeledEdit.Font.Name:=FontName;
    LabeledEdit.EditLabel.Font.Name:=FontName;
    LabeledEdit.MaxLength:=14;
    LabeledEdit.Width:=92;
    LabeledEdit.Font.Size:=12;
    LabeledEdit.EditLabel.Font.Size:=12;
    LabeledEdit.LabelPosition:=lpLeft;
    LabeledEditList.Add(LabeledEdit);
  end;
end;
procedure TObjects.LabeledEditParametrs(ProgName,Name: string; Count:integer);
var i:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+LabeledEditINI);
    for i := 0 to Count-1 do begin
      LabeledEditList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', LabeledEditList.Items[i].Left);
      LabeledEditList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', LabeledEditList.Items[i].Top);
      LabeledEditList.Items[i].EditLabel.Caption := Ini.ReadString(Name + inttostr(i + 1), 'Caption', LabeledEditList.Items[i].EditLabel.Caption);
    end;
  finally
    Ini.Free;
  end;
end;


procedure TObjects.LabelsCreate(AOwner: TForm; Count:integer);
var Label_:TLabel;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    Label_:= TLabel.create(AOwner);
    Label_.Parent:=AOwner;
    Label_.Font.Name:=FontName;
    LabelsList.Add(Label_);
  end;
end;
procedure TObjects.LabelsParametrs(ProgName,Name: string; Count:integer);
var i:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+LabelsINI);
    for i := 0 to Count-1 do begin
      LabelsList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', LabelsList.Items[i].Left);
      LabelsList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', LabelsList.Items[i].Top);
      LabelsList.Items[i].Caption := Ini.ReadString(Name + inttostr(i + 1), 'Caption', LabelsList.Items[i].Caption);
      LabelsList.Items[i].Font.Size := Ini.ReadInteger(Name + inttostr(i + 1), 'FontSize', LabelsList.Items[i].Font.Size);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TObjects.StringGridsCreate(AOwner: TForm; Count:integer);
var StringGrid:TStringGrid;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    StringGrid:=TStringGrid.Create(AOwner);
    StringGrid.Parent:= AOwner;
    StringGrid.DrawingStyle:=gdsGradient;
    StringGrid.Font.Size:=14;
    StringGrid.Font.Name:=FontName;
    StringGridList.Add(StringGrid);
  end;
end;

procedure TObjects.StringGridsParametrs(ProgName,Name: string; Count:integer);
var i:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+StringGridINI);
    for i := 0 to Count-1 do begin
      StringGridList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', StringGridList.Items[i].Top);
      StringGridList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', StringGridList.Items[i].Left);
      StringGridList.Items[i].Height:=Ini.ReadInteger(Name + inttostr(i + 1), 'Height', StringGridList.Items[i].Height);
      StringGridList.Items[i].Width:=Ini.ReadInteger(Name + inttostr(i + 1), 'Width', StringGridList.Items[i].Width);
      StringGridList.Items[i].FixedCols:=Ini.ReadInteger(Name + inttostr(i + 1), 'FixedCols', StringGridList.Items[i].FixedCols);
      StringGridList.Items[i].FixedRows:=Ini.ReadInteger(Name + inttostr(i + 1), 'FixedRows', StringGridList.Items[i].FixedRows);
      StringGridList.Items[i].ColCount:=Ini.ReadInteger(Name + inttostr(i + 1), 'ColCount', StringGridList.Items[i].ColCount);
      StringGridList.Items[i].RowCount:=Ini.ReadInteger(Name + inttostr(i + 1), 'RowCount', StringGridList.Items[i].RowCount);
      StringGridList.Items[i].Visible:=Ini.ReadBool(Name + inttostr(i + 1), 'Visible', StringGridList.Items[i].Visible);
      StringGridList.Items[i].ColWidths[0]:=Ini.ReadInteger(Name + inttostr(i + 1), 'ColWidths0', StringGridList.Items[i].ColWidths[0]);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TObjects.StringGridsCells(ProgName, Name:string; Count:integer);
var i,j,k, Col, Row:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+StringGridINI);
    for i := 0 to Count-1 do begin
      Col:=Ini.ReadInteger(Name + inttostr(i + 1), 'Col', Col);
      Row:=Ini.ReadInteger(Name + inttostr(i + 1), 'Row', Row);
      for j := 0 to Col-1 do
        for k := 0 to Row-1 do
          StringGridList.Items[i].Cells[j,k]:=Ini.ReadString(Name + inttostr(i + 1), 'Cells'+IntToStr(j)+'_'+IntToStr(k), StringGridList.Items[i].Cells[j,k]);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TObjects.RadioGroupCreate(AOwner: TForm; Count: integer);
var RadioGroup:TRadioGroup;
    i:integer;
begin
  for i := 0 to Count-1 do begin
    RadioGroup:=TRadioGroup.Create(AOwner);
    RadioGroup.Parent:= AOwner;
    RadioGroup.Font.Size:=14;
    RadioGroup.Font.Name:=FontName;
    RadioGroupList.Add(RadioGroup);
  end;
end;

procedure TObjects.RadioGroupParametrs(ProgName,Name: string; Count:integer);
var i,j, CountR:integer;
begin
  try
    Ini := TIniFile.create(Constant.GetDirectory+ProgName+RadioGroupINI);
    for i := 0 to Count-1 do begin
      RadioGroupList.Items[i].Left := Ini.ReadInteger(Name + inttostr(i + 1), 'Left', RadioGroupList.Items[i].Left);
      RadioGroupList.Items[i].Top := Ini.ReadInteger(Name + inttostr(i + 1), 'Top', RadioGroupList.Items[i].Top);
      RadioGroupList.Items[i].Caption := Ini.ReadString(Name + inttostr(i + 1), 'Caption', RadioGroupList.Items[i].Caption);
      CountR:=Ini.ReadInteger(Name + inttostr(i + 1), 'CountR', CountR);
      for j:=0 to CountR-1 do
        RadioGroupList.Items[i].Items.Add(Ini.ReadString(Name + inttostr(i + 1), 'Items'+inttostr(j + 1), RadioGroupList.Items[i].Caption));
    end;
  finally
    Ini.Free;
  end;
end;


procedure TObjects.Edit1Change(Sender: TObject); //if Edit='', don't continue
var i:integer;
begin
  for i:= 0 to EditList.Count-1 do begin
    if EditList.Items[i].Text='' then ButtonList.Items[0].Enabled:=False
      else ButtonList.Items[0].Enabled:=True;
  end;
end;

procedure TObjects.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,',']) then Key:=#0; //only numbers
end;

end.

