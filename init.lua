-- 嘗試讀取本地的金鑰檔案
local env_path = vim.fn.stdpath "config" .. "/.env.lua"
local f = io.open(env_path, "r")
if f then
  f:close()
  local ok, env = pcall(dofile, env_path)
  if ok and env and env.GEMINI_API_KEY then
    vim.env.GEMINI_API_KEY = env.GEMINI_API_KEY
  end
end

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

require "custom"

-- Show Nvdash when all buffers are closed
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

-- 令 Markdown 轉 HTML 後的預覽
local function convert_and_preview()
  -- 1. 獲取檔名資訊
  local md_file = vim.fn.expand "%:p" -- 完整的 md 路徑
  local html_file = vim.fn.expand "%:p:r" .. ".html" -- 換成 .html 後綴

  -- 2. 存檔
  vim.cmd "silent! write"

  -- 3. 執行 Python 轉換 (使用 jobstart 避免阻塞編輯器，保持絲滑)
  print "正在美化並轉換中..."

  vim.fn.jobstart({ "python", "convert_md_to_html.py", md_file }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        -- 4. 轉換成功後，啟動預覽
        vim.cmd("silent! LivePreview start " .. html_file)
        print "✨ 轉換成功！預覽已更新"
      else
        print "❌ 轉換失敗，請檢查 Python 腳本"
      end
    end,
  })
end

-- 建立指令與快捷鍵
vim.api.nvim_create_user_command("ConvertPreview", convert_and_preview, {})
vim.keymap.set("n", "<leader>cp", convert_and_preview, { desc = "Markdown 轉換並預覽 (連鎖技)" })
if vim.fn.has "win32" == 1 then
  vim.g.browse_command = "powershell.exe -NoProfile -Command Start-Process"
end
