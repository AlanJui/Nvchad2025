-- 可使用以下指令，確保沒有其它的【插件設定檔】，將 plenary.nvim 插件給禁用。
-- rg -n "plenary\.nvim|plenary" ~/.config/nvim/lua/plugins
--------------------------------------------------------------------------------
-- 檢驗 plenary.nvim 插件確實已載入的方法：
-- :Lazy → plenary.nvim 一定要是 Loaded（非 Disabled/Not Loaded）。
--------------------------------------------------------------------------------
-- ~/.config/nvim/lua/plugins/zz_plenary_force.lua  (檔名前面加 zz 讓它最後載入)

-- 強制控制 plenary.nvim 與 NvChad/ui 的載入順序
-- 檔名前加 zz → Lazy.nvim 會最後讀取，但 priority=10000 → plenary 實際最早載

return {
  {
    "nvim-lua/plenary.nvim",
    enabled = true,
    lazy = false,
    priority = 10000, -- 超高優先級
    -- config = function()
    --   vim.schedule(function()
    --     vim.notify("✅ plenary.nvim 已載入 (priority=10000)", vim.log.levels.INFO)
    --   end)
    -- end,
  },

  {
    "NvChad/ui",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- config = function()
    --   vim.schedule(function()
    --     vim.notify("🎨 NvChad/ui 已載入 (依賴 plenary.nvim)", vim.log.levels.INFO)
    --   end)
    -- end,
  },
}
