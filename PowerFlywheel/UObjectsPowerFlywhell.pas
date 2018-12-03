unit UObjectsPowerFlywhell;

interface

uses Forms, UPowerFlywheel, UMainForm, UCreateMainForm,
      StdCtrls;

type

TObjectsPowerFlywhell = class (TPowerFlywheel)
  public
    constructor create(AOwner: TForm);
  private
    LabelOriginal:TLabel;
  end;

implementation

{ TCreateObjectsPowerFlywhell }

constructor TObjectsPowerFlywhell.create(AOwner: TForm);
begin
  LabelOriginal:=TLabel.create(AOwner);
  LabelOriginal.Left:=8;
  LabelOriginal.Caption:='¬ведите исходные данные';
end;

end.
