-- 使用 diagram.nvim 在 Neovim 中渲染 Mermaid、PlantUML、D2 等圖表
-- 僅在 Linux / WSL2 環境啟用（Windows 原生會停用）
-- 需要安裝外部工具：
-- npm i -g @mermaid-js/mermaid-cli
return {
  {
    "3rd/image.nvim",
    enabled = function()
      return vim.loop.os_uname().sysname == "Linux" -- 只在 Linux/WSL 啟用
    end,
    opts = {
      backend = "chafa", -- ★ 強迫使用 chafa，避免走 magick
      integrations = {
        markdown = { enabled = true },
        neorg = { enabled = false },
      },
      editor_only_render_when_focused = true,
    },
  },
}
-- return {
--   {
--     "jbyuki/diagram.nvim",
--     ft = { "mermaid", "markdown" },
--     keys = {
--       { "<leader>mr", "<cmd>lua require('diagram').render()<CR>", desc = "Render Mermaid inline" },
--     },
--     config = function()
--       require("diagram").setup {
--         renderer = {
--           mermaid = {
--             command = "mmdc", -- Mermaid CLI
--             args = { "-i", "$FILENAME", "-o", "$OUTPUT" },
--           },
--         },
--         viewer = "chafa", -- or "catimg", "viu" 等
--       }
--     end,
--   },
-- }
