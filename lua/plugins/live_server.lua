return {
  "barrett-ruth/live-server.nvim",
  build = "pnpm add -g live-server",
  cmd = { "LiveServerStart", "LiveServerStop" },
  config = function(_, _)
    require("live-server").setup {
      port = 5500,
      browser_cmd = "google-chrome",
      open_cmd = "open " .. vim.fn.getcwd() .. "\\" .. vim.fn.expand "%:t",
      open_browser = true,
      root_path = vim.fn.getcwd(),
    }
  end,
}
