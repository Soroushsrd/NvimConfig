return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    vim.cmd 'colorscheme rose-pine'
  end,
}
-- return {
--   {
--     'AlexvZyl/nordic.nvim',
--     priority = 1000,
--     opts = {
--       -- This callback can be used to override the colors used in the base palette
--       on_palette = function(palette) end,
--       -- This callback can be used to override the colors used in the extended palette
--       after_palette = function(palette) end,
--       -- This callback can be used to override highlights before they are applied
--       on_highlight = function(highlights, palette) end,
--       -- Enable bold keywords
--       bold_keywords = false,
--       -- Enable italic comments
--       italic_comments = true,
--       -- Enable editor background transparency
--       transparent = {
--         -- Enable transparent background
--         bg = false,
--         -- Enable transparent background for floating windows
--         float = false,
--       },
--       -- Enable brighter float border
--       bright_border = false,
--       -- Reduce the overall amount of blue in the theme
--       reduced_blue = true,
--       -- Swap the dark background with the normal one
--       swap_backgrounds = false,
--       -- Cursorline options. Also includes visual/selection
--       cursorline = {
--         -- Bold font in cursorline
--         bold = false,
--         -- Bold cursorline number
--         bold_number = true,
--         -- Available styles: 'dark', 'light'
--         theme = 'dark',
--         -- Blending the cursorline bg with the buffer bg
--         blend = 0.85,
--       },
--       noice = {
--         -- Available styles: 'classic', 'flat'
--         style = 'flat',
--       },
--       telescope = {
--         -- Available styles: 'classic', 'flat'
--         style = 'flat',
--       },
--       leap = {
--         -- Dims the backdrop when using leap
--         dim_backdrop = false,
--       },
--       ts_context = {
--         -- Enables dark background for treesitter-context window
--         dark_background = true,
--       },
--     },
--     config = function(_, opts)
--       require('nordic').setup(opts)
--       vim.cmd [[colorscheme nordic]]
--     end,
--   },
-- }
-- return {
--   'tiagovla/tokyodark.nvim',
--   opts = {
--     -- custom options here
--   },
--   config = function(_, opts)
--     require('tokyodark').setup(opts) -- calling setup is optional
--     vim.cmd [[colorscheme tokyodark]]
--   end,
-- }
-- return { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use :Telescope colorscheme.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   init = function()
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-night'
--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- }
-- return {
--   'bettervim/yugen.nvim',
--   config = function()
--     vim.cmd.colorscheme 'yugen'
--   end,
-- }
-- return {
--   {
--     'yorumicolors/yorumi.nvim',
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme 'yorumi'
--     end,
--   },
-- }
-- return {
--   'shaunsingh/nord.nvim',
--   priority = 1000,
--   init = function()
--     -- Basic Nord configuration
--     vim.g.nord_contrast = true
--     vim.g.nord_borders = true
--     vim.g.nord_disable_background = false
--     vim.g.nord_italic = true
--     vim.g.nord_uniform_diff_background = true
--     -- Load the colorscheme first
--     vim.cmd.colorscheme 'nord'
--     -- Then apply custom highlights
--     local custom_highlights = {
--       -- Make normal background darker
--       Normal = { bg = '#1a1b26' },
--       NormalFloat = { bg = '#1a1b26' },
--       NvimTreeNormal = { bg = '#1a1b26' },
--       StatusLine = { bg = '#1a1b26' },
--       -- Darker sidebar
--       NvimTreeNormalNC = { bg = '#16161e' },
--       -- Comments
--       Comment = { italic = true },
--       ['@comment'] = { italic = true },
--       -- Keywords and Functions
--       Keyword = { bold = true, fg = '#81A1C1' },
--       Function = { fg = '#B48EAD', bold = true },
--       String = { fg = '#A3BE8C' },
--       -- Floating windows
--       FloatBorder = { bg = '#16161e' },
--       TelescopeBorder = { bg = '#16161e' },
--       -- Types
--       Type = { fg = '#5E81AC', bold = true },
--       ['@type'] = { fg = '#5E81AC' },
--       ['@type.builtin'] = { fg = '#81A1C1' },
--       ['@type.qualifier'] = { fg = '#88C0D0' },
--       ['@type.definition'] = { fg = '#5E81AC' },
--       ['@type.primitive'] = { fg = '#4C566A' },
--       -- Class related
--       ['@class'] = { fg = '#5E81AC', bold = true },
--       ['@class.constructor'] = { fg = '#88C0D0' },
--       -- Constants
--       ['@constant'] = { fg = '#345E4B' },
--       ['@constant.builtin'] = { fg = '#345E4B' },
--       Constant = { fg = '#345E4B' },
--     }
--     -- Apply the highlights
--     for group, colors in pairs(custom_highlights) do
--       vim.api.nvim_set_hl(0, group, colors)
--     end
--   end,
-- }
