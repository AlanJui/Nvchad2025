-- PlantUML
return {
  "weirongxu/plantuml-previewer.vim",
  ft = { "plantuml" },
  dependices = {
    {
      -- Open URI with your favorite browser from Neovim
      "tyru/open-browser.vim",
      -- PlantUML syntax highlighting
      "aklt/plantuml-syntax",
      -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
      "mracos/mermaid.vim",
    },
  },
  cmd = { "PlantumlOpen", "PlantumlSave", "PlantumlToggle" },
  config = function()
    vim.g.my_jar_path = vim.fn.stdpath "data" .. "/lazy/plantuml-previewer.vim/lib/plantuml.jar"
    vim.cmd [[
      autocmd FileType plantuml let g:plantuml_previewer#plantuml_jar_path = g:my_jar_path
      let g:plantuml_previewer#save_format = "png"
      let g:plantuml_previewer#debug_mode = 1
    ]]
  end,
}
