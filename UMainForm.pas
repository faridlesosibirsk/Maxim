unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls, ActnMenus, Menus,
  Data.DB, Data.Win.ADODB, Contnrs, Generics.Collections, UObjects, UCreateMainForm,
             Vcl.ExtCtrls;

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
  fFileCreate := TCreateMainForm.create(self); //������� �������� ������� �����
end;

end.
