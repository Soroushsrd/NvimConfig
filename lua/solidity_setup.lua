local M = {}
function M.setup()
  local nvim_lsp = require 'lspconfig'
  local util = nvim_lsp.util

  -- Only use solidity_ls for better method completions
  nvim_lsp.solidity_ls.setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
      -- Set up key mappings here if needed
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr })

      -- Enable inlay hints if supported
      if client.supports_method 'textDocument/inlayHint' then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('hardhat.config.*', 'foundry.toml', 'remappings.txt', '.git'),
    settings = {
      solidity = {
        includePath = '',
        remappings = {
          '@openzeppelin/=lib/openzeppelin-contracts/',
          'account-abstraction/=lib/account-abstraction/',
        },
        -- Enable additional features that help with method completion
        enabledAsYouTypeCompilationErrorCheck = true,
        compileUsingRemoteVersion = 'latest',
        -- Enable completions and method suggestions
        completion = {
          enable = true,
          includeMethods = true,
        },
      },
    },
  }

  -- Configure EFM for Solidity linting
  nvim_lsp.efm.setup {
    init_options = { documentFormatting = true },
    filetypes = { 'solidity' },
    root_dir = nvim_lsp.util.root_pattern('.solhint.json', '.git'),
    settings = {
      languages = {
        solidity = {
          {
            lintCommand = 'solhint --formatter unix stdin',
            lintStdin = true,
            lintFormats = { '%f:%l:%c: %m' },
            lintIgnoreExitCode = true,
            lintSource = 'solhint',
          },
        },
      },
    },
  }

  -- Comment out or remove the solidity server setup if you have it elsewhere

  -- Create autocommand to attach LSP to .sol files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.sol',
    callback = function()
      vim.cmd 'setfiletype solidity'
      -- Only start the solidity_ls server, not multiple servers
      vim.cmd 'LspStart solidity_ls'
      vim.cmd 'LspStart efm'
      -- Enable diagnostics
      vim.diagnostic.enable(true)
    end,
  })
end
return M
-- local M = {}
--
-- function M.setup()
--   local nvim_lsp = require 'lspconfig'
--   local util = nvim_lsp.util
--
--   -- solidity
--   nvim_lsp.solidity_ls.setup {
--     capabilities = require('cmp_nvim_lsp').default_capabilities(),
--     on_attach = function(client, bufnr)
--       -- Set up key mappings here if needed
--       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
--       vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
--       vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
--       vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr })
--     end,
--     filetypes = { 'solidity' },
--     root_dir = util.root_pattern('hardhat.config.*', 'foundry.toml', 'remappings.txt', '.git'),
--     settings = {
--       solidity = {
--         includePath = '',
--         remappings = {
--           '@openzeppelin/=lib/openzeppelin-contracts/',
--           'account-abstraction/=lib/account-abstraction/',
--         },
--       },
--     },
--   }
--
--   -- Configure EFM for Solidity linting
--   nvim_lsp.efm.setup {
--     init_options = { documentFormatting = true },
--     filetypes = { 'solidity' },
--     root_dir = nvim_lsp.util.root_pattern('.solhint.json', '.git'),
--     settings = {
--       languages = {
--         solidity = {
--           {
--             lintCommand = 'solhint --formatter unix stdin',
--             lintStdin = true,
--             lintFormats = { '%f:%l:%c: %m' },
--             lintIgnoreExitCode = true,
--             lintSource = 'solhint',
--           },
--         },
--       },
--     },
--   }
--
--   -- Create autocommand to attach LSP to .sol files
--   vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--     pattern = '*.sol',
--     callback = function()
--       vim.cmd 'setfiletype solidity'
--       -- Force LSP start
--       vim.cmd 'LspStart solidity-ls'
--       vim.cmd 'LspStart efm'
--       -- Enable diagnostics
--       vim.diagnostic.enable(true)
--     end,
--   })
-- end
--
-- return M
