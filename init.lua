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
-- 確保 Mason 先執行 setup()
local mason = require "mason"
mason.setup()
-------------------------------------------------
-- 作業環境
-------------------------------------------------
local env = require "utils.env"
local tbl = require "utils.table"

-- 使用範例
if env.is_win then
  print "目前環境是 Windows"
elseif env.is_linux then
  print "目前環境是純 Linux"
elseif env.is_wsl then
  print "目前環境是 WSL2"
end

local shell_config = env.get_shell()
vim.o.shell = shell_config.shell
vim.o.shellcmdflag = shell_config.shellcmdflag

print("使用的 Shell 環境：", tbl.to_string(vim.o.shell))
print("Shell 指令參數：", tbl.to_string(vim.o.shellcmdflag))
