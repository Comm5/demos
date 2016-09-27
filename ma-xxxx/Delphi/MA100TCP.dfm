object Form1: TForm1
  Left = 338
  Top = 152
  Caption = 'Form1'
  ClientHeight = 297
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 19
    Width = 13
    Height = 13
    Caption = 'IP '
  end
  object Label2: TLabel
    Left = 16
    Top = 240
    Width = 47
    Height = 13
    Caption = 'Nr Sensor'
  end
  object Label3: TLabel
    Left = 352
    Top = 241
    Width = 22
    Height = 13
    Caption = 'Rele'
  end
  object Label4: TLabel
    Left = 408
    Top = 8
    Width = 35
    Height = 27
    Caption = '#10'
    Font.Charset = OEM_CHARSET
    Font.Color = clMaroon
    Font.Height = -24
    Font.Name = 'Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnConectar: TButton
    Left = 184
    Top = 7
    Width = 91
    Height = 25
    Caption = 'Conectar'
    TabOrder = 0
    OnClick = btnConectarClick
  end
  object edIP: TEdit
    Left = 32
    Top = 11
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '192.168.156.53'
  end
  object btnLerSensores: TButton
    Left = 296
    Top = 7
    Width = 91
    Height = 25
    Caption = 'Ler Sensores'
    TabOrder = 2
    OnClick = btnLerSensoresClick
  end
  object btnSensorAtivo: TButton
    Left = 208
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Sensor Ativo'
    TabOrder = 3
    OnClick = btnSensorAtivoClick
  end
  object edtSensor: TEdit
    Left = 72
    Top = 232
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '2'
  end
  object btnAbreRele: TButton
    Left = 520
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Abre Rele'
    TabOrder = 5
    OnClick = btnAbreReleClick
  end
  object edRele: TEdit
    Left = 384
    Top = 233
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '2'
  end
  object btnFechaRele: TButton
    Left = 520
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Fecha Rele'
    TabOrder = 7
    OnClick = btnFechaReleClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 40
    Width = 257
    Height = 174
    TabOrder = 8
  end
  object Memo2: TMemo
    Left = 280
    Top = 40
    Width = 481
    Height = 174
    TabOrder = 9
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 160
    Top = 128
  end
end
