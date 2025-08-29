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
