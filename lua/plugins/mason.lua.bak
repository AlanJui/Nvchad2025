local mason_list = {
  "lua-language-server", -- Lua LSP Server
  "stylua",
  -- "pyright", -- Python LSP Server
  -- "pylint", -- Linter
  -- "ruff-lsp", -- Python LSP Server
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
  "rust-analyzer", -- Rust LSP Server
  "clangd", -- C/C++ LSP Server
  "codelldb", -- C/C++ DAP
  "clang-format", -- Formatter
  "dockerfile-language-server", -- Dockerfile LSP Server
  "docker-compose-language-service", -- Docker Compose LSP Server
}

return {
  "williamboman/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- enable mason and configure icons
    require("mason").setup {
      ensure_installed = mason_list,
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },
        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          cancel_installation = "<C-c>",
        },
      },
      max_concurrent_installers = 10,
    }

    -- Install all bianries that mason supported
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      if mason_list and #mason_list > 0 then
        vim.cmd("MasonInstall " .. table.concat(mason_list, " "))
      end
    end, {})

    vim.g.mason_binaries_list = mason_list
  end,
}
