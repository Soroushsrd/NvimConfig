return {
  'Senal-D-A-Gunaratna/hyprfade.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    opacity = 0.7, -- opacity for active windows
    opacity_inactive = 0.75, -- opacity for inactive windows
    term_names = { -- process names to recognise as terminals
      'alacritty',
      'foot',
      'ghostty',
      'kitty',
      'wezterm',
    },
  },
  keys = {
    { '<leader>uo', '<cmd>HyprfadeToggle<cr>', desc = 'Toggle window opacity' },
  },
}
