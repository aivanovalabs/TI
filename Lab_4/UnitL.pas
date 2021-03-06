unit UnitL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TLFSR = class(TForm)
    Label1: TLabel;
    calculate: TButton;
    FileText: TMemo;
    Cipher: TMemo;
    KeyL: TLabel;
    Open: TButton;
    Save: TButton;
    OpenFile: TOpenDialog;
    SaveF: TSaveDialog;
    RegisterK: TEdit;
    Memo1: TMemo;
    procedure OpenClick(Sender: TObject);
    procedure KeyGeneration;
    procedure calculateClick(Sender: TObject);
    procedure RegisterKChange(Sender: TObject);
    procedure RegisterKKeyPress(Sender: TObject; var Key: Char);
    procedure xorrr;
    procedure SaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
    High = 128;
var
  LFSR: TLFSR;
  Size: Integer;
  Key, ByteStr, ResStr: String;

implementation

uses
    Math;
{$R *.dfm}

function IntToBin(Number: Integer): string;
const
    bin = 2;
    amount = 8;
var
    BinStr: string;
    count, i: Integer;
begin
    BinStr := '';
    Count := 0;
    while (Number <> 0) do
    begin
        BinStr := IntToStr(Number mod bin) + BinStr;
        Number := Number div bin;
        inc(Count);
    end;
    if (Count < amount) then
    begin
        for i := 1 to (amount - count) do
           BinStr := '0' + BinStr;
    end;
    Result := BinStr;
end;

function StrToNum(Str: String): Integer;
var
    sum, i, Num: integer;
    n: real;
begin
    sum := 0;
    for i := 1 to length(str) do
    begin
        if str[i] <> '0' then
        begin
            N := power(2, length(str)- i );
            Num := round(N);
            Sum := sum + Num;
        end;
    end;
    result := sum;
end;

procedure TLFSR.OpenClick(Sender: TObject);
const
   EmptyFileError = '??????, ???? ??????. ????????? ???????';
   High = 128;
var
   CipherFile: File of Byte;
   ByteArray: array of Byte;
   TempByte, i: Integer;
   OutStr: String;
begin
   if OpenFile.Execute then
   begin
         AssignFile(CipherFile, OpenFile.FileName);
         Reset(CipherFile);
         if Eof(CipherFile) then
         begin
            MessageDlg(EmptyFileError, mtError, [mbRetry], 0);
         end;
         Size := FileSize(CipherFile);
         SetLength(byteArray, Size);
         ByteStr := '';
         for i := 0 to Size - 1 do
         begin
             BlockRead(CipherFile, TempByte, 1);
             ByteArray[i] := TempByte;
         end;
         CloseFile(CipherFile);
         ByteStr := '';
         for i := 0 to Size - 1 do
         begin
            ByteStr := ByteStr + IntToBin(ByteArray[i]);
         end;
         outStr := '';
         for i := 1 to High do
         begin
            OutStr := OutStr + ByteStr[i];
         end;
         FileText.Lines.Text := OutStr;
   end;
end;

procedure TLFSR.RegisterKChange(Sender: TObject);
begin
    Calculate.Enabled := Length(RegisterK.Text) = 26;
end;

procedure TLFSR.RegisterKKeyPress(Sender: TObject; var Key: Char);
var
    Numb: Set of Char;
begin
    Numb := ['0','1', #8];
    if not(Key in Numb) then
        Key := #0;
end;

procedure TLFSR.SaveClick(Sender: TObject);
var
    MyFile: File of Byte;
    i: Integer;
    tempByte: Integer;
    tempStr: string;
    j, count: Integer;
    ResArray: array of byte;
begin
    i := 1;
    TempStr := '';
    count := 0;
    setLength(ResArray, Size);
    while (i < length(ResStr)) do
    begin
        for j := 0 to 7 do
        begin
            TempStr := Tempstr + ResStr[i];
            inc(i);
        end;
          ResArray[count] := StrToNum(TempStr);
        tempStr := '';
        inc(count);
    end;
    if SaveF.Execute then
    begin
        AssignFile(MyFile, SaveF.FileName);
        rewrite(MyFile);
        for i := 0 to size - 1 do
        begin
            tempByte := ResArray[i];
            blockWrite(MyFile, tempByte, 1);
        end;
        closeFile(MyFile);
    end;
end;

procedure TLFSR.calculateClick(Sender: TObject);
begin
    if length(FileText.Lines.Text) <> 0 then
    begin
    KeyGeneration;
    xorrr;
    end;
end;

procedure TLFSR.KeyGeneration;
const
    Num1 = 1;
    Num2 = 7;
    Num3 = 8;
    MaxNumb = 26;
    Mask = 33554431;//01111111111111111111111111
    bin = 2;
    High = 128;
var
    i, bit: Integer;
    outstr: String;
    Number: Integer;
begin
    Number := StrToNum(RegisterK.Text);
    Key  := '';
    for i := 0 to (Size * 8)- 1  do
    begin
        bit := ((Number shr (MaxNumb - 1)) and 1) xor ((Number shr (Num1 - 1)) and 1) xor ((Number shr (Num2 - 1)) and 1) xor ((Number shr (Num3 - 1)) and 1);
        Key := Key + IntToStr((Number shr (MaxNumb - 1)) and 1) ;
        Number := ((Number and Mask) shl 1) xor bit; // ????????? ???????? ????,
        //????? ????? ? ??????????? ???????? ???????? bit
    end;
// output
    outStr := '';
    for i := 1 to High do
    begin
       OutStr := OutStr + Key[i];
    end;
    Memo1.Lines.Text :=  OutStr;
end;

procedure TLFSR.xorrr();
const
    High = 128;
var
    OutStr: String;
    i: Integer;
begin
    ResStr := '';
    for i := 1 to Size*8 do
    begin
      ResStr := ResStr + IntToStr(StrToInt(ByteStr[i]) xor StrToInt(Key[i]));
    end;
    outStr := '';
    for i := 1 to High do
    begin
      OutStr := OutStr + ResStr[i];
    end;
    Cipher.Lines.Text :=  OutStr;
end;
end.
