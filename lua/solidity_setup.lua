-- Create a file named lua/solidity_setup.lua in your Neovim config directory
local M = {}

function M.setup()
  local nvim_lsp = require 'lspconfig'

  -- Setup the Solidity language server
  nvim_lsp.solidity_ls_nomicfoundation.setup {
    cmd = { vim.fn.expand '~/.local/share/nvim/mason/bin/nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = nvim_lsp.util.root_pattern('hardhat.config.*', 'foundry.toml', '.git'),
    single_file_support = true,
    on_attach = function(client, bufnr)
      -- Set up key mappings here if needed
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
      -- Enable formatting
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr })
    end,
    settings = {
      solidity = {
        includePath = '',
        formatter = { enabled = true },
        linter = { enabled = true },
      },
    },
  }

  -- Setup EFM for linting
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

  -- Create autocommand to attach LSP to .sol files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.sol',
    callback = function()
      vim.cmd 'setfiletype solidity'
      -- Force LSP start
      vim.cmd 'LspStart solidity_ls_nomicfoundation'
      vim.cmd 'LspStart efm'
      -- Enable diagnostics
      vim.diagnostic.enable(true)
    end,
  })
end

return M
