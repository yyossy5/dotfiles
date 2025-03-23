-- Treesitter is an awesome Neovim feature that provides better syntax highlighting,
-- indentation, autotagging, incremental selection and many other cool features.

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "groovy",
        "gitignore",
        "html",
        "json",
        "javascript",
        "jsdoc",
        "jinja",
        "julia",
        "java",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nginx",
        "python",
        "query",
        "rust",
        "sql",
        "typescript",
        "tsx",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
