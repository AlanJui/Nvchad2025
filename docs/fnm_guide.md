# fnm ：Node.js 管理器應用指引

## 安裝

### 安裝 fnm 軟體套件

```sh
choco install fnm
```

### fnm 安裝路徑

```sh
PS C:\Users\AlanJui> fnm install 22.8.0
Installing Node v22.8.0 (x64)
warning: Version already installed at "C:\\Users\\AlanJui\\AppData\\Roaming\\fnm\\node-versions\\v22.8.0"
PS C:\Users\AlanJui> Get-ChildItem "$env:APPDATA\fnm\node-versions\v22.8.0\installation"
```

### fnm 安裝目錄結構

```sh
PS C:\Users\AlanJui> ls "$env:APPDATA\fnm\node-versions\"


    Directory: C:\Users\AlanJui\AppData\Roaming\fnm\node-versions


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 09:28                .downloads

d-----         2024/8/29  下午 07:20                v22.7.0

d-----         2025/3/13  下午 09:28                v22.8.0
```

或

```sh
PS C:\Users\AlanJui> ls C:\Users\AlanJui\AppData\Roaming\fnm\node-versions\


    Directory: C:\Users\AlanJui\AppData\Roaming\fnm\node-versions


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 09:28                .downloads

d-----         2024/8/29  下午 07:20                v22.7.0

d-----         2025/3/13  下午 09:28                v22.8.0
```

## 查檢已安裝之檔案

```sh
PS C:\Users\AlanJui> Get-ChildItem "$env:APPDATA\fnm\node-versions\v22.8.0\installation"


    Directory: C:\Users\AlanJui\AppData\Roaming\fnm\node-versions\v22.8.0\installation


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 10:38                node_modules

-a----         2025/3/13  下午 09:28          55243 CHANGELOG.md

-a----         2025/3/13  下午 09:28            334 corepack

-a----         2025/3/13  下午 09:28            218 corepack.cmd

-a----         2025/3/13  下午 09:28           3033 install_tools.bat

-a----         2025/3/13  下午 09:28         142879 LICENSE

-a----         2025/3/13  下午 10:38            403 neovim-node-host

-a----         2025/3/13  下午 10:38            332 neovim-node-host.cmd

-a----         2025/3/13  下午 10:38            833 neovim-node-host.ps1

-a----         2025/3/13  下午 09:28       80202904 node.exe

-a----         2025/3/13  下午 09:28            702 nodevars.bat

-a----         2025/3/13  下午 09:28           2073 npm

-a----         2025/3/13  下午 09:28            538 npm.cmd

-a----         2025/3/13  下午 09:28            795 npm.ps1

-a----         2025/3/13  下午 09:28           2073 npx

-a----         2025/3/13  下午 09:28            538 npx.cmd

-a----         2025/3/13  下午 09:28            795 npx.ps1

-a----         2025/3/13  下午 09:28          40237 README.md
```

## 設定 Path 軟連結

### PowerShell Scripts

```sh
# 自動取得 fnm 當前使用的 node 版本真實路徑 (Chocolatey 安裝的 fnm)
$fnm_versions = "$env:APPDATA\fnm\node-versions"
$node_version = fnm current
$nodeRealPath = Join-Path $fnm_versions "$node_version\installation"

# 確認路徑存在（可手動確認）
if (Test-Path $nodeRealPath) {
    # 建立 Symbolic Link
    Remove-Item 'C:\bin\nodejs' -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path 'C:\bin\nodejs' -Target $nodeRealPath
    Write-Host "成功建立符號連結：C:\bin\nodejs -> $nodeRealPath"
} else {
    Write-Error "未找到路徑 $nodeRealPath，請確認該版本已經正確安裝。"
}
```

### 執行軟連結建置 Script

