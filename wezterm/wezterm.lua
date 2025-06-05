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

		-- 新しいタブを作成（tmuxのPrefix + c相当）
		{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

		-- タブの名前を変更（tmuxのPrefix + ,相当）
		{
			key = ",",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "タブ名を入力:",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},

		-- 前のタブに移動（tmuxのPrefix + p相当）
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

		-- 次のタブに移動（tmuxのPrefix + n相当）
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

		-- 数字キーで指定したタブに移動（tmuxのPrefix + 数字相当）
		{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
		{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
		{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
		{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
		{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
		{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
		{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
		{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
		{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

		-- ペインを閉じる（tmuxのPrefix + x相当）
		-- TODO: 確認付きにしたい
		{
			key = "x",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = true }),
		},

		-- タブを閉じる（tmuxのPrefix + &相当）
		-- TODO: 確認付きにしたい
		{
			key = "&",
			mods = "LEADER|SHIFT",
			action = act.CloseCurrentTab({ confirm = true }),
		},

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
	term = "xterm-256color",

	-- 環境変数設定
	set_environment_variables = {
		TERM = "xterm-256color",
	},

	-- vi modeをコピーモードのデフォルトにする
	key_tables = {
		copy_mode = wezterm.gui.default_key_tables().copy_mode,
	},
}
