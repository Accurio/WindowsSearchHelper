# .SYNOPSIS
# Associates all file types that have associated filter handlers with the Null filter handler.
# .DESCRIPTION
# Associates all file types that have associated filter handlers with the Null filter handler.
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$EmptyHandler = [Guid]::Empty.ToString('B')
$NullHandler = '{098f2470-bae0-11cd-b579-08002b30bfeb}'

try {
  $ClassesKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('Software\Classes', -not $WhatIfPreference)
  $Extensions = $ClassesKey.GetSubKeyNames()
  foreach ($extension in $Extensions) {
    if (-not $extension.StartsWith('.')) { continue }
    Write-Verbose "Extension $extension"
    $phKeyExist = $False
    $default = $Null
    $defaultExist = $False
    $original = $Null

    try {
      $extensionKey = $ClassesKey.OpenSubKey($extension, $False)
      if ($Null -eq $extensionKey) { continue }
      $progId = $extensionKey.GetValue('')

      try {
        $phKey = $extensionKey.OpenSubKey('PersistentHandler', $False)
        if ($Null -ne $phKey) {
          $phKeyExist = $True
          $default = $phKey.GetValue('')
          if ($default -notin $Null, $EmptyHandler) {
            $defaultExist = $True
          }
          $original = $phKey.GetValue('OriginalPersistentHandler')
        }
      }
      finally { if ($Null -ne $phKey) { $phKey.Close() } }
    }
    finally { if ($Null -ne $extensionKey) { $extensionKey.Close() } }

    if ((-not $defaultExist) -and (-not [string]::IsNullOrWhiteSpace($progId))) {
      try {
        $progIdClsidKey = $ClassesKey.OpenSubKey("$progId\CLSID", $False)
        if ($Null -ne $progIdClsidKey) {
          $clsid = $progIdClsidKey.GetValue('')

          try {
            $phKey = $ClassesKey.OpenSubKey("CLSID\$clsid\PersistentHandler", $False)
            if ($Null -ne $phKey) {
              $default = $phKey.GetValue('')
            }
          }
          finally { if ($Null -ne $phKey) { $phKey.Close() } }
        }
      }
      finally { if ($Null -ne $progIdClsidKey) { $progIdClsidKey.Close() } }
    }

    if ($default -notin $Null, $EmptyHandler, $NullHandler) {
      $name = $extension.PadRight(10)
      try {
        if ($phKeyExist) {
          $phKey = $ClassesKey.OpenSubKey("$extension\PersistentHandler", -not $WhatIfPreference)
        }
        else {
          Write-Host "Extension $name Create      PersistentHandler" -ForegroundColor Cyan
          if ($PSCmdlet.ShouldProcess("HKLM:\Software\Classes\$extension\PersistentHandler", 'CreateSubKey')) {
            $phKey = $ClassesKey.CreateSubKey("$extension\PersistentHandler")
          }
        }
        Write-Host "Extension $name Set         PersistentHandler to $NullHandler" -ForegroundColor Cyan
        if ($PSCmdlet.ShouldProcess("HKLM:\Software\Classes\$extension\PersistentHandler\(Default)", 'SetValue')) {
          $phKey.SetValue('', $NullHandler)
        }
        if ($Null -eq $original) {
          $original = if ($defaultExist) { $default } else { $EmptyHandler }
          Write-Host "Extension $name Set OriginalPersistentHandler to $original" -ForegroundColor Cyan
          if ($PSCmdlet.ShouldProcess("HKLM:\Software\Classes\$extension\PersistentHandler\OriginalPersistentHandler", 'SetValue')) {
            $phKey.SetValue('OriginalPersistentHandler', $original)
          }
        }
      }
      finally { if ($Null -ne $phKey) { $phKey.Close() } }
    }
  }
}
finally { if ($Null -ne $ClassesKey) { $ClassesKey.Close() } }
