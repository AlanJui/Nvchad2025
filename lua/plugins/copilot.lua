-- AI auto-completion
return {
  {
    "AndreM222/copilot-lualine",
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    -- enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      require("copilot").setup {
        panel = {
          -- enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "right", -- | top | bottom | left | right
            ratio = 0.3,
          },
        },
        suggestion = {
          -- enabled = true,
          -- debounce = 75,
          auto_trigger = true,
          keymap = {
            accept = "<C-]>",
            accept_word = "<C-Right>",
            accept_line = "<C-End>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-[>",
          },
        },
        filetypes = {
          -- markdown = false,
          yaml = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        -- copilot_node_command = "node", -- Node.js version must be > 18.x
        -- server_opts_overrides = {},
      }
    end,
  },
}
