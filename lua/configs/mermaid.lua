-- Mermaid 預覽：依作業系統載入對應實作（不再綁在 plenary.nvim 的 lazy spec 上）
vim.filetype.add { extension = { mermaid = "mermaid" } }

local sys = vim.uv.os_uname().sysname
if sys == "Windows_NT" then
  require "configs.mermaid_win"
elseif sys == "Linux" then
  require "configs.mermaid_chafa"
end
