return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")

    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = jdtls_setup.find_root(root_markers)
    if not root_dir then
      return
    end

    local home = os.getenv("HOME")
    local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
    local config_dir = jdtls_path .. "/config_mac" -- if you use linux /config_linux
    local launcher_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

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
      root_dir = root_dir,
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = get_java_home(),
              },
            },
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
        },
      },
      init_options = {
        bundles = {},
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
      },
      on_attach = function(client, bufnr)
        -- 共通のLSPキーマップを設定
        require("yyossy.lsp_keymaps").setup_lsp_keymaps(bufnr)

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
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    jdtls.start_or_attach(config)
  end,
}
