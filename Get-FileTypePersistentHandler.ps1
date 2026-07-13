# .SYNOPSIS
# Queries all file types with associated filter handlers and lists their respective filter handlers.
# .DESCRIPTION
# Queries all file types with associated filter handlers and lists their respective filter handlers.
# .OUTPUTS
# List of PSObject.
[CmdletBinding()]
[OutputType([System.Collections.Generic.List[PSObject]])]
param()

$Records = [System.Collections.Generic.List[PSObject]]::new()

try {
  $ClassesKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('Software\Classes', $False)
  $Extensions = $ClassesKey.GetSubKeyNames()
  foreach ($extension in $Extensions) {
    if (-not $extension.StartsWith('.')) { continue }
    Write-Verbose "Extension $extension"

    try {
      $extensionKey = $ClassesKey.OpenSubKey($extension, $False)
      if ($Null -eq $extensionKey) { continue }
      $progId = $extensionKey.GetValue('')

      try {
        $phKey = $extensionKey.OpenSubKey('PersistentHandler', $False)
        if ($Null -ne $phKey) {
          $Records.Add([PSCustomObject]@{
              Extension                 = $extension
              ProgID                    = $Null
              ProgIDCLSID               = $Null
              DefaultPersistentHandler  = $phKey.GetValue('')
              OriginalPersistentHandler = $phKey.GetValue('OriginalPersistentHandler')
            })
        }
      }
      finally { if ($Null -ne $phKey) { $phKey.Close() } }
    }
    finally { if ($Null -ne $extensionKey) { $extensionKey.Close() } }

    if (-not [string]::IsNullOrWhiteSpace($progId)) {
      try {
        $progIdClsidKey = $ClassesKey.OpenSubKey("$progId\CLSID", $False)
        if ($Null -ne $progIdClsidKey) {
          $clsid = $progIdClsidKey.GetValue('')

          try {
            $phKey = $ClassesKey.OpenSubKey("CLSID\$clsid\PersistentHandler", $False)
            if ($Null -ne $phKey) {
              $Records.Add([PSCustomObject]@{
                  Extension                 = $extension
                  ProgID                    = $progId
                  ProgIDCLSID               = $clsid
                  DefaultPersistentHandler  = $phKey.GetValue('')
                  OriginalPersistentHandler = $phKey.GetValue('OriginalPersistentHandler')
                })
            }
          }
          finally { if ($Null -ne $phKey) { $phKey.Close() } }
        }
      }
      finally { if ($Null -ne $progIdClsidKey) { $progIdClsidKey.Close() } }
    }
  }
}
finally { if ($Null -ne $ClassesKey) { $ClassesKey.Close() } }
return $Records
