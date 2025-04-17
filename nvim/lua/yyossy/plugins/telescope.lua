return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/" }, -- exclude .git directory
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, -- exclude .git directory
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            -- ["<C-q>"] = actions.close, -- <C-q> to close Telescope
          },
          -- n = {
          --   ["<C-q>"] = actions.close, -- <C-q> to close Telescope in normal mode
          -- },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end,
        },
      },
    })

    telescope.load_extension("fzf")

    -- Define last search term storage
    local last_search_term = ""

    -- Custom function: prompt input with last used string
    local function live_grep_with_input(text)
      local input = text or vim.fn.input("Grep > ", last_search_term)
      if input == "" then
        return
      end
      last_search_term = input
      require("telescope.builtin").live_grep({ default_text = input })
    end

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    --keymap.set("n", "<leader>fs", live_grep_with_input, { desc = "Find string in cwd (persistent input)" })
    -- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fc", function()
      local word = vim.fn.expand("<cWORD>")
      if word ~= "" then
        live_grep_with_input(word)
      end
    end, { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find({
        -- no fuzzy
        fuzzy = false,
        case_mode = "smart_case",
      })
    end, { desc = "Find in current buffer" })
  end,
}
