# NvChad 2.5 個人客製化指引

NvChad 自 V2.5 起，變更了原先客製化環境的規格。原先的 lua/custom 作法已無效。

以下之安裝指引，主要流程分以下三大程序：

1. 備妥【安裝前置條件】
2. 安裝 Neovim App
3. 安裝 Nvchad2025 客製化範本

## 1. 安裝前置條件

為使 NvChad 能一次安裝搞定，建議在安裝 Nvchad 前最好能先安裝好這些：
工具性軟體（如：程式碼編譯/連結工具）、作業系統層級之軟體套件（如：ripgrep 模糊搜尋）、
圖標字型（Nerd Font）、... 。

講坦白，這工作很漫長，又極其無聊，得耐著性子熬過。關於 nvim 安裝前置作業，
有需要的朋友可參考此[《nvim 安裝前置作業指引》](docs/PreInstall_Guide.md)。

## 2. 安裝 Neovim App

- 作業系統：Windows 11 Pro
- Nvim: V0.10.4
- 發行版：[nvim-win64.msi](https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-win64.msi)
- 安裝路徑：C:\Program Files\Neovim

## 3. 安裝 Nvchad2025 客製化範本

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
