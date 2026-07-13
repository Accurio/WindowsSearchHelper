[CmdletBinding()]
param()

$ModuleManifest = Import-PowerShellDataFile -Path '.\WindowsSearchHelper.psd1' -ErrorAction Stop
$Functions = $ModuleManifest.FunctionsToExport
if (-not $Functions) {
    throw 'FunctionsToExport is Empty!'
}

$NewLine = [Environment]::NewLine
$moduleContent = "# WindowsSearchHelper$NewLine$NewLine"

foreach ($function in $Functions) {
    $content = Get-Content -Path ".\$function.ps1" -Raw -ErrorAction Stop
    $moduleContent += "function $function {$content}$NewLine$NewLine"
}

$FunctionsString = $Functions -join ", ``$NewLine"
$moduleContent += "Export-ModuleMember -Function ``$NewLine$FunctionsString"
$moduleContent = Invoke-Formatter -ScriptDefinition $moduleContent -ErrorAction Stop

$PublishPath = '.\publish\WindowsSearchHelper'
$Null = New-Item -Name $PublishPath -ItemType Directory -Force -ErrorAction Stop
Copy-Item -Path '.\WindowsSearchHelper.psd1' -Destination $PublishPath -ErrorAction Stop
Set-Content -Path "$PublishPath\WindowsSearchHelper.psm1" -Value $moduleContent -ErrorAction Stop
