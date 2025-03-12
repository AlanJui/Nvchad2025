-- 確保 Mason 先執行 setup()
local mason = require "mason"
mason.setup()

require("mason-nvim-dap").setup {
  handers = {},
  ensure_installed = {
    "python",
    "codelldb",
    "js",
    "stylua",
  },
}
