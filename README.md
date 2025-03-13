# NvChad 2.5 個人客製化指引

NvChad 自 V2.5 起，變更了原先客製化環境的規格。原先的 lua/custom 作法已無效。

以下之安裝指引，主要流程分以下四大程序：

1. 備妥【安裝前置條件】
2. 安裝 Neovim App
3. 安裝 NvChad 插件
4. 安裝 Nvchad2025 客製化範本

## 安裝前置條件

為使 NvChad 能一次安裝搞定，建議在安裝 Nvchad 前最好能先安裝好這些：
工具性軟體（如：程式碼編譯/連結工具）、作業系統層級之軟體套件（如：ripgrep 模糊搜尋）、
圖標字型（Nerd Font）、... 。

講坦白，這工作很漫長，又極其無聊，得耐著性子熬過。

### Nerd 字型

為求操作畫面之賞心悅目，需要使用【圖示符號字型】（即：Nerd 字型）。

在 NvChad 要避用字型名稱結尾有 Mono 之字型。以
官網的舉例而言：可安裝 JetbrainsMono Nerd Font ；但卻萬萬不可
安裝 JetbrainsMono Nerd Font Mono 字型。

- 字型： MesloLGS Nerd Font Propo, LXGW WenKai Mono TC
- 尺寸： 16

### 編譯工具

需要 C 編譯器，如：cc, gcc, clang, make, cl

- MinGW-w64 (gcc)
- GnuWin32 (make)
- LLVM/Clang (clang/gcc)

【重要】：務必設定 Path 系統環境變數。

```
setx CC "C:\mingw64\bin\gcc.exe"
```

### Python 直譯器

此為【選項】，可略過。

- 版本：3.13
- 安裝路徑：C:\Program Files\Python313
- Path環境變數：要設定
- Provider 套件： pip install pynvim

### Node.js 直譯器

此為【選項】，可略過。

但是，由於許多 nvim 插件（plugins）均引用 Node.js 進行「安裝、執行」作業，
如：TreeSitter、copilot.lua ...，所以，建議您最好還是先行安裝備妥。

特別提醒採用 zbirenbaum/copilot.lua 插件之使用者，你務必安裝 Node.js 直譯器，
而且版本編號一定高於 18 以上；否則，就會發生 Copilot 看似能正常運作，但又常
會莫名其妙的當掉。

- 版本：22.8.0
- Provider 套件： npm install -g neovim

1. 安裝 Fast Node Manager (fnm)

```sh
PS C:\Users\AlanJui> choco install fnm
Chocolatey v2.4.1
Installing the following packages:
fnm
By installing, you accept licenses for the packages.
Downloading package from source 'https://community.chocolatey.org/api/v2/'
Progress: Downloading fnm 1.38.1... 100%

fnm v1.38.1 [Approved]
fnm package files install completed. Performing other installation steps.
The package fnm wants to run 'chocolateyInstall.ps1'.
Note: If you don't run this script, the installation will fail.
Note: To confirm automatically next time, use '-y' or consider:
choco feature enable -n allowGlobalConfirmation
Do you want to run the script?([Y]es/[A]ll - yes to all/[N]o/[P]rint): y

Extracting 64-bit C:\ProgramData\chocolatey\lib\fnm\tools\fnm-windows_x64.zip to C:\ProgramData\chocolatey\lib\fnm\tools...
C:\ProgramData\chocolatey\lib\fnm\tools
 ShimGen has successfully created a shim for fnm.exe
 The install of fnm was successful.
  Deployed to 'C:\ProgramData\chocolatey\lib\fnm\tools'

Chocolatey installed 1/1 packages.
 See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
```

2. 設定所需使用之環境變數

（1）在 Path 系統環境變數加入 fnm 安裝路徑

```sh
C:\ProgramData\chocolatey\lib\fnm\tools
```

（2）在 Profile 加入 fnm 使用之環境變數

```sh
fnm env | Invoke-Expression
```

3. 重載系統環境變數

```sh
refreshenv
```

4. 驗證安裝結果

```sh
PS C:\Users\AlanJui> fnm --version
fnm 1.38.1
```

5. 條列 Node.js 可用版本

