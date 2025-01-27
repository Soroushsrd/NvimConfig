return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    lang = 'rust',
    storage = {
      home = vim.fn.expand '~/AppData/Local/nvim-data/leetcode',
      cache = vim.fn.expand '~/AppData/Local/nvim-data/leetcode/cache',
    },
    -- Add these settings to handle Windows SSL issues
    https = {
      insecure = true, -- Skip SSL verification
    },
    plugins = {
      non_standalone = true,
    },
  },
  version = '*',
}
