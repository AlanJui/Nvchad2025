-- 強制拼字總開關（最終穩定版）
-- 重點：
--  1) 不用 vim.b[buf] 存鎖，改全域 locks[bufnr]，避免 Invalid buffer id
--  2) 所有動作都檢查 buffer / window 是否有效
--  3) OptionSet 回呼用 vim.schedule 延後（避開外掛關 buffer 的瞬間）
--  4) 新增 enforce_all_windows()：在 Lazy 事件與 CmdlineLeave 時，對所有可見視窗統一重設
--  5) 事件覆蓋完整：OptionSet / FileType / WinEnter / Buf* / User:Lazy* / BufWritePost / CmdlineLeave / CursorHold

local aug = vim.api.nvim_create_augroup("SpellGuard", { clear = true })

-- === 白名單：想要自動開啟拼字的 filetype（清空 = 全關） ===
-- local whitelist = {}  -- 全關
local whitelist = {
  -- markdown  = true,
  -- gitcommit = true,
  -- text      = true,
}

-- === 永遠關閉拼字的 UI / 外掛視窗類型 ===
local force_off_fts = {
  lazy = true,
  NvimTree = true,
  help = true,
  alpha = true,
  notify = true,
  qf = true,
  lspinfo = true,
  checkhealth = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  ["dap-repl"] = true,
}
local force_off_prefix = { "dapui_", "neo%-tree", "trouble", "aerial" }

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

-- === 安全性輔助 ===
local function buf_valid(bufnr)
  return type(bufnr) == "number" and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr)
end
local function win_valid(winid)
  return type(winid) == "number" and winid > 0 and vim.api.nvim_win_is_valid(winid)
end

-- === 全域鎖，避免遞迴；不用 vim.b 以免 buffer 被刪就報錯 ===
local locks = {} -- [bufnr] = true/false

local function with_lock(bufnr, f)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not buf_valid(bufnr) then
    return
  end
  if locks[bufnr] then
    return
  end
  locks[bufnr] = true
  local ok, err = pcall(f, bufnr)
  if not ok then
    vim.schedule(function()
      vim.notify("SpellGuard: " .. tostring(err), vim.log.levels.DEBUG)
    end)
  end
  locks[bufnr] = false
end

-- === 依規則設定 spell（針對所有顯示該 buffer 的視窗） ===
local function enforce_spell(bufnr)
  if not buf_valid(bufnr) then
    return
  end
  local ft = vim.bo[bufnr].filetype or ""
  local want = (not in_force_off(ft)) and (whitelist[ft] == true) or false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
      vim.api.nvim_set_option_value("spell", want, { scope = "local", win = win })
    end
  end
end

-- === 對目前所有可見視窗 / 其對應 buffer 套用一次規則 ===
local function enforce_all_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if buf_valid(buf) then
        with_lock(buf, enforce_spell)
      end
    end
  end
end

-- 任意人改動 spell（:setlocal spell…）→ 延後 0ms 後依規則覆蓋（避開競態）
vim.api.nvim_create_autocmd("OptionSet", {
  group = aug,
  pattern = "spell",
  nested = true,
  callback = function(args)
    local buf = args.buf
    vim.schedule(function()
      if buf_valid(buf) then
        with_lock(buf, enforce_spell)
      end
    end)
  end,
  desc = "SpellGuard: intercept spell toggles",
})

-- 進入視窗 / 開 buffer / 設定 filetype：套用一次
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufEnter", "FileType" }, {
  group = aug,
  callback = function(args)
    if buf_valid(args.buf) then
      with_lock(args.buf, enforce_spell)
    end
  end,
  desc = "SpellGuard: apply on window/buffer/filetype events",
})

-- Lazy 相關事件後 → 對所有視窗強制修正
vim.api.nvim_create_autocmd("User", {
  group = aug,
  pattern = { "VeryLazy", "LazyDone", "LazySync", "LazyInstall", "LazyUpdate" },
  callback = function()
    vim.schedule(function()
      enforce_all_windows()
    end)
  end,
  desc = "SpellGuard: after lazy events (enforce all windows)",
})

-- 存設定檔後（plugins/*.lua 等）→ 延後覆蓋，避開關窗/關 buffer 當下
vim.api.nvim_create_autocmd("BufWritePost", {
  group = aug,
  pattern = { "*.lua", "*.vim" },
  callback = function(args)
    local buf = args.buf
    vim.schedule(function()
      if buf_valid(buf) then
        with_lock(buf, enforce_spell)
      end
    end)
  end,
  desc = "SpellGuard: after saving configs",
})

-- 離開命令列（例如按下 <Enter> 關閉 Lazy 的提示）→ 對所有視窗強制修正
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = aug,
  callback = function()
    vim.schedule(function()
      enforce_all_windows()
    end)
  end,
  desc = "SpellGuard: after cmdline leave (enforce all windows)",
})

-- （保險心跳）游標閒置也拉回來
vim.api.nvim_create_autocmd("CursorHold", {
  group = aug,
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if buf_valid(buf) then
      with_lock(buf, enforce_spell)
    end
  end,
  desc = "SpellGuard: keep consistent on idle",
})

-- 小工具
vim.api.nvim_create_user_command("SpellGuardStatus", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype or ""
  print(
    ("buf=%d filetype=%s spell=%s (whitelist=%s force_off=%s)"):format(
      bufnr,
      ft,
      tostring(vim.opt_local.spell:get()),
      tostring(whitelist[ft] or false),
      tostring(in_force_off(ft))
    )
  )
end, {})
