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

-- lua/utils/env.lua
local M = {}

-- 偵測作業系統是否為 Windows
M.is_win = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

-- 偵測是否為 WSL (Windows Subsystem for Linux)
M.is_wsl = (function()
  if vim.fn.has "unix" ~= 1 then
    return false
  end
  local lines = vim.fn.readfile "/proc/version"
  if lines and #lines > 0 then
    return string.lower(lines[1]):find "microsoft" ~= nil
  end
  return false
end)()

-- 偵測是否為純 Linux (非 WSL)
M.is_linux = vim.fn.has "unix" == 1 and not M.is_wsl

-- 偵測 Neovim 是否從 Git Bash 啟動
local msystem = vim.fn.getenv "MSYSTEM"
M.is_git_bash = msystem ~= vim.NIL and msystem:match "MINGW" ~= nil

-- 取得使用中的 Shell 環境
function M.get_shell()
  if M.is_win then
    if M.is_git_bash then
      return { shell = "bash.exe", shellcmdflag = "-s" }
    else
      return {
        shell = "powershell.exe",
        shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
        shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
        shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode;",
      }
    end
  else
    -- Linux 或 WSL 使用預設 shell
    return { shell = "bash", shellcmdflag = "-c" }
  end
end

-- 路徑分隔符號
M.path_sep = M.is_win and "\\" or "/"

-- 根據環境設定 Python 路徑
function M.get_python()
  if M.is_win then
    return "C:\\Program Files\\Python313\\python.exe"
  else
    local home_dir = os.getenv "HOME" or "~"
    local python_version = "3.12.1"
    return home_dir .. "/.pyenv/versions/" .. python_version .. "/bin/python"
  end
end

-- Node.js 路徑
function M.get_node()
  if M.is_win then
    return "C:\\Program Files\\nodejs\\node.exe"
  else
    local home_dir = os.getenv "HOME" or "~"
    return home_dir .. "/.nvm/versions/node/v22.7.0/bin/node"
  end
end

return M
