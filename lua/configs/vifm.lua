-- 設置 Command Line 檔案管理員
local Terminal = require("toggleterm.terminal").Terminal

local vifm = Terminal:new {
  cmd = "vifm",
  direction = "float",
}

function VifmToggle()
  vifm:toggle()
end

local map = vim.keymap.set
map("n", "<leader>8", "<cmd>lua VifmToggle()<cr>", { desc = "ViFm" })
