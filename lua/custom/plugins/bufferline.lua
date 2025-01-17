return {
  'akinsho/bufferline.nvim',
  version = '*', -- Optional: use the latest stable version
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Icons dependency
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- Tabs/buffers mode
        separator_style = 'slant', -- Style for buffer separators
        diagnostics = 'nvim_lsp', -- Integrate with LSP diagnostics
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
    }
  end,
}
