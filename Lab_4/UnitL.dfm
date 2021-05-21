object LFSR: TLFSR
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'LFSR'
  ClientHeight = 390
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 8
    Width = 150
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077'  '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1088#1077#1075#1080#1089#1090#1088#1072
  end
  object KeyL: TLabel
    Left = 176
    Top = 94
    Width = 122
    Height = 13
    Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1082#1083#1102#1095
  end
  object RegisterK: TEdit
    Left = 8
    Top = 27
    Width = 249
    Height = 21
    MaxLength = 26
    TabOrder = 0
    OnChange = RegisterKChange
    OnKeyPress = RegisterKKeyPress
  end
  object calculate: TButton
    Left = 8
    Top = 54
    Width = 249
    Height = 27
    Caption = #1079#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100'\ '#1088#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 1
    OnClick = calculateClick
  end
  object FileText: TMemo
    Left = 8
    Top = 120
    Width = 145
    Height = 257
    TabOrder = 2
  end
  object Cipher: TMemo
    Left = 311
    Top = 120
    Width = 145
    Height = 257
    Lines.Strings = (
      ''
      '')
    TabOrder = 3
  end
  object Open: TButton
    Left = 305
    Top = 8
    Width = 154
    Height = 34
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    TabOrder = 4
    OnClick = OpenClick
  end
  object Save: TButton
    Left = 305
    Top = 51
    Width = 154
    Height = 34
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083' '
    TabOrder = 5
    OnClick = SaveClick
  end
  object Memo1: TMemo
    Left = 160
    Top = 120
    Width = 145
    Height = 257
    TabOrder = 6
  end
  object OpenFile: TOpenDialog
    Left = 64
    Top = 88
  end
  object SaveF: TSaveDialog
    Left = 400
    Top = 96
  end
end
