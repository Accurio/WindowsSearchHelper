@{
  RootModule           = 'WindowsSearchHelper.psm1'
  ModuleVersion        = '0.0.0'
  CompatiblePSEditions = 'Desktop', 'Core'
  GUID                 = '57e67de3-0e21-4e61-b3a1-2d44b0dc3632'
  Author               = 'Accurio'
  Copyright            = '(c) 2026 Accurio, licensed under Apache 2.0 License.'
  Description          = 'A module for managing Windows Search file content indexing.'
  PowerShellVersion    = '5.1'
  FunctionsToExport    = @(
    'Get-FileTypePersistentHandler'
    'Disable-FileTypeContentIndexing'
    'Enable-FileTypeContentIndexing'
  )
  CmdletsToExport      = @()
  AliasesToExport      = @()
  PrivateData          = @{
    PSData = @{
      Tags         = 'WindowsSearch', 'PersistentHandler'
      LicenseUri   = 'https://github.com/Accurio/WindowsSearchHelper/blob/main/LICENSE.txt'
      ProjectUri   = 'https://github.com/Accurio/WindowsSearchHelper'
      ReleaseNotes = 'https://github.com/Accurio/WindowsSearchHelper/releases/tag/v0.0.0'
    }
  }
}
