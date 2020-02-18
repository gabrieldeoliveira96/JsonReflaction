//
// Created by the DataSnap proxy generator.
// 10/10/2019 00:58:50
//

unit ClientClassesUnit1;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.FireDACJSONReflect, Data.DBXJSONReflect;

type

  IDSRestCachedTFDJSONDataSets = interface;

  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FupdateClienteCommand: TDSRestCommand;
    FClienteCommand: TDSRestCommand;
    FClienteCommand_Cache: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    procedure updateCliente(ADeltaList: TFDJSONDeltas);
    function Cliente(const ARequestFilter: string = ''): TFDJSONDataSets;
    function Cliente_Cache(const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
  end;

  IDSRestCachedTFDJSONDataSets = interface(IDSRestCachedObject<TFDJSONDataSets>)
  end;

  TDSRestCachedTFDJSONDataSets = class(TDSRestCachedObject<TFDJSONDataSets>, IDSRestCachedTFDJSONDataSets, IDSRestCachedCommand)
  end;

const
  TServerMethods1_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_updateCliente: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'ADeltaList'; Direction: 1; DBXType: 37; TypeName: 'TFDJSONDeltas')
  );

  TServerMethods1_Cliente: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_Cliente_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

implementation

function TServerMethods1Client.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare(TServerMethods1_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare(TServerMethods1_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

procedure TServerMethods1Client.updateCliente(ADeltaList: TFDJSONDeltas);
begin
  if FupdateClienteCommand = nil then
  begin
    FupdateClienteCommand := FConnection.CreateCommand;
    FupdateClienteCommand.RequestType := 'POST';
    FupdateClienteCommand.Text := 'TServerMethods1."updateCliente"';
    FupdateClienteCommand.Prepare(TServerMethods1_updateCliente);
  end;
  if not Assigned(ADeltaList) then
    FupdateClienteCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDSRestCommand(FupdateClienteCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FupdateClienteCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(ADeltaList), True);
      if FInstanceOwner then
        ADeltaList.Free
    finally
      FreeAndNil(FMarshal)
    end
    end;
  FupdateClienteCommand.Execute;
end;

function TServerMethods1Client.Cliente(const ARequestFilter: string): TFDJSONDataSets;
begin
  if FClienteCommand = nil then
  begin
    FClienteCommand := FConnection.CreateCommand;
    FClienteCommand.RequestType := 'GET';
    FClienteCommand.Text := 'TServerMethods1.Cliente';
    FClienteCommand.Prepare(TServerMethods1_Cliente);
  end;
  FClienteCommand.Execute(ARequestFilter);
  if not FClienteCommand.Parameters[0].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FClienteCommand.Parameters[0].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FClienteCommand.Parameters[0].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FClienteCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.Cliente_Cache(const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FClienteCommand_Cache = nil then
  begin
    FClienteCommand_Cache := FConnection.CreateCommand;
    FClienteCommand_Cache.RequestType := 'GET';
    FClienteCommand_Cache.Text := 'TServerMethods1.Cliente';
    FClienteCommand_Cache.Prepare(TServerMethods1_Cliente_Cache);
  end;
  FClienteCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FClienteCommand_Cache.Parameters[0].Value.GetString);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FupdateClienteCommand.DisposeOf;
  FClienteCommand.DisposeOf;
  FClienteCommand_Cache.DisposeOf;
  inherited;
end;

end.

