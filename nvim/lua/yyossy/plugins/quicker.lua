-- https://github.com/stevearc/quicker.nvim
return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function()
    local quicker = require("quicker")
    quicker.setup({})
    vim.keymap.set("n", "<leader>fq", function()
      quicker.toggle()
    end, {
      desc = "Toggle quickfix",
    })
    vim.keymap.set("n", "<leader>fl", function()
      quicker.toggle({ loclist = true })
    end, {
      desc = "Toggle loclist",
    })
    vim.keymap.set("n", ">", function()
      quicker.expand({ before = 2, after = 2, add_to_existing = true })
    end, {
      desc = "Expand quickfix context",
    })
    vim.keymap.set("n", "<", function()
      require("quicker").collapse()
    end, {
      desc = "Collapse quickfix context",
    })
  end,
}
