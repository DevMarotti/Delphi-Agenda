program pAgendaDataSet;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  uAgenda in 'src\uAgenda.pas' {Form_Agenda};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Agenda, Form_Agenda);
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.Run;
end.
