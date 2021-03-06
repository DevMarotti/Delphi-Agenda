unit uAgenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient, Vcl.Mask, Vcl.DBCtrls;

type
  TForm_Agenda = class(TForm)
    DS_Agenda: TDataSource;
    CDS_Agenda: TClientDataSet;
    CDS_AgendaNome: TStringField;
    CDS_AgendaEmail: TStringField;
    CDS_AgendaTelefone: TStringField;
    CDS_AgendaNascimento: TDateField;
    GroupBox_Contato: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button_Novo: TButton;
    Button_Salvar: TButton;
    Button_Excluir: TButton;
    DBEdit_Nome: TDBEdit;
    DBEdit_Email: TDBEdit;
    DBEdit_Nascimento: TDBEdit;
    DBEdit_Telefone: TDBEdit;
    Button_Cancelar: TButton;
    Button_Editar: TButton;
    GroupBox_Pesquisa: TGroupBox;
    DBGrid_Agenda: TDBGrid;
    Edit_Pesquisa: TEdit;
    Label5: TLabel;
    procedure Button_SalvarClick(Sender: TObject);
    procedure Button_NovoClick(Sender: TObject);
    procedure Button_CancelarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid_AgendaCellClick(Column: TColumn);
    procedure Button_EditarClick(Sender: TObject);
    procedure CDS_AgendaAfterEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit_PesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button_ExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Agenda: TForm_Agenda;

implementation

{$R *.dfm}

procedure TForm_Agenda.Button_NovoClick(Sender: TObject);
begin
  // Campos
  DBEdit_Nome.Enabled       := True;
  DBEdit_Email.Enabled      := True;
  DBEdit_Telefone.Enabled   := True;
  DBEdit_Nascimento.Enabled := True;

  // Bot?es
  Button_Novo.Enabled     := False;
  Button_Salvar.Enabled   := True;
  Button_Excluir.Enabled  := False;
  Button_Editar.Enabled   := False;
  Button_Cancelar.Enabled := True;

  DS_Agenda.DataSet.Cancel;
  DS_Agenda.DataSet.Append; // ou Insert (fim da tabela)
  DBEdit_Nome.SetFocus;
end;

procedure TForm_Agenda.Button_SalvarClick(Sender: TObject);
begin
  if DS_Agenda.State in dsEditModes then
  begin
    DS_Agenda.DataSet.Post;
    DS_Agenda.DataSet.Cancel;

    // Campos
    DBEdit_Nome.Enabled       := False;
    DBEdit_Email.Enabled      := False;
    DBEdit_Telefone.Enabled   := False;
    DBEdit_Nascimento.Enabled := False;

    // Bot?es
    Button_Novo.Enabled     := True;
    Button_Salvar.Enabled   := False;
    Button_Excluir.Enabled  := False;
    Button_Cancelar.Enabled := False;
    Button_Editar.Enabled   := False;

    DBGrid_Agenda.SetFocus;
  end;
end;

procedure TForm_Agenda.Button_CancelarClick(Sender: TObject);
begin
  DS_Agenda.DataSet.Cancel;

  // Campos
  DBEdit_Nome.Enabled       := False;
  DBEdit_Email.Enabled      := False;
  DBEdit_Telefone.Enabled   := False;
  DBEdit_Nascimento.Enabled := False;

  // Bot?es
  Button_Novo.Enabled     := True;
  Button_Salvar.Enabled   := False;
  Button_Excluir.Enabled  := False;
  Button_Cancelar.Enabled := False;
  Button_Editar.Enabled   := False;

  DBGrid_Agenda.SetFocus;
end;

procedure TForm_Agenda.Button_EditarClick(Sender: TObject);
begin
    // Campos
    DBEdit_Nome.Enabled       := True;
    DBEdit_Email.Enabled      := True;
    DBEdit_Telefone.Enabled   := True;
    DBEdit_Nascimento.Enabled := True;

    // Bot?es
    Button_Novo.Enabled     := False;
    Button_Salvar.Enabled   := True;
    Button_Excluir.Enabled  := False;
    Button_Cancelar.Enabled := True;
    Button_Editar.Enabled   := False;

    DBEdit_Nome.SetFocus;
end;



procedure TForm_Agenda.Button_ExcluirClick(Sender: TObject);
begin
  if  MessageDlg('Voc? tem certeza que deseja excluir o registro?',mtConfirmation,[mbYes,mbNo],0) = mrYes  then
  begin
    Button_Excluir.Enabled  := False;
    Button_Editar.Enabled := False;

    CDS_Agenda.Delete;
  end;

  DBGrid_Agenda.SetFocus;
end;

procedure TForm_Agenda.CDS_AgendaAfterEdit(DataSet: TDataSet);
begin
  if DS_Agenda.State in [dsEdit] then
    Button_Salvar.Enabled   := True;
end;

procedure TForm_Agenda.DBGrid_AgendaCellClick(Column: TColumn);
begin
  DS_Agenda.DataSet.Cancel;

  // Bot?es
  Button_Novo.Enabled     := True;
  Button_Salvar.Enabled   := False;
  Button_Excluir.Enabled  := True;
  Button_Cancelar.Enabled := False;
  Button_Editar.Enabled   := True;
end;



procedure TForm_Agenda.Edit_PesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_RETURN then
  begin
    CDS_Agenda.Filter   := 'Nome LIKE' + QuotedStr(Edit_Pesquisa.Text + '%');
    CDS_Agenda.Filtered := True;

    DBGrid_Agenda.SetFocus;
  end;

end;

procedure TForm_Agenda.FormCreate(Sender: TObject);
begin
  DS_Agenda.DataSet.Open;
end;

procedure TForm_Agenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DS_Agenda.DataSet.Close;
end;

procedure TForm_Agenda.FormActivate(Sender: TObject);
begin
  // Campos
  DBEdit_Nome.Enabled       := False;
  DBEdit_Email.Enabled      := False;
  DBEdit_Telefone.Enabled   := False;
  DBEdit_Nascimento.Enabled := False;

  // Bot?es
  Button_Novo.Enabled     := True;
  Button_Salvar.Enabled   := False;
  Button_Excluir.Enabled  := False;
  Button_Cancelar.Enabled := False;
  Button_Editar.Enabled   := False;

  Button_Novo.SetFocus;
end;


end.
