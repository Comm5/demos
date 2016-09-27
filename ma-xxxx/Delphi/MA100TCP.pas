unit MA100TCP;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdGlobal,
  IdTCPClient, DB, DBClient, ScktComp, Clipbrd; //MConnect,   SConnect,

type
  { Observe a criação de dois Arrays }
    TByteArr = array of byte;
    TStringArr = array of String;

  TForm1 = class(TForm)
    btnConectar: TButton;
    edIP: TEdit;
    Label1: TLabel;
    btnLerSensores: TButton;
    btnSensorAtivo: TButton;
    edtSensor: TEdit;
    Label2: TLabel;
    btnAbreRele: TButton;
    edRele: TEdit;
    Label3: TLabel;
    btnFechaRele: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Label4: TLabel;
    IdTCPClient1: TIdTCPClient;
    procedure btnConectarClick(Sender: TObject);
    procedure btnLerSensoresClick(Sender: TObject);
    procedure btnFechaReleClick(Sender: TObject);
    procedure btnAbreReleClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSensorAtivoClick(Sender: TObject);
  private
    procedure SetRele(Rele: string; estado: boolean);
    function EnviaComando(Cmd: String): String;
    function StrToByte(const Value: String): TIdBytes;
    function ByteToString(const Value: TIdBytes): String;


    { Private declarations }
  public
    lastSensorRead : Integer ;

    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnConectarClick(Sender: TObject);
Begin
// Tem que usar os componentes da Indy 10
// E Declara a seguintes Units na Use principal
// IdGlobal, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient

   IdTCPClient1.Host := edIP.Text; // edereço IP
   IdTCPClient1.Port := 5000 ;
   try
     IdTCPClient1.Connect();
     Memo1.Lines.Add('Conectado.');
   except
     on e:exception do
     begin
       Memo1.Lines.Add('Tentativa de conecatar falida.' + #13#10 + e.Message);
     end;
   end
 end;

function TForm1.StrToByte(const Value: String): TIdBytes;
var
    I: integer;
begin
    SetLength(Result, Length(Value));
    for I := 0 to Length(Value) - 1 do
        Result[I] := ord(Value[I + 1]);
end;

function TForm1.ByteToString(const Value: TIdBytes): String;
var
    I: integer;
    S : String;
    Letra: char;
begin
    S := '';
    for I := Length(Value)-1 Downto 0 do
    begin
        letra := Chr(Value[I]);
        S := letra + S;
    end;
    Result := S;
end;

Function TForm1.EnviaComando(Cmd:String):String;
var btyCmd, btyResp : TIdBytes;
 encoder : TIdBytes ; //TIdASCIIEncoding;
 strBuffer:string;
 j : Integer;
 s2 : string;
begin
  Memo1.Lines.Add('********************');
  if not IdTCPClient1.Connected then
    btnConectar.Click;
  IdTCPClient1.ReadTimeout := 1000;

 // encoder := TIdASCIIEncoding.Create;
  try
    Cmd := Cmd + #10; //#$A; // concatena a querbra de linha
    btyCmd := StrToByte(Cmd);//Encoder.GetBytes(Cmd);  // conver para bytes


    IdTCPClient1.IOHandler.Write(btyCmd, length(Cmd)); // envia para o equipamento
    Memo1.Lines.Add('Enviado: ' + Cmd );

    strBuffer := '';
    while ((pos('210', strBuffer) < 1) and   // Aguardando o Retorno
           (pos('200', strBuffer) < 1) and
           (pos('410', strBuffer) < 1)
          )  do
    begin
      IdTCPClient1.IOHandler.ReadBytes(btyResp, -1, False); // lê o retorno
      strBuffer := ByteToString(btyResp); // Encoder.GetString(btyResp); // converte para String
      s2 := '';
      for j := 0 to Length(btyResp)-1 do
        s2 := s2 + inttostr(btyResp[j]) + ',';
      if Trim(s2) <> '' then
        memo2.Lines.Add(s2);
    end;
    Memo1.Lines.add('Retorno: ' + strBuffer );
    if pos('210', strBuffer) >= 0 then
      result := copy(strBuffer, pos('210', strBuffer)+ 4, length(strBuffer)) ; // Desconsidera as 4 primeira posições.
  finally
    FreeAndNil(encoder);
  end;


end;
procedure TForm1.btnLerSensoresClick(Sender: TObject);
begin
  EnviaComando('query'); // envia o camando para ler sensores
end;

procedure TForm1.SetRele(Rele :string; estado: boolean);
begin
  if not IdTCPClient1.Connected then
    btnConectar.Click;
  if estado then
  begin
    EnviaComando( 'set ' + Rele  );  // envia o camando Abrir rele
  end
  else
  begin
    EnviaComando( 'reset ' + Rele ) ; // envia o camando Fechar rele
  end;



end;
procedure TForm1.btnFechaReleClick(Sender: TObject);
begin
   SetRele(edRele.Text, False); // envia o camando para o rele
end;

procedure TForm1.btnAbreReleClick(Sender: TObject);
begin
  SetRele(edRele.Text, True);  // envia o camando para o rele
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Clipboard.AsText := Memo2.Text;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IdTCPClient1.Disconnect;
end;

procedure TForm1.btnSensorAtivoClick(Sender: TObject);
var strResult : string;
    intSensor, intResult  : integer;
begin
  intSensor := StrToIntDef(edtSensor.Text, -1);
  if intSensor < 0 then
  begin
    ShowMessage('Informe um sensor valido');
    exit;
  end;
  strResult := copy(EnviaComando('query'), 1, 4);  // buscar Status dos Sensores
    intResult := StrToInt('$' + strResult); // convert retorno para inteiro

  if ((intResult and (1 shl intSensor)) <> 0) then // verifica se senso esta ativo    ((lastSensorRead & (1 << sensor)) != 0);
    Memo1.Lines.Add('Sensor '+ edtSensor.Text + ' Ativo' )
  else
    Memo1.Lines.Add('Sensor '+ edtSensor.Text + ' Inativo' );

end;

end.
