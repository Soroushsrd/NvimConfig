return {
  -- All colorscheme plugins as dependencies
  { 'loctvl842/monokai-pro.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'ricardoraposo/gruvbox-minor.nvim' },
  { 'sainnhe/gruvbox-material' },
  { 'morhetz/gruvbox', name = 'gruvbox' },
  { 'folke/tokyonight.nvim' },
  { 'scottmckendry/cyberdream.nvim', name = 'cyberdream' },
  { 'rebelot/kanagawa.nvim', name = 'kanagawa' },
  { 'luisiacc/gruvbox-baby', name = 'gruvbox-baby' },
  { 'spaceduck-theme/nvim', name = 'spaceduck' },
  { 'maxmx03/solarized.nvim', name = 'solarized' },

  -- Themery itself
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('themery').setup {
        themes = {
          --- Gruvbox
          {
            name = 'Gruvbox',
            colorscheme = 'gruvbox',
            before = [[
              vim.o.background = 'light'
              vim.g.gruvbox_italic = 1
              vim.g.gruvbox_bold = 1
              vim.g.gruvbox_transparent_bg = 1
              vim.g.gruvbox_contrast_light = 'soft'
            ]],
          },
          -- Gruvbox Material
          {
            name = 'Gruvbox Material',
            colorscheme = 'gruvbox-material',
            before = [[
              vim.o.termguicolors = true
              vim.g.gruvbox_material_enable_italic = true
              vim.g.gruvbox_material_dim_inactive_windows = 0
              vim.g.gruvbox_material_background = 'hard'
              -- vim.g.gruvbox_material_transparent_background = 2
              vim.g.gruvbox_material_cursor = 'auto'
              vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
            ]],
            after = [[
              vim.o.background = 'dark'
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
                  'telescope'
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
          {
            name = 'gruvbox-baby',
            colorscheme = 'gruvbox-baby',
            before = [[ 
            vim.g.gruvbox_baby_background_color = "dark" 
            vim.g.gruvbox_baby_transparent_mode = 1
            ]],
          },
          {
            name = 'Kanagawa',
            colorscheme = 'kanagawa',
            before = [[
            require('kanagawa').setup {
              theme = "wave",
              transparent = true,
              background = {
                dark = "wave",
              },
              colors = {
                theme = {
                  all = {
                    ui = {
                      bg_gutter = "none",
                    },
                  },
                },
              },
            }
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
          {
            name = 'solarized',
            colorscheme = 'solarized',
            before = [[
              require('solarized').setup {
                variant = 'autumn',
                styles = {
                  comments = { italic = true },
                  keywords = { bold = true },
                  functions = { bold = true },
                  types = { italic = true },
                  parameters = { italic = true },
                  statements = { bold = true },
                },
              }
            ]],
            after = [[
              vim.o.background = 'light'
              vim.o.termguicolors = true
            ]],
          },
        },
        livePreview = true,
      }
    end,
  },
}
