-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  -- theme = "onedark",
  -- theme = "decay",
  theme = "catppuccin",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    lazyload = false,
  },
}

-- MasonInstallAll 會安裝這裡列出的套件（mason.nvim 本身會忽略 opts.ensure_installed）
M.mason = {
  pkgs = {
    -- Python
    "pyright",
    "ruff",
    "mypy",
    "debugpy",
    "djlint",
    -- Web
    "typescript-language-server",
    "vue-language-server",
    "js-debug-adapter",
    "emmet-ls",
    "html-lsp",
    "css-lsp",
    "tailwindcss-language-server",
    "eslint_d",
    "stylua",
    "prettier",
    "json-lsp",
    "jsonlint",
    -- YAML
    "yaml-language-server",
    "yamllint",
    -- C/C++
    "clangd",
    "clang-format",
    "cpptools",
    "codelldb",
    -- Markdown
    "marksman",
    "markdownlint",
    -- Other languages
    -- "gopls",
    "taplo",
    "rust-analyzer",
    "lemminx",
    -- Docker
    "dockerfile-language-server",
    "docker-compose-language-service",
  },
}

return M
