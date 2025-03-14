require "nvchad.options"

local env = require "utils.env"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
-- -------------------------------------------------
-- Proviers for Nvim
-- -------------------------------------------------
-- 以下這行如果是 0 代表關掉 Node provider，因此要注解或移除
-- vim.g.loaded_node_provider = 0
-- vim.g.loaded_python3_provider = 0

-------------------------------------------------
-- 設定 Provider
-------------------------------------------------

-- Node.js Provider
-- 使用 n 管理 Node.js 直譯器： os.getenv("HOME") .. "/n/bin/neovim-node-host"
-- 假設全域路徑在 /usr/local/bin/neovim-node-host
-- 注意: Windows ==> C:\Users\AlanJui\AppData\Roaming\fnm\node-versions\v22.8.0\installation\neovim-node-host.ps1
-- local env = require("utils.env")
local node_host_prog = env.get_node_host_prog()
if node_host_prog then
  vim.g.node_host_prog = node_host_prog
  vim.g.loaded_node_provider = 1
else
  vim.notify("找不到 neovim-node-host 路徑！", vim.log.levels.WARN)
end

-- Python Provider
if env.is_win then
  -- Windows 環境的設定
  -- 請確認檔案路徑中使用「\\」做跳脫，或使用正斜線 "/"

  -- Python 3
  -- local py_win = "C:\\Python39\\python.exe"
  local py_win = "C:\\Program Files\\Python313\\python.exe"
  -- 如果想先檢查該檔案是否可執行，可加:
  if vim.fn.executable(py_win) == 1 then
    vim.g.python3_host_prog = py_win
    vim.g.loaded_python3_provider = 1
  end
else
  -- Linux 或其他 Unix-like 環境
  -- 假設你在 Linux 使用 pyenv 的 python3
  local home_dir = os.getenv "HOME" or "~"
  local python_version = "3.12.1"
  local py_linux = home_dir .. "/.pyenv/versions/" .. python_version .. "/bin/python"

  if vim.fn.executable(py_linux) == 1 then
    vim.g.python3_host_prog = py_linux
  end
end

-- using with vscode extensions. i.e ~/.vscode/extensions/deinsoftware.vitest-snippets-1.8.0
if env.is_win then
  vim.g.vscode_snippets_path = "C:/Users/AlanJui/AppData/Local/nvim/my_snippets"
else
  vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/my_snippets"
end

-------------------------------------------------
-- 個人設定
-------------------------------------------------
local opt = vim.opt

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- Disable swap file
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Folding
opt.foldcolumn = "1"
opt.foldlevel = 99 --- Using ufo provider need a large value
opt.foldlevelstart = 99 --- Expand all folds by default
opt.foldenable = true --- Use spaces instead of tabs
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Diable line wrap
opt.wrap = false

-- tabs
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-------------------------------------------------
-- 設置剪貼板
-------------------------------------------------
if env.is_win then
  -- vim.cmd [[
  --   set clipboard+=unnamedplus
  -- ]]
  -- WSL Support on PowerShell
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
  -- Linux
  vim.o.clipboard = "unnamedplus"
end

-------------------------------------------------
-- 自動停用拼字檢查
-------------------------------------------------
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "terminal" },
--   callback = function()
--     vim.opt_local.spell = false
--   end,
-- })
-- 預設：拼字檢查關閉
vim.opt.spell = false

-- 若要特定檔案類型才啟用拼字檢查，可以用 autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cjk" } -- 或 "en,cjk"
  end,
})

-------------------------------------------------
-- 自訂拼字典
-- 開啟拼字檢查： :set spell
-- 關閉拼字檢查： :set nospell
-- 切換拼字檢查： :set spell!
-- 切換拼字檢查： :set spelllang=en,cjk
-- 切換拼字檢查： :set spelllang=en
-- 字典檔案路徑： ~/.config/nvim/spell/en.utf-8.add
-- 在字典加字： :spellgood filetype, isort, black, djlint
-------------------------------------------------
vim.opt.spelllang = { "en", "cjk" } -- 只檢查英文
-- 透過環境變數取得家目錄
local home_dir = os.getenv "HOME" or os.getenv "USERPROFILE"

-- 自訂拼字檔最終路徑
local custom_spellfile = ""

if env.is_win then
  -- Windows 的拼字檔放在 C:\Users\<使用者>\AppData\Local\nvim\spell\
  -- 你也可以直接寫死完整路徑
  custom_spellfile = home_dir .. "\\AppData\\Local\\nvim\\spell\\en.utf-8.add"
else
  -- Linux/macOS 則放 ~/.config/nvim/spell/en.utf-8.add
  custom_spellfile = home_dir .. "/.config/nvim/spell/en.utf-8.add"
end

-- 如果路徑中使用正斜線也能在 Windows 運行，Neovim 通常能識別
-- 但保險起見，Windows 上用 "\\"（跳脫的反斜線）較為穩定

-- 設定 Neovim 讀取這個拼字檔
vim.opt.spellfile = { vim.fn.expand(custom_spellfile) }

-- 拼字檢查開/關快捷鍵
vim.keymap.set("n", "<leader>ts", function()
  vim.opt.spell = not vim.opt.spell:get()
  if vim.opt.spell:get() then
    print "拼字檢查已開啟"
  else
    print "拼字檢查已關閉"
  end
end, { desc = "開關拼字檢查" })

---------------------------------------------------
-- 設定 Shell：預設情況下，使用 Windows PowerShell，
-- 但若 Neovim 已經從 Git Bash (MINGW64) 中啟動時，
-- 則改用 Git Bash 作為 shell。
---------------------------------------------------
-- 判斷是否 Shell 為 MINGW64 Bash
local is_win_nt = vim.loop.os_uname().sysname == "Windows_NT"

if is_win_nt then
  -- 偵測是否在 Git Bash 環境啟動 (檢查環境變數 MSYSTEM 是否存在)
  if vim.fn.getenv "MSYSTEM" ~= vim.NIL then
    -- 若在 Git Bash 啟動，則使用 Git Bash
    vim.o.shell = "bash.exe"
    vim.o.shellcmdflag = "-s"
  else
    -- 預設： Windows PowerShell
    vim.o.shell = "powershell.exe"
    local powershell_options = {
      shell = vim.fn.executable "powershell" == 1 and "powershell.exe" or "pwsh",
      shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
      shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
      shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
      shellquote = "",
      shellxquote = "",
    }
    for option, value in pairs(powershell_options) do
      vim.opt[option] = value
    end
  end
end

-- 在 Nvim 新增自訂指令：EnvCheck ，可供使用者查檢所處作業環境
vim.api.nvim_create_user_command("EnvCheck", function()
  require("utils.envcheck").show_report()
end, {})
