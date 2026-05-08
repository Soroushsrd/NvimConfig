return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup {
      org_agenda_files = { '~/org/**/*', '~/notes/**/*' },
      org_default_notes_file = '~/notes/refile.org',
      org_todo_keywords = { 'TODO', '|', 'INPROGRESS', '|', 'DONE' },
      win_split_mode = { 'float', 0.7 },
      org_hide_leading_stars = true,
    }

    -- Experimental LSP support
    vim.lsp.enable 'org'
  end,
}
