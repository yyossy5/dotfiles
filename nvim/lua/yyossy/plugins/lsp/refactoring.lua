-- https://github.com/ThePrimeagen/refactoring.nvim
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    require("refactoring").setup({
      -- load refactoring Telescope extension
      require("telescope").load_extension("refactoring"),
      vim.keymap.set({ "n", "x" }, "<leader>rr", function()
        require("telescope").extensions.refactoring.refactors()
      end, { desc = "Refactor: Open Telescope Refactors" }),

      -- You can also use below = true here to to change the position of the printf
      -- statement (or set two remaps for either one). This remap must be made in normal mode.
      vim.keymap.set("n", "<leader>rp", function()
        require("refactoring").debug.printf({ below = true })
      end, { desc = "Refactor: Insert debug printf (below)" }),

      -- Supports both visual and normal mode
      vim.keymap.set({ "x", "n" }, "<leader>rv", function()
        require("refactoring").debug.print_var()
      end, { desc = "Refactor: Print variable" }),

      -- Supports only normal mode
      vim.keymap.set("n", "<leader>rc", function()
        require("refactoring").debug.cleanup({})
      end, { desc = "Refactor: Cleanup debug statements" }),

      -- overriding printf statement for cpp
      printf_statements = {
        -- add a custom printf statement for cpp
        cpp = {
          'std::cout << "%s" << std::endl;',
        },
      },
    })
  end,
}
