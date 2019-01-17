unit UMainForm;

interface

uses
  Classes,  Forms,
  UObjects, UCreateMainForm;

type
  TForm1 = class(TForm)
    published
    constructor create(AOwner: TComponent); Override;
  end;

var
  Form1:TForm;

implementation

{$R *.dfm}


constructor TForm1.create(AOwner: TComponent);
begin
  inherited;
  fFileCreate := TCreateMainForm.create(self); //Создаем основные объекты формы
end;

end.
