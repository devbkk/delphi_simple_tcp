unit FrServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdContext;

type
  TFServer = class(TForm)
    mmLog: TMemo;
    pnlButtons: TPanel;
    btnStartServer: TButton;
    btnStopServer: TButton;
    btnClearLog: TButton;
    lbClientConnected: TLabel;
    IdTCPServer: TIdTCPServer;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure IdTCPServerConnect(AContext: TIdContext);
    procedure IdTCPServerDisconnect(AContext: TIdContext);
    procedure IdTCPServerExecute(AContext: TIdContext);
    procedure IdTCPServerStatus(ASender: TObject;
                                const AStatus: TIdStatus;
                                const AStatusText: string);

    procedure btnStartServerClick(Sender: TObject);
    procedure btnStopServerClick(Sender: TObject);
    procedure btnClearLogClick(Sender: TObject);
  private
    { Private declarations }
    function  NowText :String;
    function  W2Str(const AWord :Word) :String;
    procedure BroadCaseMessage(AMsg :String);
    procedure ClientCount(IsDisconnected :Boolean = False);
    procedure DisplayLog(ASender, AMsg :String);
  public
    { Public declarations }
  end;

var
  FServer: TFServer;

implementation

const c_client_connected = 'Client Connected : %S';
      c_client_port      = 20010;

{$R *.dfm}

procedure TFServer.btnClearLogClick(Sender: TObject);
begin
  mmLog.Lines.Clear;
end;

procedure TFServer.btnStartServerClick(Sender: TObject);
begin
  IdTCPServer.Bindings.Clear;
  IdTCPServer.Bindings.Add.Port := c_client_port;
  IdTCPServer.Active            := True;

  btnStartServer.Enabled        := False;
  btnStopServer.Enabled         := True;

  DisplayLog('Server','Started');
end;

procedure TFServer.btnStopServerClick(Sender: TObject);
begin
  BroadCaseMessage('Goodbye Client ');

  IdTCPServer.Active := False;

  btnStopServer.Enabled  := False;
  btnStartServer.Enabled := True;
  DisplayLog('Server', 'Stopped');
end;

procedure TFServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TFServer.FormCreate(Sender: TObject);
begin
  IdTCPServer.Active         := False;
  IdTcpServer.MaxConnections := 20;
end;

procedure TFServer.FormShow(Sender: TObject);
begin

  mmLog.Lines.Clear;

  lbClientConnected.Caption := Format(c_client_connected,['0']);

  btnStartServer.Enabled := True;
  btnStopServer.Enabled  := False;
end;

procedure TFServer.IdTCPServerConnect(AContext: TIdContext);

var   sClientType, sMsgToClient : String;

const c_connect_desc   = 'Port=%S IP=%S PeerPort=%S PeerIP=%S';
      c_welcome_client = 'Welcome %S Client';

begin
  //
  DisplayLog('Server','Client Connected!');
  DisplayLog('Server', Format(c_connect_desc,[W2Str(AContext.Binding.Port),
                                              AContext.Binding.IP,
                                              W2Str(AContext.Binding.PeerPort),
                                              AContext.Binding.PeerIP]));
  //
  ClientCount();

  sClientType := '';
  if  AContext.Binding.Port = c_client_port then
    sClientType := 'Guest';

  sMsgToClient := Format(c_welcome_client, [sClientType]);
end;

procedure TFServer.IdTCPServerDisconnect(AContext: TIdContext);

const c_connect_desc   = 'Client Disconnected! Peer=%S : PeerPort=%S';

begin
  //
  DisplayLog('Server',Format(c_connect_desc,[AContext.Binding.PeerIP,
                                             W2Str(AContext.Binding.PeerPort)]));
  //
  ClientCount(True);
end;

procedure TFServer.IdTCPServerExecute(AContext: TIdContext);

var   MsgFromClient, MsgToClient : String;
      PeerIP :String; PeerPort :Integer;

const ALogFormat = '(Peer = %S : %S) %S';

begin
  MsgFromClient := AContext.Connection.IOHandler.ReadLn();
  //
  PeerIP   := AContext.Binding.PeerIP;
  PeerPort := AContext.Binding.PeerPort;
  //
  DisplayLog('Client',Format(ALogFormat,[PeerIP,IntToStr(PeerPort),MsgFromClient]));
  //
  AContext.Connection.IOHandler.WriteLn('...Message Sent From Server');
end;

procedure TFServer.IdTCPServerStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  DisplayLog('Server', AStatusText);
end;

{private}
function TFServer.NowText: String;
begin
  Result :=  FormatDateTime('yyyy-MM-dd hh:nn:ss ',Now)
end;

function TFServer.W2Str(const AWord: Word): String;
var aInt :Integer;
begin
  aInt := AWord;
  Result := IntToStr(aInt);
end;

procedure TFServer.BroadCaseMessage(AMsg: String);
var tmpList       : TList;
    contextClient : TIdContext;
    nClients      : Integer;
    i             : Integer;
begin
  tmpList := IdTCPServer.Contexts.LockList;
  try
    i := 0;
    while (i < tmpList.Count) do begin
      contextClient := tmpList[i];
      contextClient.Connection.IOHandler.WriteLn(AMsg);
      i := i + 1;
    end;
  finally
    IdTCPServer.Contexts.UnlockList;
  end;
end;

procedure TFServer.ClientCount(IsDisconnected :Boolean);
var   nClients : Integer;
const c_client_count = 'Client Connected :%S';
begin
  try
    nClients := IdTCPServer.Contexts.LockList.Count;
  finally
    IdTCPServer.Contexts.UnlockList;
  end;


  if IsDisconnected then
    Dec(nClients);


  TThread.Queue(nil, procedure
                     begin
                       lbClientConnected.Caption :=  Format(c_client_count,[IntToStr(nClients)]);
                     end);
end;

procedure TFServer.DisplayLog(ASender, AMsg: String);
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
