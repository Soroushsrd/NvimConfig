return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local hooks = require 'ibl.hooks'
      -- Configure indent-blankline
      require('ibl').setup {
        exclude = {
          filetypes = {
            'dashboard',
            'alpha',
            'starter',
          },
          buftypes = {
            'terminal',
            'nofile',
            'quickfix',
            'prompt',
          },
        },
      }
      -- Add hook to disable for dashboard buffer
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
