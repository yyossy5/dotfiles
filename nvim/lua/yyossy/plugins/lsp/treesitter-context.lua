return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesitter-context").setup({
      enable = true, -- Enable the plugin
      max_lines = 0, -- Maximum number of lines to show for context
      min_window_height = 0, -- Minimum editor window height to enable context
      line_numbers = true, -- Show line numbers in context window
      multiline_threshold = 1000, -- Max number of lines for a single context block
      trim_scope = "outer", -- Which scope to trim if context is too big
      mode = "topline", -- Show context for current cursor position
    })
  end,
}
