local conform = require "conform"

local options = {
  formatters_by_ft = {
    ["c++"] = { "clang_format" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    -- yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    svelte = { "prettier" },
    -- python = { "isort", "black", "djlint" },
    python = function(bufnr)
      if conform.get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black", "djlint" }
      end
    end,

    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
