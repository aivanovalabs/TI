unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TByteArray = array of Byte;
  TDSA = class(TForm)
    QNumber: TEdit;
    PNumber: TEdit;
    HNumber: TEdit;
    XNumber: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    YNumber: TEdit;
    Label5: TLabel;
    Calculate: TButton;
    GNumber: TEdit;
    Label6: TLabel;
    FileText: TMemo;
    Open: TButton;
    OpenF: TOpenDialog;
    generate: TButton;
    KNumber: TEdit;
    Label7: TLabel;
    hashtext: TEdit;
    Label8: TLabel;
    Save: TButton;
    sign: TEdit;
    SaveF: TSaveDialog;
    OpenCipher: TButton;
    Check: TButton;
    Label9: TLabel;
    sign1: TEdit;
    U1Number: TEdit;
    WNumber: TEdit;
    U2Number: TEdit;
    VNumber: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    NewHash: TEdit;
    procedure CalculateClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure generateClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure OpenCipherClick(Sender: TObject);
    procedure CheckClick(Sender: TObject);
    procedure QNumberChange(Sender: TObject);
    procedure gChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DSA: TDSA;
  ByteArray: TByteArray;
  ResArray, IntArray: array of Byte;
  RS: array of Integer;
  Size: Integer;

implementation

{$R *.dfm}

function PowerInModular(a, Num: Int64): Int64;
var
    pow, res, x: Int64;
begin
    pow := Num - 1;
    res := 1;
    x := a mod Num;
    while (pow > 0) do
    begin
        if (pow mod 2 = 1) then
            res := (res*x) mod Num;
        pow := pow shr 1;
        x := (x*x) mod Num;
    end;
    Result := res;
end;

function Power(a, P, Q: Int64): Int64;
var
    pow, res, x: Int64;
begin
    pow := (P - 1) div Q;;
    res := 1;
    x := a mod P;
    while (pow > 0) do
    begin
         if (pow mod 2 = 1) then
            res := (res*x) mod P;
         pow := pow shr 1;
         x := (x*x) mod P;
    end;
    Result := res;
end;

function PowerMod(G, XNum, P: Int64): Int64;
var
    pow, res, x: Int64;
begin
    pow := XNum;
    res := 1;
    x := G mod P;
    while (pow > 0) do
    begin
        if (pow mod 2 = 1) then
            res := (res*x) mod P;
        pow := pow shr 1;
        x := (x*x) mod P;
    end;
    Result := res;
end;

procedure TDSA.CalculateClick(Sender: TObject);
const
    a = 2;
var
    isCorrect: boolean;
    g, y: Int64;
