return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  -- Explicit dependencies (lazy.nvim will install & load these first)
  dependencies = {
    "williamboman/mason.nvim", -- LSP/DAP/Linter installer UI
    "williamboman/mason-lspconfig.nvim", -- mason ↔ nvim-lspconfig bridge (v2.x)
    "hrsh7th/cmp-nvim-lsp", -- LSP completion capabilities
    { "antosha417/nvim-lsp-file-operations", config = true }, -- auto-refresh on rename/move
    { "folke/neodev.nvim", opts = {} }, -- better Lua LS for Neovim configs
  },

  config = function()
    ---------------------------------------------------------------------------
    -- Imports
    ---------------------------------------------------------------------------
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- Global LSP capabilities (used for every server)
    ---------------------------------------------------------------------------
    local capabilities = cmp_nvim_lsp.default_capabilities()

    ---------------------------------------------------------------------------
    -- Diagnostic signs in the gutter
    ---------------------------------------------------------------------------
    local signs = { Error = "✖ ", Warn = "⚠ ", Hint = "⚑ ", Info = "ℹ " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    ---------------------------------------------------------------------------
    -- Floating-window borders
    ---------------------------------------------------------------------------
    local original_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "double"
      return original_open_floating_preview(contents, syntax, opts, ...)
    end

    ---------------------------------------------------------------------------
    -- Buffer-local keymaps when the LSP attaches
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        -- opts.desc = "Show line diagnostics"
        -- keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Hover documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        -- Java specific keymaps
        if vim.bo.filetype == "java" then
          opts.desc = "Organize imports"
          keymap.set("n", "<leader>jo", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
            })
          end, opts)

          opts.desc = "Add missing imports (show all available imports)"
          keymap.set("n", "<leader>ji", function()
            -- Get all available code actions for import resolution
            vim.lsp.buf.code_action({
              filter = function(action)
                return action.kind
                  and (
                    string.match(action.kind, "quickfix")
                    or string.match(action.kind, "source")
                    or string.match(action.title, "[Ii]mport")
                  )
              end,
            })
          end, opts)

          opts.desc = "Auto import under cursor"
          keymap.set("n", "<leader>jI", function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "source.organizeImports", "quickfix" } }

            vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx, config)
              if err then
                vim.notify("Error getting code actions: " .. err.message, vim.log.levels.ERROR)
                return
              end

              if not result or vim.tbl_isempty(result) then
                vim.notify("No import actions available", vim.log.levels.INFO)
                return
              end

              -- Apply the first import-related action
              for _, action in ipairs(result) do
                if action.title and string.match(action.title, "[Ii]mport") then
                  vim.lsp.buf.execute_command(action.command or action)
                  return
                end
              end

              vim.notify("No import actions found", vim.log.levels.INFO)
            end)
          end, opts)
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- mason-lspconfig v2.x setup
    ---------------------------------------------------------------------------
    mason_lspconfig.setup({
      -- If you want automatic installation, uncomment ↓
      -- ensure_installed = { "lua_ls", "pyright", "gopls", "rust_analyzer", ... },
      handlers = {
        -- Default handler (executes for *every* installed server)
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- ---★ Per-server customisations ---------------------------------------------------
        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
              },
            },
          })
        end,

        pyright = function()
          lspconfig.pyright.setup({
            capabilities = capabilities,
            -- Use the nearest .git directory as root to resolve absolute imports
            root_dir = lspconfig.util.root_pattern(".git"),
          })
        end,

        -- jdtls is now handled by nvim-jdtls plugin instead of lspconfig
        -- jdtls = function() ... end,

        --[[ Example: customise SQLs
        sqls = function()
          lspconfig.sqls.setup({
            on_attach = function(client, bufnr)
              require("sqls").on_attach(client, bufnr)
            end,
            capabilities = capabilities,
            settings = {
              sqls = {
                connections = {
                  {
                    driver = "mysql",
                    dataSourceName = "root:root@tcp(127.0.0.1:13306)/world",
                  },
                },
              },
            },
          })
        end,
        ]]
      },
    })
  end,
}
