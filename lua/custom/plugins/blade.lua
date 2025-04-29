return {
  'ricardoramirezr/blade-nav.nvim',
  dependencies = { -- totally optional
    'hrsh7th/nvim-cmp', -- if using nvim-cmp
    -- { 'ms-jpq/coq_nvim', branch = 'coq' }, -- if using coq
  },
  ft = { 'blade', 'php' }, -- optional, improves startup time
  opts = {
    close_tag_on_complete = true, -- default: true
  },
}
