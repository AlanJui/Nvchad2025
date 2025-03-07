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

- 版本：23.5.0
- 安裝路徑：C:\Program Files\nodejs
- Path環境變數：要設定
- Provider 套件： npm install -g neovim

### Lua 直譯器

此為【選項】，可略過。

若是以 choco 安裝軟體套件，務必記得以下兩大要項：

- 要以【系統管理員】身份，啟動 Windows PowerShell
- 許多套件之安裝，會順便設定 Path 系統環境變數，但是
  您得重啟 Windows PowerShell ，變更後的 Path 才會生效

【註】：覺得重啟 Windows PowerShell 太麻煩的使用者，可用指令
要求 PowerShell 重新載入 Path 系統環境變數

```sh
refreshenv
```

1. 安裝直譯器

- 版本：v5.1.5.52

```sh
choco install lua
refreshenv
```

2. 安裝套件管理器

- 名稱：luarocks
- 版本：v2.4.4
- 安裝路徑： C:\Users\AlanJui\AppData\Local\Temp\chocolatey\luarocks-2.4.4-win32
  C:\Users\AlanJui\AppData\Roaming\LuaRocks

安裝操作：

```
choco install luarocks
refreshenv
```

驗證安裝：

```
PS C:\Users\AlanJui> luarocks install luasocket
Installing https://luarocks.org/luasocket-3.1.0-1.src.rock
cl /nologo /MD /O2 -c -Fosrc/mime.obj -IC:/ProgramData/chocolatey/lib/luarocks/luarocks-2.4.4-win32/include src/mime.c -DLUASOCKET_DEBUG -DNDEBUG
mime.c
C:/ProgramData/chocolatey/lib/luarocks/luarocks-2.4.4-win32/include\lua.h(12): fatal error C1083: 無法開啟包含檔案: 'stdarg.h': No such file or directory

Error: Build error: Failed compiling object src/mime.obj
PS C:\Users\AlanJui>
```

"C:\ProgramData\chocolatey\lib\luarocks\luarocks-2.4.4-win32\luarocks.bat"

### 模糊搜尋工具

- 官網：[ripgrep](https://github.com/BurntSushi/ripgrep)
- 版本：v14.1.0
- 權限：使用【系統管理員】身份

安裝操作：

```
$ choco install ripgrep
```

驗證安裝：

```
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

## 安裝 NvChad 插件

NvChad 亦為 Neovim 插件，可透過【Windows終端機 + PowerShell介面】安裝。
建議：不要使用【系統管理員】權限，來執行以下之安裝。

```sh
git clone https://github.com/NvChad/starter $ENV:USERPROFILE\AppData\Local\nvim
nvim
```

【註】：

1. 一定要執行過 nvim 一次；一定要執行過 nvim 一次；一定要執行過 nvim 一次。
   因為 NvChad 的 Starter 需要 nvim 啟動後，才能正常運作。也只有 NvChad Starter
   執行過後，NvChad 在 Neovim 所需之執行環境才能備妥，如：在 C:\Users\\\<UserName>\AppData\Local\nvim-data 目錄下
   安裝 base46 這個插件。

2. 如果您與 Linux 比較熟識：

目錄： C:\Users\\\<UserName>\AppData\Local\nvim-data 等同 Linux 的 ~/.local/share/nvim/ 。

## 安裝 Nvchad2025 客製化範本

Nvchad2025 即本專案所建置的 NvChad 2.5 參考範本！

### 最簡方式（一）

```sh
PS C:\Users\AlanJui> cd C:\Users\AlanJui\AppData\Local\
PS C:\Users\AlanJui> mv nvim nvim_bak
PS C:\Users\AlanJui\AppData\Local> git clone https://github.com/AlanJui/Nvchad2025.git nvim
```

【註】：

1. 上述 AlanJui 那是我的 <UserName> 帳號。

2. 當我啟動【Windows 終端機 + Windows PowerShell】之後，自【提示符號】可知目前正位於
   路徑為：C:\Users\AlanJui 之目錄。當我輸入【cd ~\App】之後，按 \<Tab> 鍵，便會自動轉換成目錄：
   C:\Users\AlanJui\AppData 。

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

3. 首次啟動 nvchad

首次啟動很重要！首次啟動很重要！首次啟動很重要！

```sh
nvchad
```

4. 下載 Nvchad2025 之 NvChad 2.5 參考範本

```sh
PS C:\Users\AlanJui> cd C:\Users\AlanJui\AppData\Local\
PS C:\Users\AlanJui> mv nvchad nvchad_bak
PS C:\Users\AlanJui\AppData\Local> git clone https://github.com/AlanJui/Nvchad2025.git nvchad
```

恭禧！您走到這裡，終於可以打完收工了。我承認以上的安裝程序不算 Smart ，
可能還有些「煩~~~」，但這也是目前我所能做到的極限。

敬請特別注意，此專案最主要目的只是在示範：NvChad V2.0 升級 V2.5 後，
想要客製自訂自用的 NvChad 該怎麼做，給出一個較完整的參考範例。故也請不要
期待此專案之産出可 Bug Free ；甚至要求我對有問題的地方，做立即處理反應。

最後，敬祝：「NvChad 2.5 使用順心、愉快！！」

## 其它（參考資訊）

以下資訊，為安裝過程，可能會遇到的問題；或是遇狀況需進行檢測的輔助指令。

### 更新系統環境變數

安裝：

```
refreshenv
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
```

範例：

```
PS C:\Users\AlanJui> refreshenv
RefreshEnv.cmd does not work when run from this process. If you're in PowerShell, please 'Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1' and try again.
PS C:\Users\AlanJui> Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
PS C:\Users\AlanJui> refreshenv
Refreshing environment variables from the registry for powershell.exe. Please wait...
Finished
PS C:\Users\AlanJui>
```

### 刪目錄

【PowerShell】

```
Remove-Item -Recurse -Force C:\Users\AlanJui\AppData\Local\nvim\lua\custom
Remove-Item -Recurse -Force ~\AppData\Local\nvim\lua\custom
```

【CMD】

```
rd /s /q Remove-Item -Recurse -Force C:\Users\AlanJui\AppData\Local\nvim\lua\custom
```

### 在 Windows 環境安裝 OpenSSL

```
fatal: unable to access 'https://github.com/tree-sitter/tree-sitter-scala/': OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 0
```

查檢 Git for Windows 是否使用 Windows 內建之 TLS 而非 OpenSSL

（1）設定 git 改用 OpenSSL

```
git config --global http.sslBackend openssl
```

（2）利用 git clone 驗證 OpenSSL 已能正常運作

```
git clone https://github.com/tree-sitter/tree-sitter-scala.git
```

【參考】：強制使用舊版 TLS 1.2 ；而不使用新版 1.3

```
git config --global http.sslVersion tls1.2
git clone https://github.com/tree-sitter/tree-sitter-scala.git
```

### 設定 Git 使用 OpenSSL, TLS 1.2

設定：

```
git config --global http.sslBackend openssl
git config --global http.sslVersion tls1.2
```

驗證：

```
git config --global http.sslBackend
openssl
```
