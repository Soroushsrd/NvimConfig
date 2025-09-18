local ocamllsp = require 'lspconfig.configs.ocamllsp'
local M = {}

function M.setup()
  -- diagnostic config
  vim.diagnostic.config {
    virtual_text = {
      virt_text_pos = 'eol',
    },
  }

  -- diagnostic signs
  if vim.g.have_nerd_font then
    local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
      diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config { signs = { text = diagnostic_signs } }
  end

  -- LSP handler configs
  local border = 'rounded'
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#3b4261' }) -- Adjust color as needed

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
    max_width = 80,
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })

  --LSP keymaps
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Document highlighting
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- inlay hints
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- capabilities setup
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  capabilities.offsetEncoding = { 'utf-16' }
  local util = require 'lspconfig/util'

  local servers = {
    clangd = {
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
        '--header-insertion-decorators',
        '--offset-encoding=utf-16',
        '--enable-config',
        '--pch-storage=memory', -- Faster PCH storage
        '--cross-file-rename', -- Enable cross-file renaming
        '--suggest-missing-includes', -- Suggest missing includes
        '--all-scopes-completion', -- Complete symbols from all scopes
        '--function-arg-placeholders', -- Show function argument placeholders
        '--fallback-style=LLVM', -- Fallback formatting style
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
        fallbackFlags = { '-std=c++17' }, -- Default C++ standard
      },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
      root_dir = require('lspconfig').util.root_pattern(
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        'CMakeLists.txt',
        '.git'
      ),
      single_file_support = true,
      settings = {
        clangd = {
          semanticHighlighting = true,
          inlayHints = {
            parameterNames = {
              enabled = true,
              suppressWhenArgumentMatchesName = false,
            },
            deducedTypes = {
              enabled = true,
            },
            designatedInitializers = true,
            blockEnd = true,
          },
          completion = {
            allScopes = true,
          },
          hover = {
            showAKA = true,
          },
        },
      },
      commands = {
        ClangdSwitchSourceHeader = {
          function()
            vim.lsp.buf.execute_command {
              command = 'clangd.switchheader',
            }
          end,
          description = 'Switch between source and header file',
        },
      },
    },

    cmake = {
      filetypes = { 'cmake' },
      highlight = true,
      init_options = {
        buildDirectory = 'build',
      },
      settings = {
        cmake = {
          configureOnOpen = true,
        },
      },
    },
    -- pyright = {
    --   cmd = { 'pyright-langserver', '--stdio' },
    --   filetypes = { 'python' },
    --   root_dir = util.root_pattern('.git', 'pyproject.toml', 'setup.py', 'requirements.txt', '.venv', 'venv'),
    --   settings = {
    --     python = {
    --       analysis = {
    --         autoSearchPaths = true,
    --         useLibraryCodeForTypes = true,
    --         diagnosticMode = 'workspace',
    --         typeCheckingMode = 'basic',
    --         extraPaths = {},
    --       },
    --       pythonPath = '', -- This will use the default Python path
    --     },
    --   },
    --   on_init = function(client)
    --     -- Dynamically determine Python path when the LSP initializes
    --     local function get_python_path()
    --       local poetry_path = vim.fn.trim(vim.fn.system 'poetry env info --path 2>/dev/null')
    --       if poetry_path ~= '' and vim.v.shell_error == 0 then
    --         return poetry_path .. '/bin/python'
    --       end
    --
    --       local venv_paths = {
    --         vim.fn.getcwd() .. '/.venv',
    --         vim.fn.getcwd() .. '/venv',
    --         vim.fn.getcwd() .. '/env',
    --       }
    --
    --       for _, path in ipairs(venv_paths) do
    --         if vim.fn.isdirectory(path) == 1 then
    --           return path .. '/bin/python'
    --         end
    --       end
    --
    --       return vim.fn.exepath 'python'
    --     end
    --
    --     client.config.settings.python.pythonPath = get_python_path()
    --     client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
    --   end,
    --   single_file_support = true,
    -- },
    biome = {
      cmd = { 'biome', 'lsp-proxy' },
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'html' },
      root_dir = require('lspconfig').util.root_pattern('biome.json', 'biome.jsonc'),
      single_file_support = true,
    },
    ts_ls = {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
      init_options = {
        preferences = {
          disableSuggestions = false,
        },
      },
    },
    -- gopls = {
    --   cmd = { 'gopls' },
    --   filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    --   settings = {
    --     gopls = {
    --       gofumpt = true,
    --       codelenses = {
    --         gc_details = false,
    --         generate = true,
    --         regenerate_cgo = true,
    --         run_govulncheck = true,
    --         test = true,
    --         tidy = true,
    --         upgrade_dependency = true,
    --         vendor = true,
    --       },
    --       hints = {
    --         assignVariableTypes = true,
    --         compositeLiteralFields = true,
    --         compositeLiteralTypes = true,
    --         constantValues = true,
    --         functionTypeParameters = true,
    --         parameterNames = true,
    --         rangeVariableTypes = true,
    --       },
    --       analyses = {
    --         fieldalignment = true,
    --         nilness = true,
    --         unusedparams = true,
    --         unusedwrite = true,
    --         useany = true,
    --       },
    --       usePlaceholders = true,
    --       completeUnimported = true,
    --       staticcheck = true,
    --       directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
    --       semanticTokens = true,
    --     },
    --   },
    -- },
    -- ocamllsp = {
    --   filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
    --   root_markers = { '*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace' },
    -- },
    rust_analyzer = {
      capabilities = capabilities,
      auto_attach = true,
      settings = {
        inlayHints = {
          enable = true,
          typeHints = true,
          parameterHints = true,
          chainingHints = true,
        },
        checkOnSave = {
          command = 'clippy',
          extraArgs = { '--all', '---all-features' },
          allTargets = false,
        },
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        diagnostics = {
          enable = true,
          experimental = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
          attributes = {
            enable = true,
          },
        },
        experimental = {
          procAttrMacros = false,
        },
        completion = {
          addCallArgumentSnippets = true,
          addCallParenthesis = true,
          postfix = {
            enable = true,
          },
        },
      },
    },
    html = {
      filetypes = { 'html', 'blade', 'php', 'htmldjango' },
      capabilities = capabilities,
      init_options = {
        configurationSection = { 'html', 'css' },
        embeddedLanguages = {
          css = true,
          -- javascript = true,
          -- typescript = true,
        },
        provideFormatter = true,
      },
    },
    emmet_ls = {
      capabilities = capabilities,
      filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
    },
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
  }
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format)

  require('mason').setup()

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'stylua', -- Used to format Lua code
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

return M
