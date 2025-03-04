# NvChad 2.5 個人客製化指引

 NvChad 自 V2.5 起，變更了原先客製化環境的規格。原先的 lua/custom 作法已無效。

## 安裝前置條件

### 編譯工具

需要 C 編譯器，如：cc, gcc, clang, make, cl

- MinGW-w64 (gcc)
- GnuWin32 (make)
- LLVM/Clang (clang/gcc)

【重要】：務必設定 Path 系統環境變數。

```
setx CC "C:\mingw64\bin\gcc.exe"
```

### Nerd 字型

- 字型： MesloLGS Nerd Font Propo, LXGW WenKai Mono TC
- 尺寸： 16

### Python

- 版本：3.13
- 安裝路徑：C:\Program Files\Python313
- Path環境變數：要設定
- Provider 套件： pip install pynvim

### Node.js

- 版本：3.13
- 安裝路徑：C:\Program Files\nodejs
- Path環境變數：要設定
- Provider 套件： npm install -g neovim

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

### Lua Script 支援

- 版本：v2.4.4
- 權限：使用【系統管理員】身份
- 安裝路徑： C:\Users\AlanJui\AppData\Local\Temp\chocolatey\luarocks-2.4.4-win32
C:\Users\AlanJui\AppData\Roaming\LuaRocks

安裝操作：

```
$ choco install luarocks
$ refreshenv
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


## 安裝 Nvim

- 作業系統：Windows 11 Pro
- Nvim: V0.10.4 
- 發行版：nvim-win64.msi
- 安裝路徑：C:\Program Files\Neovim

## 安裝 NvChad 

使用【Windows終端機】【PowerShell介面】（不要使用【系統管理員】權限）

``` 
git clone https://github.com/NvChad/starter $ENV:USERPROFILE\AppData\Local\nvimnvim
nvim
```

## 其它

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


