return {
  -- disable a default nvchad plugin
  -- { "folke/which-key.nvim",  enabled = false },
  { "folke/which-key.nvim", lazy = false },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
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

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- 可選，用於選擇文件
    cmd = { "LivePreview", "LPC" },
    opts = {
      -- port = 5555,
      port = 8086,
      browser = "default", -- 或指定瀏覽器如 "google-chrome"
      picker = "telescope", -- 使用 Telescope 來選擇文件
    },
    config = function(_, opts)
      require("live-preview").setup(opts)

      -- 自定義指令 LPC
      vim.api.nvim_create_user_command("LPC", function()
        -- 加上 silent! 嘗試壓制可能的系統報錯
        vim.cmd("silent! LivePreview start " .. vim.fn.expand "%:p")
      end, {})

      -- 自動存檔：稍微優化了效能
      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        pattern = { "*.md", "*.html" }, -- 針對性存檔，不要全域觸發
        callback = function()
          if vim.bo.modified then
            vim.cmd "silent! write"
          end
        end,
      })
    end,
  },
}
