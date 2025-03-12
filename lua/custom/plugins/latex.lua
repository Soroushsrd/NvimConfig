return {
  {
    'lervag/vimtex',
    lazy = false, -- Load immediately
    config = function()
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_view_method = 'zathura' -- or 'mupdf', 'evince', etc.
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_latexmk = {
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }
    end,
  },
  {
    'L3MON4D3/LuaSnip', -- Snippet engine
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
