return {
  "is0n/fm-nvim",
  keys = {
    { "<Space>lg", ":Lazygit<CR>" },
  },
  config = function()
    require("fm-nvim").setup({})
  end,
}
