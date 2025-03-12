## 簡介

客製化自用的 nvim 作業環境時，因為要考量【不同作業系統間的切換】，如：Windows / Linux ；即便在 Windows 作業系統中，也需要考量目前所處的
Shell 是 CMD / PowerShell / Git Bash / MSYS2 何種？所以 Lua Script 撰碼，經常會引用下述判斷：
（1）目前處於何種作業系統：純 Linux ？還是 WSL2 ？或 Windows 11？
（2）使用 Windows 11 作業系統的環境，其【Windows 終端機】使用之 Shell 為： PowerShell / CMD / MSYS2 / Git Bash 何種？
（3）目錄路徑使用之【子目錄符號】，應為： "/" 或 "\\" ？

基於上述因素，産生以下兩項需求：

1. 需要在程式舘，建置一模組（utils.env），提供符合上述需求之 function ；
2. 需要有一類同 checkhealth 之指令，如：EnvCheck，可供查檢 nvim 所處之作業環境，並於畫面回報結果。

## 實作

### nvim 目錄結構

```sh
~/.config/nvim/
├── lua/
│   ├── plugins/
│   │   ├── ...
│   │   └── init.lua
│   ├── configs/
│   │   ├── ...
│   │   ├── conform.lua
│   │   └── lspconfig.lua
│   ├── utils/
│   │   ├── ...
│   │   ├── envcheck.lua
│   │   └── env.lua
│   ├── mappings.lua
│   ├── options.lua
│   └── chadrc.lua
└── init.lua
```

### 建置程式舘 utils.env

【檔案路徑】： [NvimRoot]/lua/utils/env.lua

```sh
-- lua/utils/env.lua
-- Last Change: 2021-04-10 16:52:52
--
-- 功能摘要：
-- (1) 辨識 Nvim 之作業環境：
--     is_win、is_linux、is_wsl 可判斷 Nvim 所處之作業系統。
--
-- (2) 判別應使用之【路徑分隔符號】：
--     提供 env.path_sep，方便組合路徑時使用。
--
-- (3) 取得常用工具路徑：
--     提供了 python 與 node 執行檔的動態路徑取得方式。

local M = {}

-- Windows 判斷
M.is_win = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

-- WSL 判斷
M.is_wsl = (function()
  if vim.fn.has "unix" ~= 1 then
    return false
  end
  local lines = vim.fn.readfile "/proc/version"
  return lines and #lines > 0 and lines[1]:lower():find "microsoft" ~= nil
end)()

-- Linux 判斷 (非 WSL)
M.is_linux = vim.fn.has "unix" == 1 and not M.is_wsl

-- 取得 MSYSTEM 變數
local msystem = vim.fn.getenv "MSYSTEM"
local msystem_str = (msystem ~= vim.NIL) and msystem or ""

-- Git Bash 判斷 (MSYSTEM 通常為 MINGW64)
M.is_git_bash = msystem_str == "MINGW64"

-- MSYS2 判斷 (其他 MSYSTEM 值)
local msys2_set = { UCRT64 = true, MSYS = true, MINGW32 = true, CLANG64 = true }
M.is_msys2 = msys2_set[msystem_str] == true

-- CMD 判斷 (透過環境變數 ComSpec 和 PROMPT)
local comspec = vim.fn.getenv "ComSpec"
local prompt = vim.fn.getenv "PROMPT"
M.is_cmd = comspec ~= vim.NIL and comspec:lower():match "cmd.exe" ~= nil and prompt ~= vim.NIL

-- 取得 Shell 環境
function M.get_shell()
  if M.is_win then
    if M.is_git_bash or M.is_msys2 then
      return { shell = "bash.exe", shellcmdflag = "-s" }
    elseif M.is_cmd then
      return { shell = "cmd.exe", shellcmdflag = "/c" }
    else
      return {
        shell = vim.fn.executable "powershell.exe" == 1 and "powershell.exe" or "pwsh.exe",
        shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
        shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
        shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode;",
        shellquote = "",
        shellxquote = "",
      }
    end
  else
    return { shell = "bash", shellcmdflag = "-c" }
  end
end

M.path_sep = M.is_win and "\\" or "/"

return M
```

