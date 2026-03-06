return {
  -- disable a default nvchad plugin
  -- { "folke/which-key.nvim",  enabled = false },
  { "folke/which-key.nvim", lazy = false },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cpp",
        "python",
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- {
  --   "barrett-ruth/live-server.nvim",
  --   build = "pnpm add -g live-server", -- 或 npm install -g live-server
  --   cmd = { "LiveServerStart", "LiveServerStop" },
  --   config = function()
  --     require("live-server").setup()
  --   end,
  -- },

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- 可選，用於選擇文件
    -- cmd = { "LivePreview" },
    opts = {
      port = 5500,
      browser = "default", -- 或指定瀏覽器如 "google-chrome"
      picker = "telescope", -- 使用 Telescope 來選擇文件
    },
    config = function(_, opts)
      require("live-preview").setup(opts)

      -- 建立一個自定義指令 :LPC (Live Preview Current)
      vim.api.nvim_create_user_command("LPC", function()
        vim.cmd("LivePreview " .. vim.fn.expand "%:p")
      end, {})

      -- Auto save on insert leave or text change
      vim.o.autowriteall = true
      vim.api.nvim_create_autocmd({ "InsertLeavePre", "TextChanged", "TextChangedP" }, {
        pattern = "*",
        callback = function()
          vim.cmd "silent! write"
        end,
      })
    end,
  },
}
