program IndyTcpClient;

uses
  Vcl.Forms,
  FrClient in 'FrClient.pas' {FClient};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFClient, FClient);
  Application.Run;
end.
