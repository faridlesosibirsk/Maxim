unit Bearings;

interface

uses
  SysUtils, Forms, StdCtrls, Generics.Collections, Math, Vcl.Grids,
  UObjects, UConstants;

type
  TBearings = class(TObjects)
  public
    constructor create(AOwner: TForm);
    procedure destroy; override;
  end;

implementation

{ TBearings }

constructor TBearings.create(AOwner: TForm);
begin
  //
end;

procedure TBearings.destroy;
begin
  //

end;

end.
