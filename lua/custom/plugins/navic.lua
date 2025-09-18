return {
  'SmiteshP/nvim-navic',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
  opts = {
    lsp = {
      auto_attach = true, -- Automatically attach to LSP servers
    },
    highlight = true, -- Enable syntax highlighting
    separator = ' > ',
    depth_limit = 0,
    depth_limit_indicator = '..',
    safe_output = true,
    lazy_update_context = false,
    click = false,
  },
}
