program TeleBot;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  fastTelega.API in 'TAPI\fastTelega.API.pas',
  fastTelega.AvailableTypes in 'TAPI\fastTelega.AvailableTypes.pas',
  fastTelega.Bot in 'TAPI\fastTelega.Bot.pas',
  fastTelega.EventBroadcaster in 'TAPI\fastTelega.EventBroadcaster.pas',
  fastTelega.EventHandler in 'TAPI\fastTelega.EventHandler.pas',
  fastTelega.HttpClient in 'TAPI\fastTelega.HttpClient.pas',
  fastTelega.LongPoll in 'TAPI\fastTelega.LongPoll.pas',
  fastTelega.TypeParser in 'TAPI\fastTelega.TypeParser.pas',
  Unit2 in 'Unit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
