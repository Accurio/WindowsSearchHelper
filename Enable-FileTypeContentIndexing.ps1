# .SYNOPSIS
# Re-associates all file types previously associated with a non-Null filter handler back to their original filter handlers.
# .DESCRIPTION
# Re-associates all file types previously associated with a non-Null filter handler back to their original filter handlers.
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$EmptyHandler = [Guid]::Empty.ToString('B')
$NullHandler = '{098f2470-bae0-11cd-b579-08002b30bfeb}'

try {
  $ClassesKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('Software\Classes', $False)
  $Extensions = $ClassesKey.GetSubKeyNames()
  foreach ($extension in $Extensions) {
    if (-not $extension.StartsWith('.')) { continue }
    Write-Verbose "Extension $extension"

    try {
      $phKey = $ClassesKey.OpenSubKey("$extension\PersistentHandler", -not $WhatIfPreference)
      if ($Null -eq $phKey) { continue }
      $default = $phKey.GetValue('')
      $original = $phKey.GetValue('OriginalPersistentHandler')

      if (($NullHandler -eq $default) -and ($original -notin $Null, $NullHandler)) {
        $name = $extension.PadRight(10)
        if ($EmptyHandler -ne $original) {
          Write-Host "Extension $name Set            PersistentHandler to $original" -ForegroundColor Cyan
          if ($PSCmdlet.ShouldProcess("HKLM:\Software\Classes\$extension\PersistentHandler\(Default)", 'SetValue')) {
            $phKey.SetValue('', $original)
          }
        }
        else {
          Write-Host "Extension $name Delete         PersistentHandler eq $default" -ForegroundColor Cyan
          if ($PSCmdlet.ShouldProcess(
              "HKLM:\Software\Classes\$extension\PersistentHandler\(Default)", 'DeleteValue')) {
            $phKey.DeleteValue('')
          }
        }
        Write-Host "Extension $name Delete OriginalPersistentHandler eq $original" -ForegroundColor Cyan
        if ($PSCmdlet.ShouldProcess(
            "HKLM:\Software\Classes\$extension\PersistentHandler\OriginalPersistentHandler", 'DeleteValue')) {
          $phKey.DeleteValue('OriginalPersistentHandler')
        }
      }
    }
    finally { if ($Null -ne $phKey) { $phKey.Close() } }
  }
}
finally { if ($Null -ne $ClassesKey) { $ClassesKey.Close() } }
