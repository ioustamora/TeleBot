unit Unit2;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, fastTelega.API,
  fastTelega.Bot, fastTelega.EventBroadcaster, fastTelega.LongPoll,
  fastTelega.AvailableTypes, Unit1;

type
  TBotThread = class(TThread)
  private
    { Déclarations privées }
  protected
    procedure Execute; override;
  Public
    procedure Stop;
  end;

var
  Bot: TftBot;
  LongPoll: TftLongPoll;
  Response: String;
  KeyboardOneCol: TftReplyKeyboardMarkup;
  strArray: TArray<string>;
  KeyboardWithLayout: TftReplyKeyboardMarkup;

implementation

{ TBotThread }

procedure TBotThread.Stop;
begin
  Terminate;
  WaitFor;
end;

procedure OneColumnKeyboard(ButtonStrings: TArray<String>;
  Kb: TftReplyKeyboardMarkup);
var
  I: Integer;
  Row: TList<TftKeyboardButton>;
  Button: TftKeyboardButton;
begin
  for I := 0 to Length(ButtonStrings) - 1 do
  begin
    Row := TList<TftKeyboardButton>.Create;
    Button := TftKeyboardButton.Create(ButtonStrings[I]);
    Row.Add(Button);
    Kb.Keyboard.Add(Row);
  end;
end;

procedure Keyboard(ButtonLayout: TArray<TArray<String>>;
  Kb: TftReplyKeyboardMarkup);
var
  I, J: Integer;
  Row: TList<TftKeyboardButton>;
  Button: TftKeyboardButton;
begin
  for I := 0 to Length(ButtonLayout) - 1 do
  begin
    Row := TList<TftKeyboardButton>.Create;
    for J := 0 to Length(ButtonLayout[I]) - 1 do
    begin
      Button := TftKeyboardButton.Create(ButtonLayout[I][J]);
      Row.Add(Button);
    end;
    Kb.Keyboard.Add(Row);
  end;
end;

procedure TBotThread.Execute;
begin
  FreeOnTerminate:=True;
  while not Terminated do begin
  try
    Bot := TftBot.Create(Form1.Edit1.Text, 'https://api.telegram.org');

    KeyboardOneCol := TftReplyKeyboardMarkup.Create;
    strArray := ['Option 1', 'Option 2', 'Option 3'];
    OneColumnKeyboard(strArray, KeyboardOneCol);

    KeyboardWithLayout := TftReplyKeyboardMarkup.Create;
    Keyboard([['Dog', 'Cat', 'Mouse'], ['Green', 'White', 'Red'], ['On', 'Off'],
      ['Back'], ['Info', 'About', 'Map', 'Etc']], KeyboardWithLayout);

    Bot.Events.OnUnknownCommand(
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo3.Lines.Text
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(TftMessage(FTMessage).Chat.id.ToString + ': any user command');
          end);
      end);

    Bot.Events.OnCommand('start',
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo2.Text,
          false,
          0,
          KeyboardOneCol,
          'Markdown'
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': start command : ' + TftMessage(FTMessage).text
            );
          end);
      end);

    Bot.Events.OnCommand('stop',
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo4.Text
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': stop cmd : '
            );
          end);
      end);

    Bot.Events.OnCommand('info',
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo7.Lines.Text,
          false,
          0,
          KeyboardWithLayout,
          'Markdown'
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': info cmd : '
            );
          end);
      end);

    Bot.Events.OnCommand('order',
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo6.Lines.Text
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': order cmd : '
            );
          end);
      end);

    Bot.Events.OnCommand('help',
      procedure(const FTMessage: TObject)
      begin
        Bot.API.sendMessage(
          TftMessage(FTMessage).Chat.id,
          Form1.Memo5.Lines.Text
        );
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': help cmd : '
            );
          end);
      end);

    Bot.Events.OnAnyMessage(
      procedure(const FTMessage: TObject)
      var indexInt: Integer;
      begin

        if Form1.ComboBox1.Items.IndexOf(
            TftMessage(FTMessage).Chat.id.ToString
            ) = -1
        then begin
          indexInt := Form1.ComboBox1.Items.Add(TftMessage(FTMessage).Chat.id.ToString);
          Form1.ComboBox1.ItemIndex := indexInt;
          indexInt := Form1.ComboBox2.Items.Add(TftMessage(FTMessage).Chat.id.ToString);
          Form1.ComboBox2.ItemIndex := indexInt;
        end;


        if Pos('/', TftMessage(FTMessage).text) > 0 then
          Exit;

        if Form1.ClientDataSet1.Locate('question', TftMessage(FTMessage).text, []) then
        begin
          Bot.API.sendMessage(
            TftMessage(FTMessage).Chat.id,
            Form1.ClientDataSet1.FieldByName('response').AsString
          );
        end else
        begin
          Bot.API.sendMessage(
            TftMessage(FTMessage).Chat.id,
            'I dont know how to answer your messsage: ' + TftMessage(FTMessage).text
          );
        end;
        Synchronize(
          procedure
          begin
            Form1.Memo1.Lines.Add(
              TftMessage(FTMessage).Chat.id.ToString + ': user wrote: ' + TftMessage(FTMessage).text
            );
          end);
      end);
    try
      Synchronize(
        procedure
        begin
          Form1.Memo1.Lines.Add(
            'Bot username: ' + Bot.API.getMe.username
          );
        end);
      Bot.API.deleteWebhook();

      LongPoll := TftLongPoll.Create(Bot);
      while (True) do
      begin
        //Form1.Memo1.Lines.Add('Long poll started');
        LongPoll.start();
      end
    except
      on E: Exception do
      begin
          Synchronize(
            procedure
            begin
              Form1.Memo1.Lines.Add(E.ClassName + ': ' + E.Message);
            end);
      end;
    end;
  except
    on E: Exception do
    begin
      Synchronize(
        procedure
        begin
          Form1.Memo1.Lines.Add(E.ClassName + ': ' + E.Message);
        end);
    end;
  end;
end;
end;
end.
