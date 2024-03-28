unit jim_1brc_firedac_form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.StdCtrls,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FMX.Layouts, FMX.ListBox;

type
  TForm13 = class(TForm)
    Grid1: TGrid;
    stations: TFDQuery;
    FDConnection1: TFDConnection;
    FDScript1: TFDScript;
    ProgressBar1: TProgressBar;
    Layout1: TLayout;
    Label1: TLabel;
    Button1: TButton;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ReadIntoFDMemTable;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form13: TForm13;

implementation

{$R *.fmx}

uses
  Diagnostics,
  IOUtils;

const
  DataFile = '..\data\measurements_1m.csv';

procedure LinerOpenText;
begin
  var data := TFile.OpenText(DataFile);
  try
    while not data.EndOfStream do
    begin
      data.ReadLine;
    end;
  finally
    data.Free;
  end;
end;

procedure RawTextFile;
var myFile : TextFile;
var buffer: string;
begin
  AssignFile(myFile, datafile);
  Reset(myFile);
  try
    while not eof(myFile) do
      Readln(myFile, buffer);

  finally
    CloseFile(myFile);
  end;
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
  var timer := TStopwatch.StartNew;
  LinerOpenText;
  timer.Stop;
  ListBox1.Items.Add(timer.ElapsedTicks.ToString + ' : LinerOpenText');
  timer.Reset;

  timer.Start;
  RawTextFile;
  timer.Stop;
  ListBox1.Items.Add(timer.ElapsedTicks.ToString + ' : RawTextFile');



end;

procedure TForm13.FormCreate(Sender: TObject);
begin
  //ReadIntoFDMemTable;
  FDScript1.ExecuteAll;

end;

procedure TForm13.ReadIntoFDMemTable;
begin
  stations.DisableControls;
  FDScript1.ExecuteAll;
  var idx: Integer;
  var data := TFile.OpenText(DataFile);
  try
   // Discard first two lines
//    data.ReadLine;
//    data.ReadLine;
    stations.Open;
    stations.IndexesActive := False;
    while not data.EndOfStream do
    begin
      inc(idx);
      var values := data.ReadLine.Split([';']);
      var city := values[0];
      var temp := values[1];
      stations.AppendRecord([idx, city, temp]);
    end;
  finally
    data.Free;
    stations.EnableControls;
  end;
  Label1.Text := idx.ToString;
end;


end.
