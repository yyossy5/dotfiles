local wezterm = require("wezterm")
local act = wezterm.action

return {
	-- キーバインド設定
	leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- ペイン分割
		{ key = "\\", mods = "LEADER", action = act.SplitHorizontal },
		{ key = "-", mods = "LEADER", action = act.SplitVertical },

		-- ペイン移動(vim風)
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

		-- コピーモード
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

		-- コピーモード内の設定（vimスタイル）
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }), mode = "copy" },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("ClipboardAndPrimarySelection"),
				act.CopyMode("Close"),
			}),
			mode = "copy",
		},
	},

	-- マウス操作設定
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	enable_scroll_bar = false,

	-- tmux互換のスクロールバッファサイズ
	scrollback_lines = 10000,

	-- エスケープキー入力待ち時間を短く設定
	term = {
		-- Tmux互換の設定: escape sequences don't wait
		set_environment_variables = {
			TERM = "xterm-256color",
		},
	},

	-- vi modeをコピーモードのデフォルトにする
	key_tables = {
		copy_mode = wezterm.gui.default_key_tables().copy_mode,
	},
}

