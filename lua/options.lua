require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
-- -------------------------------------------------
-- Proviers for Nvim
-- -------------------------------------------------
-- 以下這行如果是 0 代表關掉 Node provider，因此要注解或移除
-- vim.g.loaded_node_provider = 0
-- vim.g.loaded_python3_provider = 0

-- 判斷作業系統 (Windows vs. Unix-like)
local is_win = (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1)

if is_win then
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

  -- Node.js
  -- 假設全域路徑在 /usr/local/lib/node_modules/neovim/bin/cli.js
  -- 注意: Windows 會是類似 C:\\Users\\<username>\\AppData\\Roaming\\npm\\node_modules\\neovim\\bin\\cli.js
  local node_win = "C:\\Program Files\\nodejs\\node.exe"
  if vim.fn.executable(node_win) == 1 then
    vim.g.node_host_prog = node_win
    vim.g.loaded_node_provider = 1
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

  -- Node host (假設你用 n 管理器)
  local node_linux = home_dir .. "/n/bin/neovim-node-host"
  if vim.fn.executable(node_linux) == 1 then
    vim.g.node_host_prog = node_linux
  end
end
-- using with vscode extensions. i.e ~/.vscode/extensions/deinsoftware.vitest-snippets-1.8.0
vim.g.vscode_snippets_path = "C:/Users/AlanJui/AppData/Local/nvim/my_snippets"

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
if is_win then
  -- WSL Support on PowerShell
  -- vim.g.clipboard = {
  --   name = 'WslClipboard',
  --   copy = {
  --     ['+'] = 'clip.exe',
  --     ['*'] = 'clip.exe',
  --   },
  --   paste = {
  --     ['+'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --     ['*'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  --   },
  --   cache_enabled = 0,
  -- }
  vim.cmd [[
    set clipboard+=unnamedplus
  ]]
else
  -- Linux
  vim.o.clipboard = "unnamedplus"
end
