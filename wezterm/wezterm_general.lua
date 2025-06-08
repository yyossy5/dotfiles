local M = {}

function M.setup()
	return {
		-- マウス操作設定
		enable_tab_bar = true,
		use_fancy_tab_bar = false,
		enable_scroll_bar = false,

		-- スクロールバッファサイズ
		scrollback_lines = 10000,

		-- エスケープキー入力待ち時間を短く設定
		term = "xterm-256color",

		-- 環境変数設定
		set_environment_variables = {
			TERM = "xterm-256color",
		},
	}
end

return M

