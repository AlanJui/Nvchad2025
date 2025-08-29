return {
  {
    "iamcco/markdown-preview.nvim",
    lazy = false,
    enable = true,
    build = "cd app && yarn install",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      -- { "<leader>um", "+MarkDown" },
      { "<leader>mp", "<cmd> MarkdownPreview<CR>", desc = "Open Preview" },
      { "<leader>mP", "<cmd> MarkdownPreviewToggle<CR>", desc = "Toggle MarkdownPreview" },
      { "<leader>mt", "<cmd> MarkdownPreviewToggle<CR>", desc = "Toggle MarkdownPreview" },
      { "<leader>ms", "<cmd> MarkdownPreviewStop<CR>", desc = "Close Preview" },
    },
    init = function()
      -- 讓 .mermaid 檔也走 markdown 管線
      vim.filetype.add { extension = { mermaid = "markdown" } }
      vim.g.mkdp_filetypes = { "markdown" }

      -- vim.g.mkdp_auto_start = false
      vim.g.mkdp_auto_start = true
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "9999"
      vim.g.mkdp_browser = ""
      vim.g.open_to_the_world = false
      vim.g.mkdp_echo_preview_url = true
      vim.g.mkdp_page_title = "${name}"
    end,
    ft = { "markdown" },
  },
  -- provides support to mermaid syntax files (e.g. *.mmd, *.mermaid)
  {
    "mracos/mermaid.vim",
    lazy = false,
    ft = { "mermaid", "markdown" },
  },
  -- Markdown Syntax Highlighting
  -- URL: https://github.com/preservim/vim-markdown
  {
    "preservim/vim-markdown",
    config = function()
      -- 變更預設：文件內容毋需折疊
      vim.g.vim_markdown_folding_disabled = 1
      -- vim.g.markdown_fenced_languages = {
      --   "html",
      --   "python",
      --   "bash=sh",
      -- }
      -- disabling conceal for code fences
      -- vim.g.markdown_conceal_code_blocks = 0
    end,
  },
}
