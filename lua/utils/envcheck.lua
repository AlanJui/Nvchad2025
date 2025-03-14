-- lua/utils/envcheck.lua
local env = require "utils.env"

local M = {}

function M.show_report()
  local lines = {
    "=========================================",
    "🚧 Neovim 作業環境檢測報告",
    "=========================================",
    "",
    "📌 系統環境資訊：",
    string.format(
      "• 🪟 作業系統：%s",
      env.is_win and "Windows (原生)" or env.is_wsl and "WSL2" or env.is_linux and "Linux" or "未知"
    ),
    string.format("• 系統介面（Shell）：%s", env.shell_name),
    "",
    "📌 Shell 環境設定：",
    string.format("• 使用的 Shell：%s", env.get_shell().shell),
    string.format("• Shell 指令參數：%s", env.get_shell().shellcmdflag),
    "",
    "📌 子目錄設定：",
    string.format("• 目錄分隔符號：%s", env.path_sep),
  }

  -- 建立全螢幕的新 buffer 顯示報告
  vim.cmd "tabnew"
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- 調整視窗為唯讀模式，避免誤修改
  vim.cmd "setlocal nomodifiable readonly"
end

return M
