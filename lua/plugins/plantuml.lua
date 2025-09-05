-- PlantUML
return {
  {
    "tyru/open-browser.vim",
    lazy = false,
    enabled = true,
  },
  --語法高亮與 ftdetect，品質更佳
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  },
  {
    "weirongxu/plantuml-previewer.vim",
    lazy = true,
    enabled = true,
    ft = { "plantuml" },
    dependices = {
      {
        -- Open URI with your favorite browser from Neovim
        "tyru/open-browser.vim",
        -- PlantUML syntax highlighting
        "aklt/plantuml-syntax",
        -- -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
        -- "mracos/mermaid.vim",
      },
    },
    cmd = { "PlantumlOpen", "PlantumlSave", "PlantumlToggle" },
    keys = {
      { "<leader>po", "<cmd> PlantumlOpen<CR>", desc = "Open PlantUML Preview" },
      { "<leader>ps", "<cmd> PlantumlSave<CR>", desc = "Save PlantUML Preview" },
      { "<leader>pt", "<cmd> PlantumlToggle<CR>", desc = "Toggle PlantUML Preview" },
    },
    config = function()
      -- for Windows Environment (ex. C:\Users\AlanJui\AppData\Local\nvim-data\lazy\plantuml-previewer.vim\lib\plantuml.jar)
      vim.g.my_jar_path = vim.fn.stdpath "data" .. "/lazy/plantuml-previewer.vim/lib/plantuml.jar"
      vim.cmd [[
      autocmd FileType plantuml let g:plantuml_previewer#plantuml_jar_path = g:my_jar_path
      let g:plantuml_previewer#save_format = "png"
      let g:plantuml_previewer#debug_mode = 1
      let g:plantuml_previewer#auto_save = 1
      let g:plantuml_previewer#auto_open = 1
      let g:plantuml_previewer#auto_close = 1
      let g:plantuml_previewer#browser = "chrome"
      let g:plantuml_previewer#render_cmd = "java -Djava.awt.headless=true -jar"
      let g:plantuml_previewer#render_options = "-charset UTF-8 -pipe" 
      let g:plantuml_previewer#file_pattern = "*.pu,*.uml,*.plantuml,*.puml,*.iuml,*.md"
    ]]
    end,
  },
}