### 建置作業環境查檢指令 EnvCheck

1. 建置查檢指令程式碼

【檔案路徑】： [NvimRoot]/lua/utils/envcheck.lua

```sh
local M = {}

local env = require "utils.env"
local tbl = require "utils.table"

function M.show_env_check()
  -- 建立新的 buffer 並切換到此 buffer
  local buf = vim.api.nvim_create_buf(false, true) -- 不儲存到檔案，true表示 scratch buffer
  vim.api.nvim_set_current_buf(buf)

  local lines = {
    "=========================================",
    " 🚧 Neovim 作業環境檢測報告",
    "=========================================",
    "",
    "📌 系統環境資訊：",
  }

  -- 判斷作業系統環境
  if env.is_win then
    table.insert(lines, " • 🪟 環境：Windows (原生)")
  elseif env.is_wsl then
    table.insert(lines, " • 🐧 環境：WSL2 (Windows Subsystem for Linux)")
  elseif env.is_linux then
    table.insert(lines, " • 🐧 環境：Linux (原生)")
  elseif env.is_mac then
    table.insert(lines, " • 🍎 環境：macOS")
  else
    table.insert(lines, " • ⚠️ 未知作業系統環境")
  end

  -- Shell 設定
  local shell_config = env.get_shell()
  vim.o.shell = shell_config.shell
  vim.o.shellcmdflag = shell_config.shellcmdflag

  table.insert(lines, "")
  table.insert(lines, "📌 Shell 環境設定：")
  table.insert(lines, " • 使用的 Shell：" .. tostring(vim.o.shell))
  table.insert(lines, " • Shell 指令參數：" .. tostring(vim.o.shellcmdflag))

  -- 插入資訊到 buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- buffer 設定為唯讀
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"

  -- 開啟預覽視窗
  vim.cmd "setlocal wrap"
end

return M
```

2. 在 Nvim 啟用指令

在【使用者選項設定檔】： lua/options.lua ，設定自訂指令：EnvCheck ，供使用者可透過 Nvim 的【指令列】，執行查檢所處作業環境之指令。

【檔案路徑】： [NvimRoot]/lua/options.lua

```sh
-- 在 Nvim 新增自訂指令：EnvCheck ，可供使用者查檢所處作業環境
vim.api.nvim_create_user_command("EnvCheck", function()
  require("utils.envcheck").show_env_check()
end, {})
```

### 用例展示

![2025-03-12_11-56-44](https://gist.github.com/user-attachments/assets/7efc280a-2507-4e8e-9c0e-ff31633edfc0)

![2025-03-12_11-58-11](https://gist.github.com/user-attachments/assets/63b37dbe-9aed-4c25-8771-ae21a763ec4a)

![2025-03-12_12-06-48](https://gist.github.com/user-attachments/assets/b8a18269-b2f7-44da-9a13-d8ab658a1053)

![2025-03-12_11-59-46](https://gist.github.com/user-attachments/assets/4260d4c0-5ef0-4ab6-9dce-64f18eb3b22e)


## 作業環境查檢判斷表

| 啟動環境               | is_win | is_git_bash | is_msys2 | is_cmd | 使用 shell       |
|--------------------|--------|-------------|----------|--------|----------------|
| Windows PowerShell | ✅      | ❌           | ❌        | ❌      | powershell.exe |
| Git Bash (MINGW64) | ✅      | ✅           | ❌        | ❌      | bash.exe       |
| MSYS2 (UCRT64)     | ✅      | ❌           | ✅        | ❌      | bash.exe       |
| MSYS2 (MSYS)       | ✅      | ❌           | ✅        | ❌      | bash.exe       |
| MSYS2 (CLANG64)    | ✅      | ❌           | ✅        | ❌      | bash.exe       |
| CMD                | ✅      | ❌           | ❌        | ✅      | cmd.exe        |
| WSL2 (Ubuntu)      | ❌      | ❌           | ❌        | ❌      | bash           |
| 純 Linux            | ❌      | ❌           | ❌        | ❌      | bash           |
