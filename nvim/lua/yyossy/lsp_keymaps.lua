-- プラグインとして認識されないようにpluginsディレクトリと
-- lsp_keymaps.luaを同階層に配置

local M = {}

function M.setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- LSP接続確認
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    vim.notify("No LSP client attached to buffer", vim.log.levels.WARN)
    return
  end

  -- ctagsキーマップを無効化してLSPを優先
  vim.keymap.set("n", "<C-]>", function()
    vim.lsp.buf.definition()
  end, { buffer = bufnr, silent = true, desc = "Go to definition (LSP)" })

  opts.desc = "Show LSP references"
  vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

  opts.desc = "Go to declaration"
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

  opts.desc = "Show LSP definitions"
  vim.keymap.set("n", "gd", function()
    -- LSPサーバーが利用可能かチェック
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients > 0 then
      vim.cmd("Telescope lsp_definitions")
    else
      vim.notify("LSP not available", vim.log.levels.WARN)
    end
  end, opts)

  opts.desc = "Show LSP implementations"
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

  opts.desc = "Show LSP type definitions"
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

  opts.desc = "See available code actions"
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  opts.desc = "Smart rename"
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  opts.desc = "Show line diagnostics"
  vim.keymap.set("n", "<leader>b", vim.diagnostic.open_float, opts)

  opts.desc = "Show buffer diagnostics"
  vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

  opts.desc = "Go to previous diagnostic"
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

  opts.desc = "Go to next diagnostic"
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  opts.desc = "Hover documentation"
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  opts.desc = "Restart LSP"
  vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

  -- デバッグ用：LSP情報を表示
  opts.desc = "Show LSP info"
  vim.keymap.set("n", "<leader>li", function()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then
      vim.notify("No LSP clients attached", vim.log.levels.INFO)
    else
      for _, client in ipairs(clients) do
        vim.notify(string.format("LSP: %s (id: %d)", client.name, client.id), vim.log.levels.INFO)
      end
    end
  end, opts)
end

return M
