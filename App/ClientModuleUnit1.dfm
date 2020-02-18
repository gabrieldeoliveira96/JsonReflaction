object ClientModule1: TClientModule1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSRestConnection1: TDSRestConnection
    Host = '192.168.0.2'
    Port = 8080
    LoginPrompt = False
    Left = 80
    Top = 40
    UniqueId = '{B0F54C5E-9ADA-4426-8E25-615D4AC8436E}'
  end
  object FdCliente: TFDMemTable
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 200
    Top = 56
    object FdClienteNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object FdClienteCPF: TStringField
      FieldName = 'CPF'
    end
    object FdClienteEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object FdClienteTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 15
    end
    object FdClienteFOTO: TBlobField
      FieldName = 'FOTO'
    end
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 128
    Top = 96
  end
end
