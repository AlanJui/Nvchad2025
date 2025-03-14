-- lua/utils/env.lua
local M = {}

-- Windows判斷
M.is_win = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

-- WSL判斷
M.is_wsl = (function()
  if vim.fn.has "unix" ~= 1 then
    return false
  end
  local lines = vim.fn.readfile "/proc/version"
  return lines and #lines > 0 and lines[1]:lower():find "microsoft" ~= nil
end)()

-- 純Linux
M.is_linux = vim.fn.has "unix" == 1 and not M.is_wsl

-- MSYSTEM環境變數
local msystem = vim.fn.getenv "MSYSTEM"
local msystem_str = (msystem ~= vim.NIL) and msystem or ""

-- Git Bash (通常為MINGW64)
M.is_git_bash = msystem_str == "MINGW64"

-- MSYS2 (其他MSYSTEM值)
local msys2_set = { UCRT64 = true, MSYS = true, MINGW32 = true, CLANG64 = true }
M.is_msys2 = msys2_set[msystem_str] == true

-- CMD (透過ComSpec判斷)
local comspec = vim.fn.getenv "ComSpec"
local prompt = vim.fn.getenv "PROMPT"
M.is_cmd = comspec ~= vim.NIL and comspec:lower():match "cmd.exe" ~= nil and prompt ~= vim.NIL

-- PowerShell (預設)
M.is_powershell = M.is_win and not (M.is_cmd or M.is_git_bash or M.is_msys2)

-- Shell 名稱與目錄分隔符號
if M.is_git_bash then
  M.shell_name = "Git Bash (MINGW64)"
  M.path_sep = "/"
elseif M.is_msys2 then
  M.shell_name = "MSYS2 (MINGW64)"
  M.path_sep = "/"
elseif M.is_cmd then
  M.shell_name = "CMD"
  M.path_sep = "\\"
elseif M.is_powershell then
  M.shell_name = "PowerShell"
  M.path_sep = "\\"
elseif M.is_wsl then
  M.shell_name = "WSL2"
  M.path_sep = "/"
elseif M.is_linux then
  M.shell_name = "Bash / Zsh"
  M.path_sep = "/"
else
  M.shell_name = "Unknown"
  M.path_sep = "/"
end

-- 獲取shell設定
function M.get_shell()
  if M.is_git_bash or M.is_msys2 then
    return { shell = "bash.exe", shellcmdflag = "-s" }
  elseif M.is_cmd then
    return { shell = "cmd.exe", shellcmdflag = "/c" }
  elseif M.is_powershell then
    return {
      shell = vim.fn.executable "powershell.exe" == 1 and "powershell.exe" or "pwsh.exe",
      shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
      shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
      shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode;",
      shellquote = "",
      shellxquote = "",
    }
  else
    return { shell = "bash", shellcmdflag = "-c" }
  end
end

-- 自動抓取 fnm 設定的 Node.js 版本
function M.get_node_version()
  local handle = io.popen "fnm current"
  if not handle then
    return nil -- 防 io.popen() 執行失敗
  end

  local result = handle:read "*a"
  handle:close()

  if not result or result == "" then
    return nil -- 防讀取不到任何資料
  end

  result = result:gsub("\n", "") -- 移除換行符號
  return result
end

function M.get_fnm_node()
  -- 執行 PowerShell 命令取得 node.exe 的真實路徑
  local command = 'powershell.exe -Command "(Get-Command node.exe).Source"'
  local handle = io.popen(command)
  if not handle then
    return nil
  end

  local result = handle:read "*a"
  handle:close()

  -- 移除換行符號及空白
  result = result:gsub("[\r\n]+", "")

  if result == "" then
    return nil -- 找不到 node 路徑
  end

  return result
end

function M.get_node_host_prog()
  local node_path = M.get_fnm_node()
  if not node_path then
    return nil
  end

  -- 取得 Node.js 所在目錄
  local node_dir = node_path:match "(.*)[/\\]node%.exe$"
  if not node_dir then
    return nil
  end

  local host_prog = ""

  if M.is_powershell then
    host_prog = node_dir .. "\\neovim-node-host.ps1"
  elseif M.is_cmd then
    host_prog = node_dir .. "\\neovim-node-host.cmd"
  else
    -- 預設其他情況 (WSL/Git Bash等)
    -- host_prog = node_dir .. "/neovim-node-host"
    -- ~/n/lib/node_modules/neovim/bin/cli.js
    host_prog = os.getenv "HOME" .. "/n/bin/neovim-node-host"
  end

  return host_prog
end

return M
