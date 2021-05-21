program Project1;

uses
  Vcl.Forms,
  UnitL in 'UnitL.pas' {Laba_2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TLFSR, LFSR);
  Application.Run;
end.
