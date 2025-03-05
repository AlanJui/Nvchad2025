 -- File Manager
return  {
  "vifm/vifm.vim",
  lazy = false,
  cmd = { "Vifm", "VifmOpen", "VifmTabOpen", "VifmSplitOpen", "VifmVsplitOpen" },
  keys = {
    {
      "<leader>uv",
      function()
        vim.cmd "Vifm"
      end,
      desc = "Open Vifm",
    },
  },
}
