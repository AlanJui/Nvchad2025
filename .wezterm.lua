local wezterm = require("wezterm")
local action = wezterm.action
local config = wezterm.config_builder()

-- 1. 基礎外觀設定
config.color_scheme = "Catppuccin Mocha" -- 這是 NvChad 常用的配色，視覺壓力小
config.window_background_opacity = 0.85 -- 設定透明度
config.win32_system_backdrop = "Acrylic" -- Windows 11 專有的毛玻璃效果

-- 2. 字型設定 (對 NvChad 裡的 Nerd Font 圖示至關重要)
config.font = wezterm.font_with_fallback({
	{ family = "Cascadia Code NF", weight = "Regular" },
	{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
})
config.font_size = 16.0

-- 3. 視窗樣式
config.window_decorations = "TITLE | RESIZE" -- 保留標題列但保持簡潔
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- 4. 針對 Neovim 優化
config.scrollback_lines = 5000
config.enable_scroll_bar = false -- 讓介面更像純粹的編輯器
config.default_prog = { "powershell.exe" } -- 預設開啟 PowerShell

-- 5. 操作介面調整

-- 自動聚焦到新開的 Tab，讓工作流程更順暢
config.pane_focus_follows_mouse = true -- 這樣滑鼠移到哪個子視窗就自動聚焦，對於多視窗操作很方便
config.inactive_pane_hsb = {
	saturation = 0.8, -- 降低不活躍視窗的飽和度，讓焦點更明顯
	brightness = 0.7, -- 同時降低亮度，增加對比
}

-- 讓 Tab Bar 顯示在底部 (有些人喜歡這種類似 statusline 的感覺)
config.tab_bar_at_bottom = true

-- 隱藏視窗上方多餘的裝飾，讓介面更純粹
config.use_fancy_tab_bar = false

-- 設定 Tab 的顏色 (與 Catppuccin 搭配)
config.colors = {
	tab_bar = {
		background = "#1e1e2e",
		active_tab = {
			bg_color = "#89b4fa",
			fg_color = "#1e1e2e",
		},
		inactive_tab = {
			bg_color = "#313244",
			fg_color = "#cdd6f4",
		},
	},
}

-- 6. 個人客製功能

-- 定義儲存 Markdown 的功能
local function save_pane_to_markdown(window, pane)
	-- 1. 取得當前視窗的所有文字內容
	local text = pane:get_logical_lines(1000) -- 抓取最近 1000 行
	local content = ""
	for _, line in ipairs(text) do
		content = content .. line .. "\n"
	end

	-- 2. 設定檔名（格式：gemini_log_2026-03-16.md）
	local date = os.date("%Y-%m-%d_%H-%M-%S")
	-- 請修改下方路徑為您希望存放紀錄的資料夾
	local home = os.getenv("USERPROFILE") or os.getenv("HOME")
	local filename = home .. "\\Documents\\gemini_log_" .. date .. ".md"

	-- 3. 寫入檔案
	local file = io.open(filename, "w")
	if file then
		file:write("# Gemini Chat Log - " .. date .. "\n\n")
		file:write("```text\n") -- 用程式碼區塊包起來，保留格式
		file:write(content)
		file:write("\n```")
		file:close()
		-- 在 WezTerm 上方顯示成功通知
		window:toast_notification("WezTerm", "已存檔至: " .. filename, nil, 4000)
	else
		window:toast_notification("WezTerm", "存檔失敗！請檢查路徑。", nil, 4000)
	end
end

-- 開/關設定 (Toggle)
local function toggle_bottom_pane(window, pane)
	local tab = window:active_tab()
	local panes = tab:panes_with_info()

	if #panes > 1 then
		-- 如果已經有分割視窗，就關閉當前焦點所在的視窗
		window:perform_action(action.CloseCurrentPane({ confirm = false }), pane)
	else
		-- 否則，在下方開一個佔比 30% 的新視窗
		window:perform_action(
			action.SplitPane({
				direction = "Down",
				size = { Percent = 30 },
			}),
			pane
		)
	end
end

-- 7. 熱鍵設定 (Keybindings)
config.keys = {
	{
		-- 將 Shift + Enter 映射為傳送 "\n" (換行)
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\n"),
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action_callback(save_pane_to_markdown),
	},
	{
		-- 如果你希望 Ctrl + Enter 才是「送出」，可以另外定義
		-- 但通常 CLI 工具預設 Enter 就是送出，所以不一定要改
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "Enter" }),
	},
	-- 快速切割窗格 (類似 tmux)
	-- {
	-- 	key = "d",
	-- 	mods = "ALT",
	-- 	action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	-- },
	-- {
	-- 	key = "D",
	-- 	mods = "ALT",
	-- 	action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	-- },
	{ key = "d", mods = "ALT", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "D", mods = "ALT|SHIFT", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- 切換底部臨時視窗 (使用 Alt + t，t 代表 Terminal/Toggle)
	{
		key = "t",
		mods = "ALT",
		action = wezterm.action_callback(toggle_bottom_pane),
	},
	-- Alt + z 把目前視窗放大/縮小
	{ key = "z", mods = "ALT", action = action.TogglePaneZoomState },
	-- 快速切換全螢幕
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.ToggleFullScreen,
	},
	-- 使用 Alt + 方向鍵切換子視窗 (Pane)
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- 進階：使用 Alt + hjkl 切換 (這對 Neovim 使用者最直覺)
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- 關閉當前子視窗
	{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- 切換到左邊的 Tab
	{ key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
	-- 切換到右邊的 Tab
	{ key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	-- 按下 Alt + Space 隱藏或顯示視窗 (類似下拉式終端機)
	-- {
	-- 	key = " ",
	-- 	mods = "ALT",
	-- 	action = wezterm.action.ToggleFullScreen(),
	-- },
}

-- 最後回傳配置
return config
