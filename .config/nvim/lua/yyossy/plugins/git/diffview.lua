return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  keys = {
    { "<leader>lo", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<leader>lc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    {
      "<leader>ld",
      "<cmd>DiffviewOpen origin/develop...HEAD<CR>",
      desc = "Open Diffview with origin/develop and HEAD",
    },
    { "<leader>lm", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Open Diffview with origin/main and HEAD" },
    { "<leader>lh", "<cmd>DiffviewFileHistory<CR>", desc = "Open DiffviewFileHistory" },
  },
  opts = {
    view = {
      default = {
        layout = "diff2_horizontal",
      },
    },
    hooks = {
      -- Expand all folds when entering diff mode by default
      -- https://github.com/sindrets/diffview.nvim/issues/437
      diff_buf_win_enter = function()
        vim.opt_local.foldenable = false
      end,
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)
  end,
}
