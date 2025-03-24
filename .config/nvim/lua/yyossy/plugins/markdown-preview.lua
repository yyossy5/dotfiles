-- https://github.com/iamcco/markdown-preview.nvim
-- install with yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  keys = {
    { "<leader>mk", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview Toggle" },
  },
}
