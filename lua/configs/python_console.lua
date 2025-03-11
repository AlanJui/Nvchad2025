local Terminal = require("toggleterm.terminal").Terminal

local python = Terminal:new {
  cmd = "python",
  direction = "float",
}

function PythonToggle()
  python:toggle()
end

vim.keymap.set("n", "<leader>0", "<cmd>lua NodeToggle()<cr>", { desc = "Node.js Console" })
