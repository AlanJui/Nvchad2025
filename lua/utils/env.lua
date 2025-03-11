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

-- 偵測是否為 Windows
M.is_win = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1

-- 偵測是否為 WSL (Windows Subsystem for Linux)
M.is_wsl = (function()
  if vim.fn.has "unix" ~= 1 then
    return false
  end
  local lines = vim.fn.readfile "/proc/version"
  if lines and #lines > 0 then
    return lines[1]:lower():find "microsoft" ~= nil
  end
  return false
end)()

-- 偵測純 Linux (非 WSL)
M.is_linux = vim.fn.has "unix" == 1 and not M.is_wsl

-- 偵測 Git Bash 或 MSYS2 (MSYSTEM 存在即視為 Git Bash 或 MSYS2)
local msystem = vim.fn.getenv "MSYSTEM"
M.is_gitbash_or_msys2 = msystem ~= vim.NIL and msystem:match "MINGW" ~= nil

-- 偵測 CMD 啟動 (ComSpec 為 CMD 的環境變數)
local comspec = vim.fn.getenv "ComSpec"
local parent_proc = vim.fn.getenv "PROMPT"
M.is_cmd = comspec ~= vim.NIL and comspec:lower():match "cmd.exe" ~= nil and parent_proc ~= vim.NIL

-- 取得使用中的 Shell 環境
function M.get_shell()
  if M.is_win then
    if M.is_gitbash_or_msys2 then
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

-- 路徑分隔符號
M.path_sep = M.is_win and "\\" or "/"

return M
