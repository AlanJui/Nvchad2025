-- PlantUML
-- return {
--   "weirongxu/plantuml-previewer.vim",
--   lazy = true,
--   enabled = true,
--   ft = { "plantuml" },
--   dependices = {
--     {
--       -- Open URI with your favorite browser from Neovim
--       "tyru/open-browser.vim",
--       -- PlantUML syntax highlighting
--       "aklt/plantuml-syntax",
--       -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
--       "mracos/mermaid.vim",
--     },
--   },
--   cmd = { "PlantumlOpen", "PlantumlSave", "PlantumlToggle" },
--   config = function()
--     -- for Windows Environment (ex. C:\Users\AlanJui\AppData\Local\nvim-data\lazy\plantuml-previewer.vim\lib\plantuml.jar)
--     vim.g.my_jar_path = vim.fn.stdpath "data" .. "/lazy/plantuml-previewer.vim/lib/plantuml.jar"
--     vim.cmd [[
--       autocmd FileType plantuml let g:plantuml_previewer#plantuml_jar_path = g:my_jar_path
--       let g:plantuml_previewer#save_format = "png"
--       let g:plantuml_previewer#debug_mode = 1
--     ]]
--   end,
-- }

return {
  -- 先宣告依賴，讓 lazy 能掌握
  {
    "goropikari/LibDeflate.nvim",
    lazy = true,
  },

  {
    "goropikari/plantuml.nvim",
    enabled = true, -- ← 原本寫成 enable，lazy 會忽略
    lazy = true,
    dependencies = { "goropikari/LibDeflate.nvim" },

    -- 二擇一加載條件（兩者都保留更穩）：
    -- 1) 用命令觸發：第一次輸入 :PlantumlPreview 會自動載入
    cmd = { "PlantumlPreview", "PlantumlStop", "PlantumlOpen" },

    -- 2) 用檔案型別觸發：打開 *.puml/*.plantuml 就載入
    ft = { "plantuml" },

    opts = {
      -- 預設走官方雲端 server，免裝 Java
      base_url = "https://www.plantuml.com/plantuml",

      -- 存檔後重新產圖，用 Post（寫入後）避免 Pre 還沒落檔
      reload_events = { "BufWritePost" },

      -- Windows 請改用 "start"（交由系統預設圖檔檢視器開啟）
      -- viewer = (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1) and "start" or "xdg-open",

      -- 若您沒有要跑本機 Docker 的 plantuml server，就關掉此項
      docker_image = nil,
    },
  },

  --（可選）語法高亮與 ftdetect，品質更佳
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  },
}
