-- File Manager
return {
  "vifm/vifm.vim",
  lazy = false,
  cmd = { "Vifm", "VifmOpen", "VifmTabOpen", "VifmSplitOpen", "VifmVsplitOpen" },
  keys = {
    {
      "<leader>fv",
      function()
        vim.cmd "Vifm"
      end,
      desc = "Open Vifm",
    },
  },
}
