return {
  'mhinz/vim-startify',
  lazy = false,
  priority = 100,
  config = function()
    -- Custom header with red coloring
    vim.g.startify_custom_header = {
      [[   ██████╗ ███████╗██╗    ██╗██████╗ ██╗████████╗███████╗    ██╗████████╗]],
      [[   ██╔══██╗██╔════╝██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝    ██║╚══██╔══╝]],
      [[   ██████╔╝█████╗  ██║ █╗ ██║██████╔╝██║   ██║   █████╗      ██║   ██║   ]],
      [[   ██╔══██╗██╔══╝  ██║███╗██║██╔══██╗██║   ██║   ██╔══╝      ██║   ██║   ]],
      [[   ██║  ██║███████╗╚███╔███╔╝██║  ██║██║   ██║   ███████╗    ██║   ██║   ]],
      [[   ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝   ╚═╝   ]],
      [[                                                                          ]],
      [[                     ██╗███╗   ██╗    ██████╗ ██╗   ██╗███████╗████████╗ ]],
      [[                     ██║████╗  ██║    ██╔══██╗██║   ██║██╔════╝╚══██╔══╝ ]],
      [[                     ██║██╔██╗ ██║    ██████╔╝██║   ██║███████╗   ██║    ]],
      [[                     ██║██║╚██╗██║    ██╔══██╗██║   ██║╚════██║   ██║    ]],
      [[                     ██║██║ ╚████║    ██║  ██║╚██████╔╝███████║   ██║    ]],
      [[                     ╚═╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝    ]],
    }

    -- Apply true red coloring using ANSI color codes
    -- Use a more intense red color code instead of the pinkish one
    for i, line in ipairs(vim.g.startify_custom_header) do
      -- Using "\27[38;2;255;0;0m" for true RGB red instead of the standard "\27[31m"
      vim.g.startify_custom_header[i] = '\27[38;2;255;0;0m' .. line .. '\27[0m'
    end

    -- Rest of your configuration remains the same
    vim.g.startify_session_dir = vim.fn.stdpath 'data' .. '/session'

    vim.g.startify_bookmarks = {
      { c = '~/.config/nvim/init.lua' },
      { l = '~/.config/nvim/lua/plugins/init.lua' },
      { z = '~/.zshrc' },
    }

    vim.g.startify_lists = {
      { type = 'files', header = { '   Recent Files' } },
      { type = 'sessions', header = { '   Sessions' } },
      { type = 'bookmarks', header = { '   Bookmarks' } },
    }

    vim.g.startify_session_autoload = 1
    vim.g.startify_change_to_vcs_root = 1
  end,
}