```sh
PS C:\Users\AlanJui\AppData\Local\nvim\docs> .\fnm_path.ps1


    Directory: C:\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----l         2025/3/15  下午 12:30                nodejs

成功建立符號連結：C:\bin\nodejs -> C:\Users\AlanJui\AppData\Roaming\fnm\node-versions\v22.8.0\installation
```

### 查核建置結果

```sh
PS C:\Users\AlanJui\AppData\Local\nvim\docs> ls \bin\nodejs


    Directory: C:\bin\nodejs


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 10:38                node_modules

-a----         2025/3/13  下午 09:28          55243 CHANGELOG.md

-a----         2025/3/13  下午 09:28            334 corepack

-a----         2025/3/13  下午 09:28            218 corepack.cmd

-a----         2025/3/13  下午 09:28           3033 install_tools.bat

-a----         2025/3/13  下午 09:28         142879 LICENSE

-a----         2025/3/13  下午 10:38            403 neovim-node-host

-a----         2025/3/13  下午 10:38            332 neovim-node-host.cmd

-a----         2025/3/13  下午 10:38            833 neovim-node-host.ps1

-a----         2025/3/13  下午 09:28       80202904 node.exe

-a----         2025/3/13  下午 09:28            702 nodevars.bat

-a----         2025/3/13  下午 09:28           2073 npm

-a----         2025/3/13  下午 09:28            538 npm.cmd

-a----         2025/3/13  下午 09:28            795 npm.ps1

-a----         2025/3/13  下午 09:28           2073 npx

-a----         2025/3/13  下午 09:28            538 npx.cmd

-a----         2025/3/13  下午 09:28            795 npx.ps1

-a----         2025/3/13  下午 09:28          40237 README.md
```

### 查檢 npm 安裝套件路徑

```sh
PS C:\Users\AlanJui\AppData\Local\nvim\docs> ls C:\bin\nodejs\node_modules\


    Directory: C:\bin\nodejs\node_modules


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 09:28                corepack

d-----         2025/3/13  下午 10:38                neovim

d-----         2025/3/13  下午 09:28                npm



PS C:\Users\AlanJui\AppData\Local\nvim\docs> ls C:\bin\nodejs\node_modules\neovim\


    Directory: C:\bin\nodejs\node_modules\neovim


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/13  下午 10:38                bin

d-----         2025/3/13  下午 10:38                lib

d-----         2025/3/13  下午 10:38                node_modules

d-----         2025/3/13  下午 10:38                scripts

-a----         2025/3/13  下午 10:38           2285 CHANGELOG.md

-a----         2025/3/13  下午 10:38           2684 package.json

-a----         2025/3/13  下午 10:38          11537 README.md



PS C:\Users\AlanJui\AppData\Local\nvim\docs> ls C:\bin\nodejs\node_modules\neovim\bin


    Directory: C:\bin\nodejs\node_modules\neovim\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2025/3/13  下午 10:38           1220 cli.js

-a----         2025/3/13  下午 10:38           2707 generate-typescript-interfaces.js

```

````sh

## 參考

### APPDATA vs LOCALAPPDATA

1.

```sh
PS C:\Users\AlanJui> ls "$env:APPDATA"


    Directory: C:\Users\AlanJui\AppData\Roaming


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2024/8/28  下午 02:03                Adobe

d-----          2024/9/7  下午 09:24                AMD

d-----          2024/9/1  下午 07:12                Blackmagic Design

d-----         2025/3/15  上午 11:25                Code

d-----          2024/9/5  下午 12:40                com.logitech

d-----         2024/8/31  下午 10:07                DataRecommendations

d-----         2024/8/29  下午 07:20                fnm
.......
````

2.

```sh
PS C:\Users\AlanJui> ls "$env:LOCALAPPDATA"


    Directory: C:\Users\AlanJui\AppData\Local


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----          2025/3/2  下午 12:02                .IdentityService

d-----         2024/10/4  上午 10:45                AMD

d-----         2025/3/12  上午 10:46                AMD_Common
......
```
