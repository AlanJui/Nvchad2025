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
