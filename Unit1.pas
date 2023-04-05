unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.TabControl,
  FMX.ComboEdit, FMX.ListBox, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, Data.Bind.GenData,
  Data.Bind.Controls, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Fmx.Bind.Navigator,
  Data.Bind.ObjectScope, FMX.ListView, Data.DB, Datasnap.DBClient,
  FMX.Grid.Style, Fmx.Bind.Grid, Data.Bind.Grid, Data.Bind.DBScope, FMX.Grid, fastTelega.AvailableTypes,
  System.ImageList, FMX.ImgList;

type Tfilename= String;
type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    BindNavigator1: TBindNavigator;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1question: TStringField;
    ClientDataSet1response: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    ListView1: TListView;
    VertScrollBox1: TVertScrollBox;
    GroupBox3: TGroupBox;
    Memo2: TMemo;
    GroupBox4: TGroupBox;
    Memo3: TMemo;
    GroupBox5: TGroupBox;
    Memo4: TMemo;
    GroupBox6: TGroupBox;
    Memo5: TMemo;
    GroupBox7: TGroupBox;
    Memo6: TMemo;
    GroupBox8: TGroupBox;
    Memo7: TMemo;
    TabItem2: TTabItem;
    GroupBox10: TGroupBox;
    Memo9: TMemo;
    LinkControlToField2: TLinkControlToField;
    StringGrid1: TStringGrid;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    GroupBox9: TGroupBox;
    GroupBox11: TGroupBox;
    Panel1: TPanel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Panel2: TPanel;
    Label3: TLabel;
    Button4: TButton;
    Panel3: TPanel;
    Button5: TButton;
    Memo8: TMemo;
    Panel4: TPanel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Memo8Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  BotStarted: Boolean = False;


implementation

uses
  Unit2;

var
  BotThread: TBotThread;


{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if BotStarted then
  begin
    BotStarted := false;
    //Edit1.Enabled := true;
    Application.Terminate;
  end else
  begin
    BotThread := TBotThread.Create(false, 1);
    BotStarted := true;
    Button1.Text := 'Stop Bot!';
    Edit1.Enabled := false;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GroupBox11.Visible := false;
  Button3.Text := 'open send photo/file';
  if not GroupBox9.Visible then begin
    GroupBox9.Visible := true;
    Button2.Text := 'close send message';
  end else begin
    GroupBox9.Visible := false;
    Button2.Text := 'open send message';
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  GroupBox9.Visible := false;
  Button2.Text := 'open send message';
  if GroupBox11.Visible then begin
    GroupBox11.Visible := false;
    Button3.Text := 'open send photo/file';
  end else begin
    Button3.Text := 'close send photo/file';
    GroupBox11.Visible := true;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  MyFile: TftInputFile;
begin
  if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then
    begin
        MyFIle := TftInputFile.fromFile(
          OpenDialog1.FileName,
          'application/pdf'
        );
      Bot.API.sendDocument(
        ComboBox2.Selected.Text.ToInteger,
        MyFile
      );
    end else
      raise Exception.Create('File does not exist.');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if Memo8.Text <> '' then
    begin
      Bot.API.sendMessage(
        ComboBox1.Selected.Text.ToInteger,
        Memo8.Text
      );
      Form1.Memo1.Lines.Add(
        ComboBox1.Selected.Text + ' :bot: ' + Memo8.Text
      );
      Memo8.Text := '';
    end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  //Button2.Text := 'Send to ' + ComboBox1.Selected.Text;
  Memo8.Enabled := true;
  Button4.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    //ShowMessage('Long poll started');
    GroupBox9.Visible := false;
    GroupBox11.Visible := false;
    ClientDataSet1.CreateDataSet;

    ClientDataSet1.Append;
    ClientDataSet1question.AsString := 'first question';
    ClientDataSet1response.AsString := 'plus longue reponse';
    ClientDataSet1.Post;

    ClientDataSet1.Append;
    ClientDataSet1question.AsString := 'second question';
    ClientDataSet1response.AsString := 'autres plus longue reponse';
    ClientDataSet1.Post;
end;

procedure TForm1.Memo8Change(Sender: TObject);
begin
  //Button2.Text := 'Send to ' + ComboBox1.Selected.Text;
end;

end.
