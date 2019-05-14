program IndyTcpServer;

uses
  Vcl.Forms,
  FrServer in 'FrServer.pas' {FServer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFServer, FServer);
  Application.Run;
end.
