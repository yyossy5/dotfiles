return {
  "akinsho/toggleterm.nvim",
  enabled = false,
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      float_opts = {
        border = "curved", -- Window border style: 'single', 'double', 'shadow', 'curved'
        winblend = 30, -- Transparency: specify a value between 0 (opaque) and 100 (fully transparent)
      },
    })
  end,
  keys = {
    { "<leader>r", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
  },
}
