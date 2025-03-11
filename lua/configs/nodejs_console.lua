-- 建置 Node.js Console Terminal
local Terminal = require("toggleterm.terminal").Terminal

local node = Terminal:new {
  cmd = "node",
  direction = "float",
}

function NodeToggle()
  node:toggle()
end

vim.keymap.set("n", "<leader>9", "<cmd>lua PythonToggle()<cr>", { desc = "Python" })
