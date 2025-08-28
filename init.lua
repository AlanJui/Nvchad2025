vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    -- config = true,
    config = function(_, _)
      require("live-server").setup {
        port = 5500,
        browser_cmd = "google-chrome",
        open_cmd = "open " .. vim.fn.getcwd() .. "\\" .. vim.fn.expand "%:t",
        open_browser = true,
        root_path = vim.fn.getcwd(),
        -- root_path = vim.fn.expand "%:p:h",
        -- file = vim.fn.expand "%:t",
      }
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-------------------------------------------------
-- 個人化設定
-------------------------------------------------
local toggle = require "my.toggle_list"
vim.keymap.set("n", "<leader>tl", toggle.toggle_list, { desc = "Toggle List Characters" })
-- toggle_list = function()
--   if vim.opt.list:get() then
--     vim.opt.list = false
--     vim.notify("Control characters hidden (list = off)", vim.log.levels.INFO)
--   else
--     vim.opt.list = true
--     vim.opt.listchars = {
--       tab = "»·",
--       trail = "·",
--       extends = ">",
--       precedes = "<",
--     }
--     vim.notify("Control characters shown (list = on)", vim.log.levels.INFO)
--   end
-- end
-- vim.keymap.set("n", "<leader>tl", toggle_list, { desc = "Toggle List Characters" })
-- -- 確保 Mason 先執行 setup()
-- local mason = require "mason"
-- mason.setup()
-- -------------------------------------------------
-- -- 作業環境
-- -------------------------------------------------
-- local env = require "utils.env"
-- local tbl = require "utils.table"
--
-- -- 使用範例
-- if env.is_win then
--   print "目前環境是 Windows"
-- elseif env.is_linux then
--   print "目前環境是純 Linux"
-- elseif env.is_wsl then
--   print "目前環境是 WSL2"
-- end
--
-- local shell_config = env.get_shell()
-- vim.o.shell = shell_config.shell
-- vim.o.shellcmdflag = shell_config.shellcmdflag
--
-- print("使用的 Shell 環境：", tbl.to_string(vim.o.shell))
-- print("Shell 指令參數：", tbl.to_string(vim.o.shellcmdflag))
----------------------------------------------------------------
-- 設定預設 shell 為 Windows PowerShell
----------------------------------------------------------------
if vim.fn.has "win32" == 1 then
  -- vim.opt.shell = "pwsh.exe" -- 或 "powershell.exe"
  vim.opt.shell = "powershell.exe" -- 或 "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
