local conform = require "conform"

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Python 使用 ruff 來處理模組之排序與程式碼格式化
    python = {
      "ruff_organize_imports",
      "ruff_format",
    },
    ["c++"] = { "clang_format" },
    c = { "clang_format" },
    cpp = { "clang_format" },
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
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    -- Windows 啟動 ruff 較慢；兩個 formatter 串行時 500ms 容易超時
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

return options
