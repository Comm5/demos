program MA1000TCP;

uses
  Forms,
  MA100TCP in 'MA100TCP.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
