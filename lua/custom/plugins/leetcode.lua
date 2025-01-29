return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html', -- if you have `nvim-treesitter` installed
  dependencies = {
    'nvim-telescope/telescope.nvim',
    -- "ibhagwan/fzf-lua",
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    arg = 'leetcode.nvim',

    lang = 'rust',

    cn = { -- leetcode.cn
      enabled = true, ---@type boolean
      translator = false, ---@type boolean
      translate_problems = false, ---@type boolean
    },

    storage = {
      home = vim.fn.stdpath 'data' .. '/leetcode',
      cache = vim.fn.stdpath 'cache' .. '/leetcode',
    },

    plugins = {
      non_standalone = false,
    },

    logging = true,

    injector = {},

    cache = {
      update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
    },

    console = {
      open_on_runcode = true, ---@type boolean

      dir = 'row',

      size = {
        width = '90%',
        height = '75%',
      },

      result = {
        size = '60%',
      },

      testcase = {
        virt_text = true, ---@type boolean

        size = '40%',
      },
    },

    description = {
      position = 'left',

      width = '40%',

      show_stats = true, ---@type boolean
    },

    picker = { provider = nil },

    hooks = {
      ['enter'] = {},

      ['question_enter'] = {},

      ['leave'] = {},
    },

    keys = {
      toggle = { 'q' }, ---@type string|string[]
      confirm = { '<CR>' }, ---@type string|string[]

      reset_testcases = 'r', ---@type string
      use_testcase = 'U', ---@type string
      focus_testcases = 'H', ---@type string
      focus_result = 'L', ---@type string
    },

    theme = {},

    ---@type boolean
    image_support = false,
  },
}
