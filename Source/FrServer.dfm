object FServer: TFServer
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tcp Server'
  ClientHeight = 311
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mmLog: TMemo
    Left = 0
    Top = 0
    Width = 457
    Height = 270
    Align = alClient
    Color = clNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Server')
    ParentFont = False
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 270
    Width = 457
    Height = 41
    Align = alBottom
    TabOrder = 1
    object lbClientConnected: TLabel
      Left = 16
      Top = 16
      Width = 89
      Height = 13
      Caption = 'Client Connected :'
    end
    object btnStartServer: TButton
      Left = 198
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Start Server'
      TabOrder = 0
      OnClick = btnStartServerClick
    end
    object btnStopServer: TButton
      Left = 279
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Stop Server'
      TabOrder = 1
      OnClick = btnStopServerClick
    end
    object btnClearLog: TButton
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clear Log'
      TabOrder = 2
      OnClick = btnClearLogClick
    end
  end
  object IdTCPServer: TIdTCPServer
    OnStatus = IdTCPServerStatus
    Bindings = <>
    DefaultPort = 0
    OnConnect = IdTCPServerConnect
    OnDisconnect = IdTCPServerDisconnect
    OnExecute = IdTCPServerExecute
    Left = 368
    Top = 195
  end
end