```sh
PS C:\Users\AlanJui> fnm ls-remote
...
...
```

6. 查檢作業系統已安裝之 Node.js 版本

```sh
PS C:\Users\AlanJui> fnm list
* v22.7.0 default
* system
```

6. 安裝 Node.js(node) 及套件管理器(npm)

```sh
PS C:\Users\AlanJui> fnm ls-remote | grep 22.8
v12.22.8 (Erbium)
v22.8.0

PS C:\Users\AlanJui> fnm install 22.8.0
Installing Node v22.8.0 (x64)

PS C:\Users\AlanJui> fnm list
* v22.7.0 default
* v22.8.0
* system
```

【註】：fnm 將 Node.js 各版本，安裝於路徑： C:\Users\<使用者帳號>\AppData\Local\fnm\node-versions\<版本號>\installation\

7. 指定使用某版 Node.js

```sh
PS C:\Users\AlanJui> fnm use 22.8.0
Using Node v22.8.0

PS C:\Users\AlanJui> fnm list
* v22.7.0 default
* v22.8.0 《== 以藍色字體標示為使用中
* system

PS C:\Users\AlanJui> node -v
v22.8.0
PS C:\Users\AlanJui> npm -v
10.8.2
```

8. 安裝 nvim 所需使用之 Node.js Provider 套件

```sh
PS C:\Users\AlanJui> npm install -g neovim

added 32 packages in 3s
```

9. 查核 Node.js 執行檔之安裝路徑：

```sh
PS C:\Users\AlanJui> fnm current
v22.7.0

PS C:\Users\AlanJui> where.exe node
C:\Users\AlanJui\AppData\Local\fnm_multishells\28784_1741874123662\node.exe
```

10. 在options.lua 選項設定檔，宣告 Node.js 使用之 Provider 。

~\AppData\Local\nvim\lua\options.lua 

```sh
  local node_win = "C:\Users\AlanJui\AppData\Local\fnm_multishells\6348_1741877567248\node_modules\neovim\bin\cli.js"
```

### 安裝 Lua 直譯器及套件管理器

（1）安裝直譯器