begin
    isCorrect := true;
    if ((PowerInModular(a, StrToInt(QNumber.Text)) <> 1))then
    begin
        MessageDlg('Q ?? ???????? ??????? ??????'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if ((StrToInt(PNumber.Text) - 1) mod StrToInt(QNumber.Text) <> 0) then
    begin
        MessageDlg('Q ?? ???????? ????????? (P-1)'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if ((StrToInt(HNumber.Text) < 2) or (StrToInt(HNumber.Text) > StrToInt(PNumber.Text)) )then
    begin
        MessageDlg('h ?? ??????????? ????????? (1, p-1)'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if (power(StrToInt(HNumber.Text), StrToInt(PNumber.Text), StrToInt(QNumber.Text)) < 2) then
    begin
        MessageDlg('g ?????? ???? ?????? 1'+#13#10+'??????? ?????? ???????? h', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if ((StrToInt(XNumber.Text) < 1) or (StrToInt(XNumber.Text) > (StrToInt(QNumber.Text) - 1)) )then
    begin
        MessageDlg('X ?? ??????????? ????????? (0, q)'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if (isCorrect = True) then
    begin
          g := Power(StrToInt(HNumber.Text), StrToInt(PNumber.Text), StrToInt(QNumber.Text));
          GNumber.Text := IntToStr(g);
          y := PowerMod(StrToInt(GNumber.Text), StrToInt(XNumber.Text), StrToInt(PNumber.Text));
          YNumber.Text := IntToStr(y);
    end;
end;

function MakeHash(HashArray: TByteArray; Q: integer): Integer;
const
    H0 = 100;
var
    Size, i, temp, H: Integer;
begin
    temp := 0;
    H := H0;
    Size := Length(HashArray);
    for i := 0 to (Size - 1) do
    begin
        temp := H + HashArray[i];
        H := PowerMod(temp, 2, Q);
    end;
    Result := H;
end;


function CalculateR(g, k, p, q: Integer): Integer;
var
    Temp: Integer;
begin
     temp :=  PowerMod(g, k, p);
     Result := temp mod q;
end;


function CalculateS(k, hash, x, r, q: Integer): Integer;
var
    temp, power: Integer;
begin
    temp := (x*r + hash) mod q;
    power := q - 2;
    Result := (temp * PowerMod(k, power, q)) mod q;
end;

function CalculateW(s, q: Integer): Integer;
var
    temp, power: Integer;
begin
    power := q - 2;
    Result := PowerMod(s, power, q);
end;

function CalculateV(g, y, p, q, u1, u2: Integer): Integer;
var
    temp, temp1, temp2 : Integer;
begin
    temp := PowerMod(g, u1, p);
    temp1 := PowerMod(y, u2, p);
    temp2 := (temp*temp1) mod p;
    result := temp2 mod q;
end;


procedure TDSA.CheckClick(Sender: TObject);
var
  tempArray: TByteArray;
  i,j, r, s, hash, w, u1, u2, v: Integer;
begin
   if (length(PNumber.Text) <> 0)  and
                         (length(QNumber.Text) <> 0)  and
                         (length(YNumber.Text) <> 0)  and
                         (length(GNumber.Text) <> 0)  and
                         (OpenCipher.Enabled = True) then
   begin
      j := 0;
      while IntArray[j] <> 124 do
      begin
        inc(j);
      end;
      setlength(tempArray, j);
      i := 0;
      while IntArray[i] <> 124 do
      begin
          tempArray[i] := IntArray[i];
          inc(i);
      end;
      r := RS[0];
      s := RS[1];
      hash := MakeHash(TempArray, StrToInt(QNumber.Text));
      NewHash.Text := IntToStr(hash);
      w :=  CalculateW(s, StrToInt(QNumber.Text));
      WNumber.Text := IntToStr(w);
      u1 := (hash mod StrToInt(QNumber.Text))*(w mod StrToInt(QNumber.Text)) mod StrToInt(QNumber.Text);
      U1Number.Text := IntToStr(u1);
      u2 :=  (r mod StrToInt(QNumber.Text))*(w mod StrToInt(QNumber.Text)) mod StrToInt(QNumber.Text);
      U2Number.Text := IntToStr(u2);
      v := CalculateV(StrToInt(GNumber.Text),StrToInt(YNumber.Text), StrToInt(PNumber.Text), StrToInt(QNumber.Text), u1, u2);
      VNumber.Text := IntToStr(v);
      if (v = r) and (NewHash.Text = HashText.Text) then
          MessageDlg('??????? ?????????, ??? ??? v = r', mtInformation, [mbOk], 0)
      else
          MessageDlg('??????? ?? ?????????, ??? ??? v ?? ????? r', mtInformation, [mbOk], 0)
   end
   else
      MessageDlg('??? ???????? ??????? ?????????? ?????? ????????'+#13#10+'p, q, ? ????? ?????? ???? ????????? ???????? y, g'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);

end;

procedure TDSA.gChange(Sender: TObject);
begin
  Open.Enabled := (length(GNumber.Text) <> 0)  and
                  (length(YNumber.Text) <> 0);
end;

procedure TDSA.generateClick(Sender: TObject);
var
    Hash, r, s, temp, i: Integer;
    isCorrect: Boolean;
begin
    isCorrect := true;
    r := 0;
    s := 0;
    if ((StrToInt(KNumber.Text) < 1) or (StrToInt(KNumber.Text) > (StrToInt(QNumber.Text)- 1)) )then
    begin
        MessageDlg('K ?? ??????????? ????????? (0, q)'+#13#10+'????????? ???????', mtInformation, [mbOk], 0);
        isCorrect := false;
    end;
    if isCorrect = true then
    begin
        Hash := MakeHash(ByteArray, StrToINt(QNumber.Text));
        hashtext.Text := IntToStr(Hash);
        r := CalculateR(StrToInt(GNumber.Text),StrToInt(KNumber.Text), StrToInt(PNumber.Text), StrToInt(QNumber.Text));
        s := CalculateS(StrToInt(KNumber.Text), Hash, StrToInt(XNumber.Text), r, StrToInt(QNumber.Text));
    end;
    if r = 0 then
    begin
      isCorrect := false;
      MessageDlg(' r = 0 '+#13#10+'??????? ?????? ???????? k', mtInformation, [mbOk], 0);
    end;
     if s = 0 then
    begin
      isCorrect := false;
      MessageDlg(' s = 0 '+#13#10+'??????? ?????? ???????? k', mtInformation, [mbOk], 0);
    end;
    if isCorrect = true then
    begin
        sign.Text :=  IntToStr(r);
        sign1.Text :=  IntToStr(s);
    end;
end;

procedure TDSA.OpenCipherClick(Sender: TObject);
var
   CipherFile: File of Byte;
   TempF: TextFile;
    i, j, Size1: Integer;
    tempByte: byte;
   ByteStr, tex, temp: String;
begin
    SetLength(RS, 2);
    j := 0;
   if OpenF.Execute then
   begin
         AssignFile(CipherFile, OpenF.FileName);
         Reset(CipherFile);
         Size1 := FileSize(CipherFile);
         SetLength(IntArray, Size1);
         for i := 0 to Size1 - 1 do
         begin
              Read(CipherFile, TempByte);
              IntArray[i] := TempByte;
         end;
         CloseFile(CipherFile);
   end;
        byteStr := '';
         i := 0;
         while i < Size1 - 1 do
         begin
            if (IntArray[i] = 124) and (IntArray[i + 2] = 124) then
            begin
                i := i + 4;
                while IntArray[i] <> 32 do
                begin
                    byteStr := byteStr + Chr(IntArray[i]);
                    inc(i);
                end;
                inc(i);
                RS[0] := StrToInt(ByteStr);
                byteStr := '';
                while IntArray[i] <> 32 do
                begin
                    byteStr := byteStr + Chr(IntArray[i]);
                    inc(i);
                end;
                RS[1] := StrToInt(ByteStr);
                inc(i);
            end;
            inc(i);
         end;
end;

procedure TDSA.OpenClick(Sender: TObject);
const
   EmptyFileError = '??????, ???? ??????. ????????? ???????';
   High = 128;
var
   CipherFile: File of Byte;
   TempByte, i: Integer;
   ByteStr: String;
begin
   if OpenF.Execute then
   begin
         AssignFile(CipherFile, OpenF.FileName);
         Reset(CipherFile);
         Size := FileSize(CipherFile);

         SetLength(ByteArray, Size);
         for i := 0 to Size - 1 do
         begin
             BlockRead(CipherFile, TempByte, 1);
             ByteArray[i] := TempByte;
         end;
         CloseFile(CipherFile);

         ByteStr := '';
         for i := 0 to Size - 1 do
         begin
            ByteStr := ByteStr + IntToStr(ByteArray[i])+ ' ';
         end;
         FileText.Lines.Text := ByteStr;
   end;
   generate.Enabled := true;
end;



procedure TDSA.QNumberChange(Sender: TObject);
begin
    calculate.Enabled := (length(PNumber.Text) <> 0)  and
                         (length(QNumber.Text) <> 0)  and
                         (length(HNumber.Text) <> 0)  and
                         (length(XNumber.Text) <> 0)  and
                         (length(KNumber.Text) <> 0);
end;


procedure TDSA.SaveClick(Sender: TObject);
var
    MyFile: File of Byte;
    TempF: TextFile;
    i: Integer;
    tempByte: Integer;
    tem: string;
begin
    SetLength(ResArray, Length(ByteArray));
    for i := 0 to length(ByteArray)- 1 do
         ResArray[i] := ByteArray[i];
    if SaveF.Execute then
    begin
        AssignFile(MyFile, SaveF.FileName);
        rewrite(MyFile);
        for i := 0 to High(ResArray) do
        begin
            tempByte := ResArray[i];
            Write(MyFile, tempByte);
        end;
        closeFile(MyFile);
        AssignFile(TempF, SaveF.FileName);
        Append(TempF);
        tem := '||| ';
        Write(TempF, tem); //r
        tem := Sign.Text + ' ';
        Write(TempF, tem); //r
        tem := Sign1.Text + ' ';
        Write(TempF, tem);  //s
        CloseFile(TempF);

    end;
end;

end.
