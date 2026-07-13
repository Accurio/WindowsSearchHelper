# WindowsSearchHelper

[English](README.md)

Windows Search 默认会为已关联筛选器处理程序的文件类型索引文件内容，经常导致 `SearchFilterHost.exe` 使用大量资源。一般情况下仅索引文件属性、不索引文件内容可以满足使用需求。通过将所有已关联筛选器处理程序的文件类型关联至 Null 筛选器处理程序，即可停止索引文件内容，减少资源使用。

## 模块功能

| 脚本和函数 | 功能 |
| ---------- | ---- |
| [Disable-FileTypeContentIndexing](Disable-FileTypeContentIndexing.ps1) | 将所有已关联筛选器处理程序的文件类型关联至 Null 筛选器处理程序 |
| [Enable-FileTypeContentIndexing](Enable-FileTypeContentIndexing.ps1) | 将所有原先关联非 Null 筛选器处理程序的文件类型重新关联至先前的筛选器处理程序 |
| [Get-FileTypePersistentHandler](Get-FileTypePersistentHandler.ps1) | 查询所有已关联筛选器处理程序的文件类型及其筛选器处理程序 |

`Disable-FileTypeContentIndexing` 和 `Enable-FileTypeContentIndexing` 支持 `-WhatIf` 参数，允许你查看命令将执行什么操作。

## 安装与使用

### 从 [PowerShell Gallery](https://www.powershellgallery.com/packages/WindowsSearchHelper) 安装模块

以管理员身份运行 PowerShell。

```PowerShell
Install-Module -Name WindowsSearchHelper

Disable-FileTypeContentIndexing -WhatIf  # 预览
Disable-FileTypeContentIndexing
```

### 下载单个脚本运行

下载所需脚本文件，并以管理员身份运行 PowerShell。

```PowerShell
.\Disable-FileTypeContentIndexing.ps1 -WhatIf  # 预览
.\Disable-FileTypeContentIndexing.ps1
```
