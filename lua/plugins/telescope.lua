return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-dap.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "aaronhallaert/advanced-git-search.nvim",
    "ahmedkhalf/project.nvim",
    "benfowler/telescope-luasnip.nvim",
    "cljoly/telescope-repo.nvim",
    "olacin/telescope-cc.nvim",
    "stevearc/aerial.nvim",
    "tsakirist/telescope-lazy.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension "fzf"
      end,
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      dependencies = { "kkharji/sqlite.lua" },
      config = function()
        require("telescope").load_extension "frecency"
      end,
    },
  },
  cmd = "Telescope",
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

