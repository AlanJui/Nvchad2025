return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUpdate",
      "MasonUninstallAll",
      "MasonLog",
    },
    opts = {
      providers = {
        "mason.providers.client",
        "mason.providers.registry-api",
      },
    },
  },
  -- 需請 mason 安裝的 DAP for Neovim
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    -- config = function()
    --   require("mason-nvim-dap").setup {
    --     handers = {},
    --     ensure_installed = {
    --       "python",
    --       "codelldb",
    --       "js",
    --       "stylua",
    --     },
    --   }
    -- end,
  },
}
