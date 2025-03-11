-- 建置 LazyGit Terminal
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new {
  cmd = "lazygit",
  hidden = true,
  direction = "float",
}

function LazygitToggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<leader>gl", "<cmd>lua LazygitToggle()<cr>", { desc = "LazyGit" })
