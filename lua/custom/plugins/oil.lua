return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require('oil').setup {
      -- Optional: customize settings
      default_file_explorer = true, -- replaces netrw
      columns = {
        'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      view_options = {
        show_hidden = false,
      },
    }

    -- Keybindings
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open oil in floating window' })
  end,
}
