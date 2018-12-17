unit UFrameSaws;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, Menus, Data.DB, Data.Win.ADODB, Contnrs, IniFiles,
  Generics.Collections, Math, Vcl.Grids, WinProcs,
  UInterface,UParametrsObjects,UCreateObjects;

type
  TFrameSaws = class(TInterfacedObject, TInterfaceMenuCreate)
  private
    /// <link>aggregation</link>
    fFileCreate: TInterfaceMenuCreate;
    ObjCreate: TCreateObjects;
    //ObjParametrs: TParametrsObjects;

    {Label1, Label2:TLabel;
    Edit1, Edit2:TEdit;}
    StartButton, BackButton: TButton;
  public
    constructor create(AOwner: TForm);
    procedure destroy;
    procedure BackButtonClick(Sender:TObject);
    procedure Start1ButtonClick(Sender:TObject);
  end;

var
  A1:array[1..2,1..10] of real;



implementation

uses UMainForm, UCreateMainForm;

{ TFrameSaws }

constructor TFrameSaws.create(AOwner: TForm);
begin
  ObjCreate.ButtonsCreate(AOwner, StartButton, 178, 330, 177, 'Выполнить', True);
  StartButton.OnClick:=Start1ButtonClick;
  ObjCreate.ButtonsCreate(AOwner, BackButton, 178, 8, 177, 'К выбору программ', True);
  BackButton.OnClick:=BackButtonClick;
end;

procedure TFrameSaws.destroy;
begin
  StartButton.Free;
  BackButton.Free;
end;

procedure TFrameSaws.Start1ButtonClick(Sender: TObject);
begin
  //
end;

procedure TFrameSaws.BackButtonClick(Sender: TObject);
begin
  destroy;
  fFileCreate := TCreateMainForm.create(Form1);
end;

end.
