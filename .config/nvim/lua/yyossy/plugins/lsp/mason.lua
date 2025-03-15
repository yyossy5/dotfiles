return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
      ensure_installed = {
        "ansiblels",
        "bashls",
        "clangd",
        "cmake",
        "docker_compose_language_service",
        "dockerls",
        "eslint", -- javascript/typescript
        "gopls",
        -- "groovyls",
        "harper_ls", -- toml
        "html",
        "jdtls", -- java
        "jinja_lsp",
        "jsonls",
        "lua_ls",
        "ltex", -- reStructuredText
        "nginx_language_server",
        "pyright", -- python
        "rust_analyzer", -- python
        "sqls",
        "tflint", -- terraform
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "ruff", -- python formatter/linter
        "eslint_d", -- js linter
      },
    })
  end,
}
