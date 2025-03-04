return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, conf)
    conf.defaults.mappings.i = {
      ["<C-j>"] = require("telescope.actions").move_selection_next,
      ["<Esc>"] = require("telescope.actions").close,
    }

   -- or 
   -- table.insert(conf.defaults.mappings.i, your table)
    return conf
  end,
}
