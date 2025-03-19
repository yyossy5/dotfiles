-- https://github.com/karb94/neoscroll.nvim
return {
  "karb94/neoscroll.nvim",
  config = function(_, opts)
    require("neoscroll").setup(opts)

    -- Restore the default behavior of <C-e> and <C-y>
    vim.keymap.set("n", "<C-e>", "", { noremap = true, silent = true }) -- Scroll down one line
    vim.keymap.set("n", "<C-y>", "", { noremap = true, silent = true }) -- Scroll up one line
  end,
}
