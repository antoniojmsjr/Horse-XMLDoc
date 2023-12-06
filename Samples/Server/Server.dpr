program Server;

{$APPTYPE CONSOLE}
{$R *.res}
{$R *.dres}

uses
  System.SysUtils,
  Horse,
  Horse.XMLDoc,
  Xml.XMLDoc,
  Server.Routes in 'Server.Routes.pas';

begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse
    .Use(THorseXMLDoc.New.Intercept);
  THorse.Routes.Prefix('horse-xmldoc');

  THorse.Get('ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Get('exemplo1', Exemplo1);
  THorse.Get('exemplo2', Exemplo2);
  THorse.Post('exemplo3', Exemplo3);
  THorse.Get('exemplo4', Exemplo4);

  THorse.Listen(9000,
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
      Readln;
    end);
end.
