return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'nightfly', --'pywal', -- or choose a specific theme like 'gruvbox'
        -- theme = {
        --   normal = { c = { fg = '#c5c8c6', bg = '#2d3640' } },
        --   insert = { c = { fg = '#ffffff', bg = '#35a770' } },
        --   visual = { c = { fg = '#ffc033', bg = '#1f5872' } },
        --   replace = { c = { fg = '#ffffff', bg = '#bd0f2f' } },
        --   command = { c = { fg = '#ffffff', bg = '#a74eff' } },
        -- },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- component_separators = '|',
        -- section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
}
-- return {
--   'vim-airline/vim-airline',
--   lazy = false,
--   priority = 1000,
--   dependencies = {
--     { 'vim-airline/vim-airline-themes' },
--     { 'ryanoasis/vim-devicons' },
--   },
--   config = function()
--     vim.g.airline_theme = 'spaceduck'
--   end,
-- }
