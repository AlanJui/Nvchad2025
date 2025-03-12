return {
  {
    "williamboman/mason.nvim",
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
      ensure_installed = {
        "lua-language-server", -- Lua LSP Server
        "stylua",
        -- "pyright", -- Python LSP Server
        -- "pylint", -- Linter
        -- "ruff-lsp", -- Python LSP Server
        "clangd", -- C++ LSP Server
        "clang-format", -- Formatter
        "cpptools", -- C++ LSP Server
        "codelldb", -- C/C++ DAP
        "gopls",
        "rust-analyzer",
        "python-lsp-server", -- Python LSP Server
        "debugpy", -- python
        "black", -- Formatter
        "isort", -- Formatter
        "ruff", -- Linter
        "mypy", -- Type checker
        "pydocstyle", -- Docstring style checker
        "pyflakes", -- Linter
        "djlint", -- Linter
        "typescript-language-server", -- JavaScript LSP Server
        "vue-language-server",
        "js-debug-adapter", -- Javascript DAP
        "emmet-ls",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "eslint_d", -- JavaScript Linter
        "prettier", -- Formatter
        "json-lsp", -- JSON LSP Server
        "jsonlint", -- JSON Linter
        "lemminx", -- XML LSP Server
        "yaml-language-server",
        "yamllint", -- YAML Linter
        "taplo", -- TOML Lsp Server
        "marksman", -- Markdown LSP Server
        "markdownlint", -- Markdown Linter
        "dockerfile-language-server", -- Docker LSP Server
        "dockerfile-language-server", -- Dockerfile LSP Server
        "docker-compose-language-service", -- Docker Compose LSP Server
      },
    },
  },
  -- 需請 mason 安裝的 DAP for Neovim
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
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
