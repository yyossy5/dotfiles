return {
  {
    "j-morano/buffer_manager.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local buffer_manager = require("buffer_manager")
      buffer_manager.setup({
        select_menu_item_commands = {
          edit = { key = "<CR>", command = "edit" },
          split = { key = "<C-h>", command = "split" },
          vsplit = { key = "<C-v>", command = "vsplit" },
          delete = { key = "<C-x>", command = "bdelete" },
        },
      })

      vim.keymap.set("n", "<leader>d", function()
        require("buffer_manager.ui").toggle_quick_menu()
      end, { desc = "Open Buffer Manager" })
    end,
  },
}
