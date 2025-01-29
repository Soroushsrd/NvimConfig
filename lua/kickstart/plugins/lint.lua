return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Run ZLint and show output in a split window
      local function run_zlint_direct()
        local filename = vim.fn.expand '%:p'

        -- Create a new scratch buffer for zlint output
        vim.cmd 'botright 10split'
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, buf)

        -- Run zlint and get output
        local output = vim.fn.system('zlint ' .. vim.fn.shellescape(filename))

        -- Clean up the output by removing ANSI codes and special characters
        output = output
          :gsub('\27%[[0-9;]*m', '') -- Remove ANSI color codes
          :gsub('%[%[%d+m?%]?', '') -- Remove box drawing markers
          :gsub('▲', '->') -- Replace unicode arrows
          :gsub('│', '|') -- Replace unicode box drawings
          :gsub('└', '\\-')
          :gsub('├', '|-')
          :gsub('─', '-')
          :gsub('⚠', 'WARNING:')
        -- Split output into lines
        local lines = vim.split(output, '\n', { trimempty = true })

        -- Set buffer options using the newer API
        vim.bo[buf].modifiable = true
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        vim.api.nvim_buf_set_name(buf, 'ZLint Output')

        -- Set the lines in the buffer
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        -- Make buffer read-only
        vim.bo[buf].modifiable = false

        -- Set buffer local mappings
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

        -- Return focus to the original window
        vim.cmd 'wincmd p'
      end

      -- Configure linters by filetype
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- Function to create zlint.json
      local function create_zlint_config()
        local default_config = {
          rules = {
            ['unsafe-undefined'] = 'error',
            ['homeless-try'] = 'warn',
            ['must-return-ref'] = 'warn',
          },
        }

        local config_path = vim.fn.getcwd() .. '/zlint.json'

        if vim.fn.filereadable(config_path) == 1 then
          vim.notify('zlint.json already exists!', vim.log.levels.WARN)
          return
        end

        local file = io.open(config_path, 'w')
        if file then
          file:write(vim.json.encode(default_config))
          file:close()
          vim.notify('Created zlint.json', vim.log.levels.INFO)
        else
          vim.notify('Failed to create zlint.json', vim.log.levels.ERROR)
        end
      end

      -- Keybindings
      vim.keymap.set('n', '<leader>zj', create_zlint_config, {
        desc = 'Create zlint.json config file',
        silent = true,
      })

      vim.keymap.set('n', '<leader>zl', run_zlint_direct, {
        desc = 'Run ZLint on current file',
        silent = true,
      })

      -- Create autocommand for linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      -- Regular linting for markdown files only
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.md',
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
