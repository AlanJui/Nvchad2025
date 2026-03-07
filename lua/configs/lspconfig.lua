-- 載入 NvChad 預設的基礎配置 (如 on_attach, capabilities)
-- require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"
local on_attach = nvlsp.on_attach
local on_init = nvlsp.on_init
local capabilities = nvlsp.capabilities

-- 定義通用伺服器 (這些使用預設配置即可)
local default_servers = {
  "clangd",
  "cssls",
  "vuels",
  "tailwindcss",
  "marksman",
  "ts_ls",
  "html",
  "emmet_ls",
  "jsonls",
  "lemminx",
}

-- 使用新版的 vim.lsp.enable 批次啟用預設伺服器
for _, lsp in ipairs(default_servers) do
  vim.lsp.enable(lsp)
end

-- ########## Python 特化配置 (採用新版建議語法) ##########

-- 讓 LSP 預覽視窗擁有圓角邊框
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" }),
}
-- 1. 配置 Pyright (負責補全與跳轉)

vim.lsp.config("pyright", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  handlers = handlers,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
        -- 關閉 Pyright 的診斷，全部交給 Ruff，避免重複顯示錯誤
        ignore = { "*" },
      },
    },
  },
})
vim.lsp.enable "pyright"

-- 2. 配置 Ruff (負責 Linting 與 Formatting)
vim.lsp.config("ruff", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.enable "ruff"

-- ########## 其他特殊設定 (Lua, YAML...) ##########

-- Lua
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
vim.lsp.enable "lua_ls"

-- YAML
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})
vim.lsp.enable "yamlls"

-- 定義更有設計感的圖示
local signs = {
  Error = " ", -- 圓圈交叉：錯誤
  Warn = " ", -- 三角驚嘆：警告
  Hint = "󰠠 ", -- 燈泡：提示
  Info = " ", -- 圓圈資訊：訊息
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 進一步美化診斷訊息的顯示方式
vim.diagnostic.config {
  virtual_text = {
    prefix = "▎", -- 使用優雅的豎線作為虛擬文字的前綴
    spacing = 4,
  },
  float = {
    border = "rounded", -- 讓浮動視窗變成圓角，視覺上更柔和
    source = "always", -- 顯示錯誤來源 (如: Pyright, Ruff)
  },
  update_in_insert = false, -- 打字時不跳出錯誤，保持專注，存檔後再顯示
}
