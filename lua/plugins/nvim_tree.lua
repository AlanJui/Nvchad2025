local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 令 l 展開已折疊的子目錄（等同 <CR>）
  vim.keymap.set("n", "l", api.node.open.edit, opts "Open Node")
  -- 令 h 收合已展開的子目錄（等同 `Close Parent`）
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Parent")

  -- 令 l 展開已折疊的子目錄（等同 <CR>）
  vim.keymap.set("n", "l", api.node.open.edit, opts "Open Node")
  -- 令 h 收合已展開的子目錄（等同 `Close Parent`）
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Parent")

  -- copy default mappings here from defaults in next section
  vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
  vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
  ---
  -- OR use all default mappings
  api.config.mappings.default_on_attach(bufnr)
  -- remove a default
  vim.keymap.del("n", "<C-]>", { buffer = bufnr })
  -- override a default
  vim.keymap.set("n", "<C-e>", api.tree.reload, opts "Refresh")
  -- add your mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function(client, bufnr)
    require("nvim-tree").setup {
      on_attach = my_on_attach,
    }
  end,
}
