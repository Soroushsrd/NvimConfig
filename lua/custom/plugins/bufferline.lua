-- return {
--   'akinsho/bufferline.nvim',
--   event = 'VeryLazy',
--   version = '*', -- Optional: use the latest stable version
--   dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Icons dependency
--   config = function()
--     require('bufferline').setup {
--       options = {
--         mode = 'buffers', -- Tabs/buffers mode
--         separator_style = 'slant', -- Style for buffer separators
--         diagnostics = 'nvim_lsp', -- Integrate with LSP diagnostics
--         offsets = {
--           {
--             filetype = 'NvimTree',
--             text = 'File Explorer',
--             highlight = 'Directory',
--             separator = true,
--           },
--         },
--       },
--     }
--   end,
-- }
return {
  'willothy/nvim-cokeline',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required dependency
    'nvim-tree/nvim-web-devicons', -- For file icons
  },
  event = 'VeryLazy', -- Load when needed
  config = function()
    local get_hex = require('cokeline.hlgroups').get_hl_attr

    require('cokeline').setup {
      default_hl = {
        fg = function(buffer)
          return buffer.is_focused and '#ebdbb2' or '#928374' -- Bright text for active, muted for inactive
        end,
        bg = function(buffer)
          return buffer.is_focused and '#504945' or '#0a0a0a' -- Contrasting bg for active, dark for inactive
        end,
      },
      components = {
        {
          text = function(buffer)
            return ' ' .. buffer.devicon.icon
          end,
          fg = function(buffer)
            return buffer.devicon.color
          end,
        },
        {
          text = function(buffer)
            return buffer.unique_prefix
          end,
          fg = get_hex('Comment', 'fg'),
          italic = true,
        },
        {
          text = function(buffer)
            return buffer.filename .. ' '
          end,
          underline = function(buffer)
            return buffer.is_hovered and not buffer.is_focused
          end,
        },
        {
          text = '',
          on_click = function(_, _, _, _, buffer)
            buffer:delete()
          end,
        },
        {
          text = ' ',
        },
      },
    }

    -- Optional: Set up keybindings
    vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true })
    vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
  end,
}
