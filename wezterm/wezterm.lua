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

		-- ペインを入れ替え（tmuxのPrefix + {, Prefix + }相当）
		{
			key = "{",
			mods = "LEADER|SHIFT",
			action = act.RotatePanes("CounterClockwise"),
		},
		{
			key = "}",
			mods = "LEADER|SHIFT",
			action = act.RotatePanes("Clockwise"),
		},

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

		-- ==================== Workspace ====================

		{
			mods = "LEADER",
			key = "w",
			action = wezterm.action_callback(function(win, pane)
				-- workspace のリストを作成
				local workspaces = {}
				for i, name in ipairs(wezterm.mux.get_workspace_names()) do
					table.insert(workspaces, {
						id = name,
						--label = string.format("%d. %s", i, name),
						label = string.format("%s", name),
					})
				end
				local current = wezterm.mux.get_active_workspace()
				-- 選択メニューを起動
				win:perform_action(
					act.InputSelector({
						action = wezterm.action_callback(function(_, _, id, label)
							if not id and not label then
								wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
							else
								win:perform_action(act.SwitchToWorkspace({ name = id }), pane) -- workspace を移動
							end
						end),
						title = "Select workspace",
						choices = workspaces,
						fuzzy = false,
						-- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
					}),
					pane
				)
			end),
		},

		{
			-- Rename workspace
			mods = "LEADER",
			key = "$",
			action = act.PromptInputLine({
				description = "(wezterm) Set workspace title:",
				action = wezterm.action_callback(function(win, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
					end
				end),
			}),
		},

		{
			-- Create new workspace
			mods = "LEADER|SHIFT",
			key = "W",
			action = act.PromptInputLine({
				description = "(wezterm) Create new workspace:",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
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

	-- ==================== Appearance ====================
	-- https://wezterm.org/config/appearance.html

	-- フォント設定
	font = wezterm.font("Hack Nerd Font Mono"),
	font_size = 12.5,

	-- ----- Oxocarbon start -----
	-- カラースキーム設定
	color_scheme = "Oxocarbon Dark (Gogh)",

	-- カスタム色設定（ANSI色を上書き）
	colors = {
		-- ANSIカラーのカスタマイズ
		ansi = {
			"#161616", -- black
			"#3ddbd9", -- red
			"#33b1ff", -- green
			"#ee5396", -- yellow
			"#42be65", -- blue
			"#be95ff", -- magenta
			"#ff7eb6", -- cyan
			"#f2f4f8", -- white
		},
		brights = {
			"#585858", -- bright black
			"#3ddbd9", -- bright red
			"#33b1ff", -- bright green
			"#ee5396", -- bright yellow
			"#42be65", -- bright blue
			"#be95ff", -- bright magenta
			"#ff7eb6", -- bright cyan
			"#f2f4f8", -- bright white
		},

		-- 背景色設定
		background = "#0e1018", -- ダークなネイビーブルー

		-- その他の色設定
		cursor_bg = "#f2f4f8", -- カーソルの背景色
		cursor_fg = "#161616", -- カーソルの前景色
		selection_bg = "#353a45", -- 選択範囲の背景色
		selection_fg = "#f2f4f8", -- 選択範囲の前景色

		-- ----- Oxocarbon end -----
	},
}
