-- 載入 NvChad 預設的基礎配置：
-- defaults() 會註冊 LspAttach（設定 gd / gD / <leader>ra 等）、
-- 透過 vim.lsp.config("*", ...) 套用 capabilities 與 on_init，
-- 並啟用 lua_ls。
require("nvchad.configs.lspconfig").defaults()

-- 通用伺服器：沿用 defaults() 的全域設定即可
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

for _, lsp in ipairs(default_servers) do
  vim.lsp.enable(lsp)
end

-- ########## Python 特化配置 ##########

-- 讓 LSP 預覽視窗擁有圓角邊框 (vim.lsp.with 已於 0.12 移除，改用閉包包裝)
local handlers = {
  ["textDocument/hover"] = function(err, result, ctx, config)
    vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, { border = "rounded" }))
  end,
  ["textDocument/signatureHelp"] = function(err, result, ctx, config)
    vim.lsp.handlers.signatureHelp(err, result, ctx, vim.tbl_extend("force", config or {}, { border = "rounded" }))
  end,
}

-- Ruff：保留 lint／code action；format 交給 conform，hover 交給 Pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ruff_lsp_caps", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})

-- 1. 配置 Pyright (負責補全與跳轉)
vim.lsp.config("pyright", {
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

-- 2. 啟用 Ruff (負責 Linting；格式化由 conform 處理)
vim.lsp.enable "ruff"

-- ########## 其他特殊設定 (Lua, YAML...) ##########
-- 只補伺服器專屬 settings；capabilities / on_init / on_attach 已由 defaults() 處理。
-- lua_ls 的設定會與 NvChad 預設（runtime、workspace.library）深層合併。

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
vim.lsp.enable "lua_ls"

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})
vim.lsp.enable "yamlls"

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
