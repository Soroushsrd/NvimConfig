return {
  -- All colorscheme plugins as dependencies
  { 'loctvl842/monokai-pro.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'ricardoraposo/gruvbox-minor.nvim' },
  { 'sainnhe/everforest' },
  { 'sainnhe/gruvbox-material' },
  { 'folke/tokyonight.nvim' },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly' },
  { 'yashguptaz/calvera-dark.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'scottmckendry/cyberdream.nvim', name = 'cyberdream' },
  { 'IroncladDev/osmium', name = 'osmium' },

  -- Themery itself
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('themery').setup {
        themes = {
          {
            name = 'SpaceDark',
            colorscheme = 'spacedark',
          },
          {
            name = 'Ayu',
            colorscheme = 'ayu',
          },
          {
            name = 'Glacier',
            colorscheme = 'glacier',
          },
          {
            name = 'Seadark',
            colorscheme = 'seadark',
          },
          {
            name = 'Lucid',
            colorscheme = 'lucid',
          },
          {
            name = 'TicToc',
            colorscheme = 'tictoc',
          },
          {
            name = 'SpaceDuck',
            colorscheme = 'spaceduck',
          },
          {
            name = 'Gruvbox',
            colorscheme = 'gruvbox',
          },
          {
            name = 'Iceberg',
            colorscheme = 'iceberg',
          },
          {
            name = 'Memoonry',
            colorscheme = 'memoonry',
          },
          -- Osmium
          {
            name = 'Osmium',
            colorscheme = 'osmium',
            before = [[
              require('osmium').setup({
                transparent_bg = true,
              })
            ]],
          },
          -- Monokai Pro (Classic, Transparent)
          {
            name = 'Monokai Pro Classic',
            colorscheme = 'monokai-pro',
            before = [[
              require('monokai-pro').setup {
                transparent_background = true,
                
                filter = 'classic',
                dim_inactive= false,
                background_clear = {
                  "neo-tree",
                  "bufferline",
                }
              }
            ]],
          },
          -- Cyberdream
          {
            name = 'Cyberdream',
            colorscheme = 'cyberdream',
            before = [[
              require('cyberdream').setup({
                transparent = true,
                italic_comments = true,
                cache = true,
              })
            ]],
          },

          -- Nightfox: Duskfox (Transparent)
          {
            name = 'Duskfox',
            colorscheme = 'duskfox',
            before = [[
              require('nightfox').setup {
                options = {
                  transparent = true,
                  terminal_colors = true,
                  dim_inactive = false,
                  module_default = true,
                },
              }
            ]],
          },

          -- Gruvbox Minor
          {
            name = 'Gruvbox Minor',
            colorscheme = 'gruvbox-minor',
          },

          -- Everforest (Dark Hard)
          {
            name = 'Everforest',
            colorscheme = 'everforest',
            before = [[
              vim.o.termguicolors = true
              vim.g.everforest_enable_italic = true
              vim.g.everforest_dim_inactive_windows = 0
              vim.g.everforest_background = 'hard'
              vim.o.background = 'dark'
              vim.g.everforest_transparent_background = 0
              vim.g.everforest_cursor = 'green'
              vim.g.everforest_better_performance = 1
              vim.g.everforest_inlay_hints_background = 'dimmed'
            ]],
          },

          -- Gruvbox Material (Dark Hard, Transparent)
          {
            name = 'Gruvbox Material',
            colorscheme = 'gruvbox-material',
            before = [[
              vim.o.termguicolors = true
              vim.g.gruvbox_material_enable_italic = true
              vim.g.gruvbox_material_dim_inactive_windows = 0
              vim.g.gruvbox_material_background = 'hard'
              vim.o.background = 'dark'
              vim.g.gruvbox_material_transparent_background = 1
              vim.g.gruvbox_material_cursor = 'auto'
              vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
            ]],
          },

          -- TokyoNight (Transparent)
          {
            name = 'TokyoNight Night',
            colorscheme = 'tokyonight-night',
            before = [[
              require('tokyonight').setup {
                dim_inactive = false,
                transparent = true,
              }
            ]],
            after = [[
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
            ]],
          },

          -- Nightfly
          {
            name = 'Nightfly',
            colorscheme = 'nightfly',
          },

          -- Calvera Dark
          {
            name = 'Calvera Dark',
            colorscheme = 'calvera',
          },

          -- Catppuccin Mocha (Transparent)
          {
            name = 'Catppuccin Mocha',
            colorscheme = 'catppuccin',
            before = [[
              require('catppuccin').setup {
                flavour = 'mocha',
                transparent_background = true,
                dim_inactive = {
                  enabled = false,
                  shade = 'dark',
                  percentage = 0.4,
                },
              }
            ]],
          },
        },
        livePreview = true,
      }
    end,
  },
}
