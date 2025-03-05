return  {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { "<leader>tt", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
  },
  -- config = function()
  --   require("core.utils").load_mappings("trouble")
  -- end,
}

