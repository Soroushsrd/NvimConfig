-- return {
--   'yorumicolors/yorumi.nvim',
--   config = function()
--     vim.cmd.colorscheme 'yorumi'
--   end,
-- }
-- return {
--   'rose-pine/neovim',
--   name = 'rose-pine',
--   config = function()
--     vim.cmd 'colorscheme rose-pine'
--   end,
-- }
-- return {
--   'rebelot/kanagawa.nvim',
--   config = function()
--     vim.cmd 'colorscheme kanagawa-lotus'
--   end,
-- }
-- return {
--   'EdenEast/nightfox.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('nightfox').setup {
--       options = {
--         transparent = true, -- Disable setting background
--         terminal_colors = true, -- Set terminal colors
--         dim_inactive = false, -- Non focused panes set to alternative background
--         module_default = true, -- Default enable value for modules
--       },
--     }
--
--     -- setup must be called before loading the colorscheme
--     vim.cmd 'colorscheme duskfox'
--   end,
-- }
-- return {
--   'ricardoraposo/gruvbox-minor.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- First set up an autocmd that will run after the colorscheme is loaded
--     vim.api.nvim_create_autocmd('ColorScheme', {
--       pattern = 'gruvbox-minor',
--       callback = function()
--         vim.api.nvim_set_hl(0, 'Normal', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'VertSplit', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'TabLine', { bg = '#0a0a0a', fg = '#928374' })
--         vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#0a0a0a' })
--         vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#504945', fg = '#ebdbb2', bold = true })
--       end,
--     })
--
--     -- Then load the colorscheme
--     vim.cmd.colorscheme 'gruvbox-minor'
--   end,
-- }
-- return {
--   'sainnhe/gruvbox-material',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- Optionally configure and load the colorscheme
--     -- directly inside the plugin declaration.
--     -- vim.o.termguicolors = true
--     --
--     -- Important! Enable termguicolors for proper color rendering
--
--     vim.g.gruvbox_material_enable_italic = true
--     vim.g.gruvbox_material_dim_inactive_windows = 0
--     vim.g.gruvbox_material_background = 'hard'
--     vim.o.background = 'dark'
--     -- doesnt work in light mode
--     vim.g.gruvbox_material_transparent_background = 1
--     vim.g.gruvbox_material_cursor = 'auto'
--     vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
--     vim.cmd.colorscheme 'gruvbox-material'
--   end,
-- }
return { -- You can easily change to a different colorscheme.
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    require('tokyonight').setup {
      dim_inactive = false,
      transparent = true,
    }
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'
    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
    vim.cmd.hi 'NeoTreeNormal guibg=NONE'
    vim.cmd.hi 'NeoTreeNormalNC guibg=NONE'
    vim.cmd.hi 'NeoTreeEndOfBuffer guibg=NONE'

    vim.cmd.hi 'TelescopeNormal guibg=NONE'
    vim.cmd.hi 'TelescopeBorder guibg=NONE'
    vim.cmd.hi 'TelescopePromptNormal guibg=NONE'
    vim.cmd.hi 'TelescopePromptBorder guibg=NONE'
    vim.cmd.hi 'TelescopePromptTitle guibg=NONE'
    vim.cmd.hi 'TelescopePreviewTitle guibg=NONE'
    vim.cmd.hi 'TelescopeResultsTitle guibg=NONE'
    vim.cmd.hi 'TelescopePreviewNormal guibg=NONE'
    vim.cmd.hi 'TelescopePreviewBorder guibg=NONE'
    vim.cmd.hi 'TelescopeResultsNormal guibg=NONE'
    vim.cmd.hi 'TelescopeResultsBorder guibg=NONE'
  end,
}
-- return {
--   'bluz71/vim-nightfly-colors',
--   name = 'nightfly',
--   lazy = false,
--   priority = 1000,
--
--   init = function()
--     vim.cmd [[colorscheme nightfly]]
--   end,
-- }
-- return {
--   'yashguptaz/calvera-dark.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'calvera'
--   end,
-- }
-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   priority = 1000,
--   init = function()
--     require('catppuccin').setup {
--       flavour = 'mocha',
--       transparent_background = true,
--       dim_inactive = {
--         enabled = false, -- dims the background color of inactive window
--         shade = 'dark',
--         percentage = 0.4, -- percentage of the shade to apply to the inactive window
--       },
--     }
--
--     vim.cmd.colorscheme 'catppuccin'
--   end,
-- } -- }
