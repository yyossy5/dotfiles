return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls_setup = require("jdtls.setup")

    -- マルチモジュールプロジェクトのルートディレクトリを見つける関数
    local function get_project_root()
      local markers = { "pom.xml", "build.gradle", "settings.gradle", ".git" }
      local current_dir = vim.fn.expand("%:p:h")

      -- 親pom.xml（modulesを含む）を優先的に探す
      local function find_parent_pom(path)
        local current = path
        while current ~= "/" do
          local pom_path = current .. "/pom.xml"
          if vim.fn.filereadable(pom_path) == 1 then
            local content = vim.fn.readfile(pom_path)
            for _, line in ipairs(content) do
              if string.match(line, "<modules>") or string.match(line, "<module>") then
                return current
              end
            end
          end
          current = vim.fn.fnamemodify(current, ":h")
        end
        return nil
      end

      local parent_root = find_parent_pom(current_dir)
      if parent_root then
        return parent_root
      end

      -- fallback: 通常のマーカーファイルを探す
      return vim.fs.dirname(vim.fs.find(markers, { upward = true })[1]) or vim.fn.getcwd()
    end

    local project_root = get_project_root()
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(project_root, ":t")

    local home = os.getenv("HOME")
    local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
    local config_dir = jdtls_path .. "/config_mac" -- if you use linux /config_linux
    local launcher_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    function get_java_home()
      local handle = io.popen("/usr/libexec/java_home -v 21")
      local java_home = handle:read("*a"):gsub("%s+", "")
      handle:close()
      return java_home
    end

    function get_java()
      return get_java_home() .. "/bin/java"
    end

    local config = {
      cmd = {
        get_java(),
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Declipse.log.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_path,
        "-configuration",
        config_dir,
        "-data",
        workspace_dir,
      },
      root_dir = project_root,
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = get_java_home(),
                default = true,
              },
            },
            updateBuildConfiguration = "automatic",
          },
          import = {
            gradle = {
              enabled = true, -- Gradleサポートを有効化
            },
            maven = {
              enabled = true, -- Mavenサポートを有効化
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
          },
          eclipse = { downloadSources = true },
          format = {
            enabled = true,
          },
          implementationsCodeLens = { enabled = true },
          inlayHints = { parameterNames = { enabled = "all" } },
          maven = { downloadSources = true },
          referencesCodeLens = { enabled = true },
          references = { includeDecompiledSources = true },
          saveActions = {
            organizeImports = false,
          },
          signatureHelp = { enabled = true },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          contentProvider = { preferred = "fernflower" },
          compile = { nullAnalysis = { mode = "automatic" } },
          project = {
            referencedLibraries = {
              "lib/**/*.jar",
              "**/*.jar",
            },
          },
        },
      },
      init_options = {
        bundles = {},
        extendedClientCapabilities = jdtls_setup.extendedClientCapabilities,
      },
      on_attach = function(client, bufnr)
        -- JDTLSのステータス情報を出力
        vim.notify(string.format("JDTLS attached to buffer %d", bufnr), vim.log.levels.INFO)
        vim.notify(string.format("Project root: %s", project_root), vim.log.levels.INFO)
        vim.notify(string.format("Workspace dir: %s", workspace_dir), vim.log.levels.INFO)

        -- LSPが完全に準備できるまで待つ
        vim.defer_fn(function()
          -- 共通のLSPキーマップを設定
          require("yyossy.lsp_keymaps").setup_lsp_keymaps(bufnr)
        end, 100)

        -- Java固有のキーマップ
        local opts = { buffer = bufnr, silent = true }

        opts.desc = "Organize imports"
        vim.keymap.set("n", "<leader>jo", function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
        end, opts)

        opts.desc = "Add missing imports"
        vim.keymap.set("n", "<leader>ji", function()
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

        -- JDTLSデバッグ情報表示
        opts.desc = "JDTLS debug info"
        vim.keymap.set("n", "<leader>jd", function()
          -- プロジェクト情報
          vim.notify("=== JDTLS Debug Info ===", vim.log.levels.INFO)
          vim.notify("Project root: " .. (project_root or "unknown"), vim.log.levels.INFO)
          vim.notify("Workspace dir: " .. (workspace_dir or "unknown"), vim.log.levels.INFO)
          vim.notify("Current file: " .. vim.fn.expand("%:p"), vim.log.levels.INFO)

          -- LSPクライアント情報
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          for _, c in ipairs(clients) do
            if c.name == "jdtls" then
              vim.notify("JDTLS client ID: " .. c.id, vim.log.levels.INFO)
              vim.notify("JDTLS status: " .. (c.is_stopped() and "stopped" or "running"), vim.log.levels.INFO)
            end
          end

          -- プロジェクトの状態確認
          local status_ok, status = pcall(function()
            return vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", {
              command = "java.project.getAll",
            }, 2000)
          end)

          if status_ok and status then
            vim.notify("Project status: OK", vim.log.levels.INFO)
          else
            vim.notify("Project status: ERROR - " .. tostring(status), vim.log.levels.WARN)
          end
        end, opts)

        -- プロジェクトの再読み込み
        opts.desc = "Reload JDTLS project"
        vim.keymap.set("n", "<leader>jr", function()
          vim.lsp.buf.execute_command({
            command = "java.clean.workspace",
          })
          vim.notify("JDTLS workspace cleaning...", vim.log.levels.INFO)
          vim.defer_fn(function()
            vim.cmd("LspRestart")
            vim.notify("JDTLS restarted", vim.log.levels.INFO)
          end, 2000)
        end, opts)
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    jdtls_setup.start_or_attach(config)
  end,
}
