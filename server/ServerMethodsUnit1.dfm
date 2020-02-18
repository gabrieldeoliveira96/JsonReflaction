object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  Height = 210
  Width = 300
  object DB: TFDConnection
    Params.Strings = (
      
        'Database=C:\Desenvolvimento\Video Aula\json reflaction\FDB\JSON_' +
        'REFLECTION.FDB'
      'User_Name=SYSDBA'
      'Password=.cana2002,'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 64
    Top = 24
  end
  object qClientes: TFDQuery
    CachedUpdates = True
    Connection = DB
    UpdateOptions.UpdateTableName = 'CLIENTE'
    SQL.Strings = (
      'select * from cliente')
    Left = 216
    Top = 40
    object qClientesSEQUENCIA: TIntegerField
      FieldName = 'SEQUENCIA'
      Origin = 'SEQUENCIA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qClientesNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 100
    end
    object qClientesCPF: TStringField
      FieldName = 'CPF'
      Origin = 'CPF'
    end
    object qClientesEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 100
    end
    object qClientesTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Origin = 'TELEFONE'
      Size = 15
    end
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 136
    Top = 88
  end
end
