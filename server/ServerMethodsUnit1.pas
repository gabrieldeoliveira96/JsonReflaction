unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Stan.StorageBin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.FireDACJSONReflect,
  vcl.dialogs;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    DB: TFDConnection;
    qClientes: TFDQuery;
    qClientesSEQUENCIA: TIntegerField;
    qClientesNOME: TStringField;
    qClientesCPF: TStringField;
    qClientesEMAIL: TStringField;
    qClientesTELEFONE: TStringField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    procedure updateCliente(const ADeltaList: TFDJSONDeltas);
    function Cliente: TFDJSONDataSets;
  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

procedure TServerMethods1.updateCliente(const ADeltaList: TFDJSONDeltas);
var
  LApply: IFDJSONDeltasApplyUpdates;
begin
  DB.StartTransaction;
  try
    LApply := TFDJSONDeltasApplyUpdates.Create(ADeltaList);

    LApply.ApplyUpdates('CLIENTES', qClientes.Command);

    DB.Commit;
    if LApply.Errors.Count > 0 then
    begin
      raise Exception.Create(LApply.Errors.Strings.Text);
    end;

  except
    on E: Exception do
      ShowMessage(E.Message);

  end;
end;

function TServerMethods1.Cliente: TFDJSONDataSets;
begin
  Result := TFDJSONDataSets.Create;
  TFDJSONDataSetsWriter.ListAdd(Result, 'CLIENTES', qClientes);
end;

end.
