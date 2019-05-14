object FClient: TFClient
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tcp Client'
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
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mmMsg: TMemo
    Left = 0
    Top = 0
    Width = 457
    Height = 73
    Align = alTop
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Message')
    ParentFont = False
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 73
    Width = 457
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = 143
    object btnConnect: TButton
      Left = 14
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object btnDisconnect: TButton
      Left = 103
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btnDisconnectClick
    end
    object btnSendMsg: TButton
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 2
      OnClick = btnSendMsgClick
    end
  end
  object mmLog: TMemo
    Left = 0
    Top = 114
    Width = 457
    Height = 197
    Align = alClient
    BevelInner = bvLowered
    Color = clNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Server')
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 168
    ExplicitHeight = 143
  end
  object IdTCPClient: TIdTCPClient
    OnDisconnected = IdTCPClientDisconnected
    OnConnected = IdTCPClientConnected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 368
    Top = 248
  end
  object IdThreadComponent: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpNormal
    StopMode = smTerminate
    OnRun = IdThreadComponentRun
    Left = 264
    Top = 248
  end
end
