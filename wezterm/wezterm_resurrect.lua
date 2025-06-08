local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local M = {}

function M.setup()
	-- 定期的な自動保存を設定（15分間隔）
	resurrect.state_manager.periodic_save({
		interval_seconds = 900, -- 15分
		save_workspaces = true,
		save_windows = true,
		save_tabs = true,
	})

	-- GUI起動時に最新の状態を復元
	wezterm.on("gui-startup", function()
		resurrect.state_manager.resurrect_on_gui_startup()
	end)

	return {
		-- セッション保存
		{
			key = "s",
			mods = "LEADER|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				resurrect.state_manager.save_state()
				window:toast_notification("wezterm", "Session saved!", nil, 4000)
			end),
		},

		-- セッション復元（最新）
		{
			key = "r",
			mods = "LEADER|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				resurrect.state_manager.load_state()
				window:toast_notification("wezterm", "Session restored!", nil, 4000)
			end),
		},
	}
end

return M