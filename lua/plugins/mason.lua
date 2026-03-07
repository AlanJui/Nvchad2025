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
      providers = {
        "mason.providers.client",
        "mason.providers.registry-api",
      },
      ensure_installed = {
        -- Python 核心組合
        "pyright", -- LSP: 負責補全、定義跳轉、靜態類型分析
        "ruff", -- LSP/Linter/Formatter: 負責語法檢查、格式化 (取代了 black, isort, pyflakes)
        "mypy", -- Type checker
        "debugpy", -- python
        "djlint", -- Linter
        -- Web 前端核心組合
        "typescript-language-server", -- JavaScript LSP Server
        "vue-language-server",
        "js-debug-adapter", -- Javascript DAP
        "emmet-ls",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "eslint_d", -- JavaScript Linter
        "stylua",
        "prettier", -- Formatter
        "json-lsp", -- JSON LSP Server
        "jsonlint", -- JSON Linter
        -- YAML
        "yaml-language-server",
        "yamllint", -- YAML Linter
        -- C/C++ 核心組合
        "clangd", -- C++ LSP Server
        "clang-format", -- Formatter
        "cpptools", -- C++ LSP Server
        "codelldb", -- C/C++ DAP
        -- Markdown
        "marksman", -- Markdown LSP Server
        "markdownlint", -- Markdown Linter
        -- 其他語言
        "taplo", -- TOML Lsp Server
        "gopls",
        "rust-analyzer",
        "lemminx", -- XML LSP Server
        -- Docker
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
