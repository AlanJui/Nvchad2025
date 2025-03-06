return {
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
  config = function()
    -- enable mason and configure icons
    require("mason").setup {
      ensure_installed = {
        "lua-language-server", -- Lua LSP Server
        "stylua",
        -- "pyright", -- Python LSP Server
        -- "pylint", -- Linter
        -- "ruff-lsp", -- Python LSP Server
        "clangd",
        "gopls",
        "rust-analyzer",
        "codelldb", -- C/C++ DAP
        "clang-format", -- Formatter
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
    }
  end,
}
