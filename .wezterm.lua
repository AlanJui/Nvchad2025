local wezterm = require("wezterm")
local action = wezterm.action
local config = wezterm.config_builder()

-- 1. 基礎外觀設定
config.color_scheme = "Catppuccin Mocha" -- 這是 NvChad 常用的配色，視覺壓力小
config.window_background_opacity = 0.85 -- 設定透明度
config.win32_system_backdrop = "Acrylic" -- Windows 11 專有的毛玻璃效果

-- 2. 字型設定 (對 NvChad 裡的 Nerd Font 圖示至關重要)
-- { family = "JetBrainsMono Nerd Font", weight = "Regular" },
config.font = wezterm.font_with_fallback({
	{ family = "Cascadia Mono", weight = "Regular" },
	{ family = "Cascadia Code NF", weight = "Regular" },
	{ family = "Noto Sans TC Medium", weight = "Regular" },
	"Fira Code",
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

-- 【修正】Alt + p：釘選視窗至最上層 (Toggle Always On Top)
-- WezTerm 沒有內建此 action，改用 PowerShell 呼叫 Win32 API 實現
-- 用一個模組層級的變數記住目前狀態
local is_always_on_top = false

local function toggle_always_on_top(window, pane)
	is_always_on_top = not is_always_on_top

	-- HWND_TOPMOST = -1 (釘選), HWND_NOTOPMOST = -2 (取消釘選)
	local insert_after = is_always_on_top and "-1" or "-2"
	local status_msg = is_always_on_top and "已釘選至最上層 📌" or "已取消釘選 🔓"

	wezterm.run_child_process({
		"powershell.exe",
		"-NoProfile",
		"-NonInteractive",
		"-Command",
		string.format(
			[[
			Add-Type @"
			using System;
			using System.Runtime.InteropServices;
			public class WinTopmost {
				[DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
				[DllImport("user32.dll")] public static extern bool SetWindowPos(
					IntPtr hWnd, IntPtr hWndInsertAfter,
					int X, int Y, int cx, int cy, uint uFlags);
			}
"@
			$hwnd = [WinTopmost]::GetForegroundWindow()
			[WinTopmost]::SetWindowPos($hwnd, [IntPtr](%s), 0, 0, 0, 0, 0x0003)
		]],
			insert_after
		),
	})

	window:toast_notification("WezTerm", status_msg, nil, 2000)
end

-- 7. 熱鍵設定 (Keybindings)
config.keys = {
	{
		-- 【修正】釘選視窗至最上層（Toggle）
		-- 原本的 wezterm.action.ToggleAlwaysOnTop 不存在，改用 Win32 API
		key = "p", -- p 代表 Pin (釘住)
		mods = "ALT",
		action = wezterm.action_callback(toggle_always_on_top),
	},
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
		key = "Enter",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "Enter" }),
	},
	-- 快速切割窗格 (類似 tmux)
	{
		key = "d",
		mods = "ALT",
		action = action.SplitPane({
			direction = "Right", -- 水平分割
		}),
	},
	{
		key = "D",
		mods = "ALT|SHIFT",
		action = action.SplitPane({
			direction = "Down", -- 垂直分割
		}),
	},
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
}

-- 最後回傳配置
return config
