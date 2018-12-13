unit UFrameSaws;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs, IniFiles,
  Generics.Collections, Math, UInterface, Vcl.Grids, WinProcs;

type
  TFrameSaws = class(TInterfacedObject, TInterfaceMenuCreate)
  private
    fFileCreate: TInterfaceMenuCreate;
  public
    constructor create(AOwner: TForm);
    procedure destroy;
  end;

var
  A1:array[1..2,1..10] of real;

implementation

{ TFrameSaws }

constructor TFrameSaws.create(AOwner: TForm);
begin
  //
end;

procedure TFrameSaws.destroy;
begin
  //
end;

end.
