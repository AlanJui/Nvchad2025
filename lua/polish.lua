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
-- WSL 內提醒用 inline (<leader>mr)；Windows 內提醒用 external (<leader>mr 已映射在 diagram_win.lua)
if vim.loop.os_uname().sysname == "Linux" then
  vim.keymap.set("n", "<leader>mw", function()
    vim.notify("在 WSL 內建預覽已綁到 <leader>mr", vim.log.levels.INFO)
  end, { desc = "Mermaid help" })
end
