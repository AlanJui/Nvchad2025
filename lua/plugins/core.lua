-- ~/.config/nvim/lua/plugins/core.lua
return {
  -- 讓 NvChad 的熱重載可用
  { "nvim-lua/plenary.nvim", enabled = true, lazy = false, priority = 1000 },

  -- 保險：把 NvChad/ui 明確宣告依賴 plenary（避免先載入 ui 再找不到 plenary.reload）
  { "NvChad/ui", dependencies = { "nvim-lua/plenary.nvim" } },
}
