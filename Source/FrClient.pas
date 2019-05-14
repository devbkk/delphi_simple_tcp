unit FrClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdThreadComponent, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  TFClient = class(TForm)
    mmMsg: TMemo;
    mmLog: TMemo;
    //
    pnlButtons: TPanel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnSendMsg: TButton;
    IdTCPClient: TIdTCPClient;
    IdThreadComponent: TIdThreadComponent;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSendMsgClick(Sender: TObject);
    //
    procedure IdTCPClientConnected(Sender: TObject);
    procedure IdTCPClientDisconnected(Sender: TObject);
    procedure IdThreadComponentRun(Sender: TIdThreadComponent);

  private
    { Private declarations }
    function  NowText :String;
    procedure DisplayLog(ASender, AMsg :String);
  public
    { Public declarations }
  end;

var
  FClient: TFClient;

implementation

const c_client_port      = 20010;

{$R *.dfm}

{ TFClient }

{controls event}
procedure TFClient.FormCreate(Sender: TObject);
begin
   IdTCPClient.Host := 'localhost';
   IdTCPClient.Port := c_client_port;
end;

procedure TFClient.FormShow(Sender: TObject);
begin
  mmMsg.Clear;
  mmMsg.Enabled := False;

  mmLog.Clear;
  btnConnect.Enabled    := True;
  btnDisconnect.Enabled := False;
  btnSendMsg.Enabled    := False;
end;

procedure TFClient.btnConnectClick(Sender: TObject);
const ConnectErrFormat = 'Connection Error! %S';
begin
  btnConnect.Enabled := False;

  try
    IdTCPClient.Connect;
  except
    on E: Exception do begin
      DisplayLog('Client',Format(ConnectErrFormat,[E.Message]));
      btnConnect.Enabled := True;
    end;
  end;
end;

procedure TFClient.btnDisconnectClick(Sender: TObject);
begin
  if IdTCPClient.Connected then begin
    IdTCPClient.Disconnect;
    //
    btnConnect.Enabled    := True;
    btnDisconnect.Enabled := False;
    btnSendMsg.Enabled    := False;
    //
    mmMsg.Enabled         := False;
  end;
end;

procedure TFClient.btnSendMsgClick(Sender: TObject);
begin
  IdTCPClient.IOHandler.WriteLn(mmMsg.Text);
end;

procedure TFClient.IdTCPClientConnected(Sender: TObject);
begin
  DisplayLog('Client','Connected!');

  IdThreadComponent.Active := True;

  btnConnect.Enabled    := False;
  btnDisconnect.Enabled := True;
  btnSendMsg.Enabled    := True;

  mmMsg.Enabled         := True;
end;

procedure TFClient.IdTCPClientDisconnected(Sender: TObject);
begin
  DisplayLog('Client','Disconnected!');
end;

procedure TFClient.IdThreadComponentRun(Sender: TIdThreadComponent);
var ServerMsg : String;
begin
  ServerMsg := IdTCPClient.IOHandler.ReadLn();
  DisplayLog('Server',ServerMsg);
end;

{private}
function TFClient.NowText: String;
begin
  Result :=  FormatDateTime('yyyy-MM-dd hh:nn:ss ',Now)
end;

procedure TFClient.DisplayLog(ASender, AMsg: String);
begin
//
  TThread.Queue(nil, procedure
                     begin
                       mmLog.Lines.Add('['+ASender+'] - ' +
                                       NowText +
                                       AMsg);
                     end
                     );

end;

end.
