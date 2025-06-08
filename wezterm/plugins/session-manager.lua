-- https://github.com/danielcopper/wezterm-session-manager

local wezterm = require("wezterm")
local session_manager = require("wezterm-session-manager/session-manager")

local M = {}

function M.setup()
	-- イベントハンドラの設定
	wezterm.on("save_session", function(window)
		session_manager.save_state(window)
		wezterm.log_info("Session saved!")
	end)

	-- wezterm.on("load_session", function(window)
	-- 	session_manager.load_state(window)
	-- 	wezterm.log_info("Session loaded!")
	-- end)

	wezterm.on("restore_session", function(window)
		session_manager.restore_state(window)
		wezterm.log_info("Session restored!")
	end)

	return {
		-- セッション保存
		{
			key = "s",
			mods = "LEADER|SHIFT",
			action = wezterm.action({ EmitEvent = "save_session" }),
		},

		-- -- セッション読み込み
		-- {
		-- 	key = "l",
		-- 	mods = "LEADER|SHIFT",
		-- 	action = wezterm.action({ EmitEvent = "load_session" }),
		-- },

		-- セッション復元
		{
			key = "r",
			mods = "LEADER|SHIFT",
			action = wezterm.action({ EmitEvent = "restore_session" }),
		},
	}
end

return M

