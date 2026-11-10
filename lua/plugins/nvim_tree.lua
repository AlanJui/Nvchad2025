local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- OR use all default mappings
  api.config.mappings.default_on_attach(bufnr)
  -- remove a default
  vim.keymap.del("n", "<C-]>", { buffer = bufnr })
  -- override a default
  vim.keymap.set("n", "<C-e>", api.tree.reload, opts "Refresh")
  -- add your mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
  -- 令 l 展開已折疊的子目錄（等同 <CR>）
  vim.keymap.set("n", "l", api.node.open.edit, opts "Open Node")
  -- 令 h 收合已展開的子目錄
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Parent")
end

return {
  "nvim-tree/nvim-tree.lua",
  opts = function()
    local opts = require "nvchad.configs.nvimtree"
    opts.on_attach = my_on_attach
    return opts
  end,
}
