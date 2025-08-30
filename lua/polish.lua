-- 讓 *.plantuml, *.puml, *.uml, *.iuml 都判為 plantuml
vim.filetype.add {
  extension = {
    plantuml = "plantuml",
    puml = "plantuml",
    uml = "plantuml",
    iuml = "plantuml",
    mermaid = "mermaid",
  },
}
-- 存檔自動渲染 .mermaid
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.mermaid",
  command = "MermaidRender",
})