- 版本：v5.1 (LuaBinaries 5.1.5 - Release 1)
- 下載網址：[LuaBinaries 官網](https://luabinaries.sourceforge.net/download.html)
- 套件名稱：
  - lua5_1_5_Win64_bin.zip: Windows x64 Executables
  - lua5_1_5_Win64_dll8_lib.zip: Windows x64 DLL and Includes (Visual C++ 2005 Built)
- 安裝路徑：C:\bin\lua
- 設定系統環境變數：在 Path 加入目錄路徑 "C:\bin\lua"

1. 下戴套件：[lua5_1_5_Win64_bin.zip](https://sourceforge.net/projects/luabinaries/files/5.1.5/Tools%20Executables/lua-5.1.5_Win64_bin.zip/download) 與 [lua-5.1.5_Win64_dll12_lib.zip](https://sourceforge.net/projects/luabinaries/files/5.1.5/Windows%20Libraries/Dynamic/lua-5.1.5_Win64_dll12_lib.zip/download)

2. 建立新目錄：C:\bin\lua

3. 將【步驟 1】之套件壓縮檔解壓縮，並複製檔案放入 C:\bin\lua 。

4. 透過 Windows 11 之【開始功能】/【編輯系統環境變數】，設定 Path 系統環境變數。

5. 重啟終端機，執行以下指令驗證 lua 直譯器已能正確運作：

```sh
PS C:\Users\AlanJui> lua5.1 -v
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
```

6. 編輯 PowerShell Profile 檔案，加入以下設定：

（a）編輯 Profile

```sh
nvim $PROFILE
```

（b）加入設定：

```sh
Set-Alias lua C:\bin\lua\lua5.1.exe
```

（b）重載 Profile

```sh
. $PROFILE
```

（c）驗證結果

```sh
PS C:\Users\AlanJui> lua -v
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
```

（2）安裝 Lua 套件管理器：luarocks

- 版本：3.11.1 Windows 64 bits
- 下載網址：[LuaRocks 官網](https://luarocks.github.io/luarocks/releases/)
- 套件名稱：luarocks-3.11.1-windows-64.zip (luarocks.exe stand-alone Windows 64-bit binary)
- 安裝路徑：C:\bin\lua

【安裝及驗證作業】：

1. 下戴套件：luarocks-3.11.1-windows-64.zip

2. 將【步驟 1】之套件壓縮檔解壓縮，並複製檔案放入 C:\bin\lua 。

3. 驗證 luarocks 已能運作：

```sh
PS C:\Users\AlanJui> luarocks --version
luarocks 3.11.1
LuaRocks main command-line interface
```

4. 指定 luarocks 使用 lua5.1.exe 編譯 Lua 套件檔。

```sh
PS C:\Users\AlanJui> luarocks config variables.LUA C:\bin\lua\lua5.1.exe
Wrote
        variables.LUA = "C:\\bin\\lua\\lua5.1.exe"
to
        C:\Users\AlanJui\AppData\Roaming\luarocks\config-5.4.lua
```

5. 驗證 luarocks 能安裝 Lua 套件

```sh
PS C:\Users\AlanJui> luarocks install luasocket
Installing https://luarocks.org/luasocket-3.1.0-1.src.rock

luasocket 3.1.0-1 depends on lua >= 5.1 (5.4-1 provided by VM: success)
C:\bin\clang+llvm-19.1.7-x86_64-pc-windows-msvc\bin\clang.exe -O2 -c -o src/luasocket.o -IC:\bin\lua/include src/luasocket.c -DLUASOCKET_DEBUG -DWINVER=0x0501 -Ic:\windows\system32\include
The system cannot find the path specified.

Error: Build error: Failed compiling object src/luasocket.o
PS C:\Users\AlanJui>
```

若見安裝順利結束，即表 luarocks 已能正常運作。因早期之 lua 有 32/64 bits
之分。以下透過指令：choco ，進行安裝作業，所得結果為 32 bits 之 luarocks 。

【註】：

1. 在 Windows 11 安裝 lua 直譯器及其套件，需留心 lua, luarocks, lua 套件，同樣都是
   64 bits 或同樣是 32 bits ，決不可相互混雜，否則會有執行錯誤發生。

2. 在 Windows 作業系統，透過 choco 安裝 luarocks ，需留心其預設安裝為 32 bits 。

```sh
choco install luarocks
ls "C:\ProgramData\chocolatey\lib\luarocks\luarocks-2.4.4-win32\luarocks.bat"
```

所以在 Windows 11 作業系統安裝之 luarocks 是 32 bits 之版本，就會
發生如下之安裝錯誤之問題：

```sh
Installing https://luarocks.org/luasocket-3.1.0-1.src.rock
cl /nologo /MD /O2 -c -Fosrc/mime.obj -IC:/ProgramData/chocolatey/lib/luarocks/luarocks-2.4.4-win32/include src/mime.c -DLUASOCKET_DEBUG -DNDEBUG
mime.c
C:/ProgramData/chocolatey/lib/luarocks/luarocks-2.4.4-win32/include\lua.h(12): fatal error C1083: 無法開啟包含檔案: 'stdarg.h': No such file or directory

Error: Build error: Failed compiling object src/mime.obj
PS C:\Users\AlanJui>
```

### 模糊搜尋工具

- 官網：[ripgrep](https://github.com/BurntSushi/ripgrep)
- 版本：v14.1.0
- 權限：使用【系統管理員】身份

安裝操作：

```sh
$ choco install ripgrep
```

驗證安裝：

```sh
PS C:\Users\AlanJui> rg --version
ripgrep 14.1.0 (rev e50df40a19)

features:-simd-accel,+pcre2
simd(compile):+SSE2,-SSSE3,-AVX2
simd(runtime):+SSE2,+SSSE3,+AVX2

PCRE2 10.42 is available (JIT is available)
PS C:\Users\AlanJui>
```

### 版本管理工具

LazyGit 為類圖形介面之 Git ，屬【選項】，可略過。

```sh
choco install lazygit
```

### 檔案管理工具

ViFm 為類圖形介面之【檔案管理員】，操作按鍵多 Vim 類同。
屬【選項】，可略過。

```sh
choco install vifm
```

## 安裝 Neovim App

- 作業系統：Windows 11 Pro
- Nvim: V0.10.4
- 發行版：nvim-win64.msi
- 安裝路徑：C:\Program Files\Neovim

## 安裝 Nvchad2025 客製化範本

Nvchad2025 即本專案所建置的 NvChad 2.5 參考範本！

### 最簡方式（一）

【Windows 安裝作業】：

1. 下載本專案産出之設定檔：

```sh
PS C:\Users\AlanJui> cd ~\AppData\Local\
PS C:\Users\AlanJui> mv nvim nvim_bak
PS C:\Users\AlanJui\AppData\Local> git clone https://github.com/AlanJui/Nvchad2025.git nvim
```

2. 啟動 nvim 。

3. 執行 nvim 指令，透過 Mason 安裝：LangServer / DAP / Linter / Formatter。

```sh
:MasonInstallAll
```

【Linux / macOS / WSL2 安裝作業】：

1. 下載本專案産出之設定檔：

```sh
$ git clone https://github.com/AlanJui/Nvchad2025.git ~/.config/nvim
```

2. 啟動 nvim 。

3. 執行 nvim 指令，透過 Mason 安裝：LangServer / DAP / Linter / Formatter。

```sh
:MasonInstallAll
```

【註】：

1. 在【Windows 終端機 + Windows PowerShell】輸入目錄： "~\AppData" 會被自動轉換成 "C:\Users\《UserName》\AppData" 。
   操作方法：【cd ~\App】之後，按 \<Tab> 鍵，便會自動轉換成目錄：
   C:\Users\《UserName》\AppData ；

2. 目錄路徑：~\AppData\Local\nvim 等同 Linux 的 ~/.local/share/nvim/ ；

3. Nvim 設定檔目錄路徑： ~/.config/nvim = ~/AppData/Local/nvim ；

4. Nvim 插件檔目錄路徑： ~/.local/share/nvim = ~/AppData/Local/nvim-data

### NvChad 專用模式（二）

這種模式適用於對 nvim 運用有特殊需求之使用者，可令同一作業系統之下，
有兩種以上之 nvim 設定檔，譬如：想研究 LunarVim / NvChad / LazyVim
那一種用起來比較上手；或是，當年我想學著試用 Lua Script 客製自己
的 Nvim 作業環境，需要有確保可正常操作的 nvim ；但也需要另一可供練功、
做試驗的 my-nvim 。

1. 建置批次執行檔 nvchad.ps1

個人的使用習慣，會在路徑：【C:\bin】，建置一個專放雜七雜八的各式執行檔目錄。
同時，設作業系統層級的環境變數：Path，放入【C:\bin】這個目錄。

所以，此處所述之 nvchad.ps1 批次執行檔，便是放在如下之路徑中：
`C:\bin\nvchad.ps1` 。

在 nvchad.ps1 置入如下所示之 PowerShell Script ：

```sh
$env:NVIM_APPNAME = "nvchad"

if ($args.Count -eq 0) {
    Invoke-Expression "nvim"
} else {
    Invoke-Expression ("nvim " + ($args -join " "))
}
```

2. 建置便於操作的 Alias

上述之 .ps1 檔，執行時指令得輸入：.\nvchad.ps1 ；經過 PowerShell Alias 的轉化，
以後之執行指令，僅需輸入：nvchad 即可。

```sh
Set-Alias nvchad C:\bin\nvchad.ps1
```

3. 下載 Nvchad2025 之 NvChad 2.5 參考範本

```sh
PS C:\Users\AlanJui> cd C:\Users\AlanJui\AppData\Local\
PS C:\Users\AlanJui\AppData\Local> git clone https://github.com/AlanJui/Nvchad2025.git nvchad
```

4. 啟動 nvim 。

5. 執行 nvim 指令，透過 Mason 安裝：LangServer / DAP / Linter / Formatter。

```sh
:MasonInstallAll
```

---

恭禧！您走到這裡，終於可以打完收工了。我承認以上的安裝程序不算 Smart ，
可能還有些「煩~~~」，但這也是目前我所能做到的極限。

敬請特別注意，此專案最主要目的只是在示範：NvChad V2.0 升級 V2.5 後，
想要客製自訂自用的 NvChad 該怎麼做，給出一個較完整的參考範例。故也請不要
期待此專案之産出可 Bug Free ；甚至要求我對有問題的地方，做立即處理反應。

最後，敬祝：「NvChad 2.5 使用順心、愉快！！」

## 其它（參考資訊）

以下資訊，為安裝過程，可能會遇到的問題；或是遇狀況需進行檢測的輔助指令。

### 更新系統環境變數

透過 PowerShell 指令 refreshenv （類似 Linux Bash Shell 的指令： source ~/.bashrc）
，可立即更新系統環境變數之設定。

1. 查詢 PowerShell Profile 路徑

```sh
PS C:\Users\AlanJui> $PROFILE
C:\Users\AlanJui\OneDrive\文件\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

2. 啟用 refreshenv 指令

建立 PowerShell Profile 檔案，可以下列指令建立：

```sh
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
```

3. 編輯 PowerShell Profile

```sh
PS C:\Users\AlanJui> nvim $PROFILE
```

4. 重新載入 PowerShell Profile，執行 refreshenv 指令：

```sh
PS C:\Users\AlanJui> . $PROFILE
PS C:\Users\AlanJui> refreshenv
Refreshing environment variables from the registry for powershell.exe. Please wait...
Finished
PS C:\Users\AlanJui>
```

### 刪目錄

【PowerShell】

```sh
Remove-Item -Recurse -Force C:\Users\AlanJui\AppData\Local\nvim\lua\custom
Remove-Item -Recurse -Force ~\AppData\Local\nvim\lua\custom
```

【CMD】

```sh
rd /s /q Remove-Item -Recurse -Force C:\Users\AlanJui\AppData\Local\nvim\lua\custom
```

### 在 Windows 環境安裝 OpenSSL

```sh
fatal: unable to access 'https://github.com/tree-sitter/tree-sitter-scala/': OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 0
```

查檢 Git for Windows 是否使用 Windows 內建之 TLS 而非 OpenSSL

（1）設定 git 改用 OpenSSL

```sh
git config --global http.sslBackend openssl
```

（2）利用 git clone 驗證 OpenSSL 已能正常運作

```sh
git clone https://github.com/tree-sitter/tree-sitter-scala.git
```

【參考】：強制使用舊版 TLS 1.2 ；而不使用新版 1.3

```sh
git config --global http.sslVersion tls1.2
git clone https://github.com/tree-sitter/tree-sitter-scala.git
```

### 設定 Git 使用 OpenSSL, TLS 1.2

設定：

```sh
git config --global http.sslBackend openssl
git config --global http.sslVersion tls1.2
```

驗證：

```sh
git config --global http.sslBackend
openssl
```

## 常見問題排除

### 退出 Nvim 出現執行錯誤

【問題描述】：

執行指令 :q ，欲退出 nvim ，狀態列欲顯現以下訊息：

```sh
E138: All C:\Users\AlanJui\AppData\Local\nvim-data\shada\main.shada.tmp.X files exist, cannot write ShaDa file!
```

【導因分析】：

這是因為 Neovim（包含 NvChad）嘗試將 session 和歷史紀錄儲存到 ShaDa（Shared Data）檔案時發生了錯誤，通常是暫存檔沒有正常清除導致的。

通常此問題的原因是 Neovim 上次關閉時非正常結束，或是暫存的 ShaDa 檔案殘留，導致無法寫入新的 ShaDa 資料。

檔案所處位置：

```sh
C:\Users\你的使用者名稱\AppData\Local\nvim-data\shada\
```

【排除問題】：

1. 進入目錄：

```sh
cd ~\AppData\Local\nvim-data\shada\
```

2. 刪除檔案名稱為： `main.shada.tmp.*` 之所有檔案：

```sh
rm main.shada.tmp.*
```

【註】：迅簡法：

```sh
ls ~\AppData\Local\nvim-data\shada\main.shada.tmp.*
rm ~\AppData\Local\nvim-data\shada\main.shada.tmp.*
```
