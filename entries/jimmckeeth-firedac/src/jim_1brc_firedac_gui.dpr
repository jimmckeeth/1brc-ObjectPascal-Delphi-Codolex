program jim_1brc_firedac_gui;

uses
  System.StartUpCopy,
  FMX.Forms,
  jim_1brc_firedac_form in 'jim_1brc_firedac_form.pas' {Form13};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm13, Form13);
  Application.Run;
end.
