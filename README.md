# WindowsSearchHelper

[简体中文](README.zh-CN.md)

By default, Windows Search indexes file contents for file types with associated filter handlers, which frequently causes `SearchFilterHost.exe` to consume significant system resources. In most cases, indexing only file properties without indexing file contents is sufficient for general usage. By associating all file types that have associated filter handlers with the Null filter handler, you can stop content indexing and reduce resource consumption.

## Module Features

| Scripts and Functions | Description |
| --------------------- | ----------- |
| [Disable-FileTypeContentIndexing](Disable-FileTypeContentIndexing.ps1) | Associates all file types that have associated filter handlers with the Null filter handler |
| [Enable-FileTypeContentIndexing](Enable-FileTypeContentIndexing.ps1) | Re-associates all file types previously associated with a non-Null filter handler back to their original filter handlers |
| [Get-FileTypePersistentHandler](Get-FileTypePersistentHandler.ps1) | Queries all file types with associated filter handlers and lists their respective filter handlers |

`Disable-FileTypeContentIndexing` and `Enable-FileTypeContentIndexing` support the `-WhatIf` parameter, allowing you to see what the command would have done instead of making changes.

## Installation and Usage

### Install the Module from [PowerShell Gallery](https://www.powershellgallery.com/packages/WindowsSearchHelper)

Run PowerShell as Administrator.

```PowerShell
Install-Module -Name WindowsSearchHelper

Disable-FileTypeContentIndexing -WhatIf  # Preview
Disable-FileTypeContentIndexing
```

### Download and Run Individual Scripts

Download the required script file and Run PowerShell as Administrator.

```PowerShell
.\Disable-FileTypeContentIndexing.ps1 -WhatIf  # Preview
.\Disable-FileTypeContentIndexing.ps1
```
