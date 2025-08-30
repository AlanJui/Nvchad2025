-- 使用 diagram.nvim 在 Neovim 中渲染 Mermaid、PlantUML、D2 等圖表（只在 Linux/WSL2 啟用）
-- 需要安裝 graphviz、mermaid-cli、plantuml 等外部工具
return {
  {
    "3rd/diagram.nvim",
    -- 只在 Linux（含 WSL2）啟用
    enabled = function()
      local sys = vim.loop.os_uname().sysname
      -- 在 WSL2 裡跑的 nvim 其 sysname 也是 "Linux"
      return sys == "Linux"
    end,
    lazy = true, -- 只在需要時載入
    ft = { "markdown", "mermaid", "plantuml", "d2" },
    dependencies = {
      "3rd/image.nvim", -- 內嵌渲染圖片，需要在 Linux/WSL2 使用（Windows 原生不支援）
    },
    opts = {
      -- 自動轉換圖表的事件（可改成 {"BufWritePost"} 表示存檔才渲染）
      render_on_events = { "TextChanged", "InsertLeave" },

      -- 內嵌渲染
      renderer = "image.nvim",

      -- Mermaid 後端參數
      mermaid = {
        theme = "default", -- 可選 'dark' 'neutral' 'forest'
        background = "transparent",
        scale = 1.0,
      },
    },
    keys = {
      {
        "<leader>dm",
        function()
          require("diagram").render()
        end,
        desc = "Render Diagram",
      },
      {
        "<leader>dM",
        function()
          require("diagram").clear()
        end,
        desc = "Clear Diagram Preview",
      },
    },
  },
}
