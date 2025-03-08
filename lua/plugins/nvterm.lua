-- https://github.com/zbirenbaum/nvterm
return {
  "NvChad/nvterm",
  config = function()
    require("nvterm").setup {
      terminals = {
        shell = vim.o.shell,
      },
    }

    local terminal = require "nvterm.terminal"
    local toggle_modes = { "n", "t" }
    local mappings = {
      {
        toggle_modes,
        "<A-h>",
        function()
          terminal.toggle "horizontal"
        end,
      },
      {
        toggle_modes,
        "<A-v>",
        function()
          terminal.toggle "vertical"
        end,
      },
      {
        toggle_modes,
        "<A-i>",
        function()
          terminal.toggle "float"
        end,
      },
    }
    local opts = { noremap = true, silent = true }
    for _, mapping in ipairs(mappings) do
      vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
    end
  end,
}
