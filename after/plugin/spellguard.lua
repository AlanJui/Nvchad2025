-- 強制拼字總開關（超兇版）
-- 目標：不管誰在什麼時機把 spell 打開，都依我們規則重設。
-- 作法說明：
-- 1. 監聽 OptionSet spell 事件，任何人改動拼字選項時，
--    立刻用我們的規則覆蓋。
-- 2. 用 with_lock 避免遞迴（因為我們在 OptionSet 裡又 setlocal）。
-- 3. 監聽其它事件（FileType, WinEnter, BufWritePost, Lazy 的 User 事件)，
--    只是補強，即使使用者執行：同步/安裝外掛、開 Lazy UI、重載設定，也會
--    被拉回預期狀態。
-- 放置：~/.config/nvim/after/plugin/spellguard.lua
-------------------------------------------------------------------------
-- 快速驗證
-------------------------------------------------------------------------
--
-- (1) 啟動 nvim，:Lazy → <S> Sync 後，執行 :SpellGuardStatus 看 spell=false。
--
-- (2) 編輯 lua/plugins/*.lua → :w 後，再 :verbose setlocal spell? 應顯示 nospell，且如果被誰打開過，最後一行會顯示我們 spellguard.lua 的位置。
--
-- (3) 切到 NvimTree、Lazy UI、Telescope → 都應該保持 nospell。
-------------------------------------------------------------------------

local aug = vim.api.nvim_create_augroup("SpellGuard", { clear = true })

-- 你想允許自動開拼字的 filetype（可自行增刪）
local whitelist = {
  markdown = true,
  -- gitcommit = true,
  text = true,
}

-- 永遠禁止拼字的 UI/外掛視窗
local force_off_fts = {
  "lazy",
  "NvimTree",
  "help",
  "alpha",
  "notify",
  "qf",
  "lspinfo",
  "checkhealth",
  "TelescopePrompt",
  "TelescopeResults",
  "dap-repl",
}
-- 也支援像 dapui_scopes 這種前綴樣式
local force_off_prefix = { "dapui_", "neo-tree", "trouble", "aerial" }

local function in_force_off(ft)
  if force_off_fts[ft] then
    return true
  end
  for _, p in ipairs(force_off_prefix) do
    if ft:match("^" .. p) then
      return true
    end
  end
  return false
end

-- -- ⭐ 新增：buffer 是否有效（避免 Invalid buffer id）
-- -- ★ 安全寫入：先確保 buffer 還活著
-- local function buf_is_valid(bufnr)
--   return bufnr and bufnr ~= 0 and vim.api.nvim_buf_is_valid(bufnr)
-- end

-- 避免遞迴：每個 buffer 一把鎖
local function with_lock(bufnr, f)
  bufnr = bufnr or 0
  if vim.b[bufnr]._spellguard_lock then
    return
  end
  vim.b[bufnr]._spellguard_lock = true
  pcall(f)
  -- 用 defer 清鎖，避免 OptionSet 連續觸發
  vim.defer_fn(function()
    vim.b[bufnr]._spellguard_lock = false
  end, 0)
end
-- -- ⭐ 改良：帶鎖且保護無效 buffer
-- -- ★ 鎖：避免遞迴；同時保護無效 buffer
-- local function with_lock(bufnr, f)
--   bufnr = bufnr or vim.api.nvim_get_current_buf()
--   if not buf_is_valid(bufnr) then
--     return
--   end
--   if vim.b[bufnr]._spellguard_lock then
--     return
--   end
--   vim.b[bufnr]._spellguard_lock = true
--   local ok, err = pcall(f, bufnr)
--   if not ok then
--     vim.schedule(function()
--       vim.notify("SpellGuard: " .. tostring(err), vim.log.levels.DEBUG)
--     end)
--   end
--   vim.defer_fn(function()
--     if buf_is_valid(bufnr) then
--       vim.b[bufnr]._spellguard_lock = false
--     end
--   end, 0)
-- end

local function enforce_spell()
  local ft = vim.bo.filetype or ""
  if in_force_off(ft) then
    vim.opt_local.spell = false
    return
  end
  if whitelist[ft] then
    vim.opt_local.spell = true
  else
    vim.opt_local.spell = false
  end
end
-- -- ⭐ 改良：接受 bufnr，並對所有顯示該 buffer 的視窗設置 window-local 的 spell
-- local function enforce_spell(bufnr)
--   if not buf_is_valid(bufnr) then
--     return
--   end
--   local ft = vim.bo[bufnr].filetype or ""
--   local want
--   if in_force_off(ft) then
--     want = false
--   else
--     want = whitelist[ft] == true
--   end
--   -- 對所有顯示此 buffer 的視窗逐一設定（因為 spell 是 window-local）
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     if vim.api.nvim_win_get_buf(win) == bufnr then
--       vim.api.nvim_set_option_value("spell", want, { scope = "local", win = win })
--     end
--   end
-- end

-- 任何有人改動 spell（:setlocal spell 等）→ 立刻套用我們的規則
vim.api.nvim_create_autocmd("OptionSet", {
  group = aug,
  pattern = "spell",
  nested = true, -- 允許我們在回呼裡再 setlocal
  callback = function(args)
    with_lock(args.buf, enforce_spell)
  end,
  desc = "SpellGuard: intercept spell toggles",
})

-- 進入視窗 / 開啟緩衝區 / 設定 filetype 時，套用一次（防止外掛新建視窗時開啟 spell）
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufEnter", "FileType" }, {
  group = aug,
  callback = function(args)
    with_lock(args.buf, enforce_spell)
  end,
  desc = "SpellGuard: apply on window/buffer/filetype events",
})

-- NvChad / lazy.nvim 常見操作後再補打一槍
vim.api.nvim_create_autocmd("User", {
  group = aug,
  pattern = { "VeryLazy", "LazyDone", "LazySync", "LazyInstall", "LazyUpdate" },
  callback = function()
    with_lock(0, enforce_spell)
  end,
  desc = "SpellGuard: after lazy events",
})

-- 存設定檔後（常見：plugins/*.lua）可能觸發熱重載 → 再補打一槍
vim.api.nvim_create_autocmd("BufWritePost", {
  group = aug,
  pattern = { "*.lua", "*.vim" },
  callback = function(args)
    with_lock(args.buf, enforce_spell)
  end,
  desc = "SpellGuard: after saving configs",
})

-- 小工具：查看目前狀態與理由
vim.api.nvim_create_user_command("SpellGuardStatus", function()
  local ft = vim.bo.filetype or ""
  print(
    string.format(
      "filetype=%s  spell=%s  (whitelist=%s  force_off=%s)",
      ft,
      tostring(vim.opt_local.spell:get()),
      tostring(whitelist[ft] or false),
      tostring(in_force_off(ft))
    )
  )
end, {})
