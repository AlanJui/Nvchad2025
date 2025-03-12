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
