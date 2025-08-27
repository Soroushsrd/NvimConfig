vim.opt.termguicolors = true
vim.cmd 'colorscheme spaceduck'
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
]]
-- Ensure statusline is always loaded
vim.g.neovide_opacity = 0.90
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
-- vim.o.guifont = 'JetBrainsMono Nerd Font:h11'
-- vim.o.guifont = 'CaskaydiaCove Nerd Font Propo:h11'
vim.o.guifont = 'FiraCode Nerd Font:h12'
-- Set NotifyBackground highlight group
if vim.g.neovide then
  vim.g.neovide_fullscreen = true
end
--Terminal:
-- Create a global table for our terminal functions
_G.terminal_utils = {}

-- Variable to store the terminal buffer ID
local terminal_state = {
  buf_id = nil,
}

-- Function to close terminal
function _G.terminal_utils.close_term()
  if terminal_state.buf_id and vim.api.nvim_buf_is_valid(terminal_state.buf_id) then
    vim.api.nvim_buf_delete(terminal_state.buf_id, { force = true })
    terminal_state.buf_id = nil
  end
end

-- Function to create a terminal split
local function create_term()
  -- Create new split
  vim.cmd 'split'
  -- Resize to reasonable height (adjust the number as needed)
  vim.cmd 'resize 10'

  -- Create and set up terminal buffer
  local buf = vim.api.nvim_create_buf(false, true)
  terminal_state.buf_id = buf

  -- Set buffer in the new split
  vim.api.nvim_win_set_buf(0, buf)

  -- Start terminal
  vim.fn.termopen(vim.o.shell)

  -- Set up terminal-specific keymaps
  vim.api.nvim_buf_set_keymap(buf, 't', '<C-q>', '<C-\\><C-n>:lua terminal_utils.close_term()<CR>', { noremap = true, silent = true })

  -- Enter insert mode automatically
  vim.cmd 'startinsert'
end

-- Python venv related
vim.api.nvim_create_user_command('PythonLspInfo', function()
  local clients = vim.lsp.get_active_clients { name = 'pyright' }
  if #clients > 0 then
    local pythonPath = clients[1].config.settings.python.pythonPath
    print('Python path: ' .. (pythonPath ~= '' and pythonPath or 'default system Python'))
  else
    print 'Pyright not running'
  end
end, {})
-- Template loading function
vim.api.nvim_create_user_command('Template', function(opts)
  local template_name = opts.args
  local template_path = vim.fn.stdpath 'config' .. '/templates/html/' .. template_name .. '.html'

  if vim.fn.filereadable(template_path) == 1 then
    local lines = vim.fn.readfile(template_path)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    -- Move cursor to a sensible position (e.g., between body tags)
    vim.cmd 'normal! /<body>\\n/+1'
  else
    print('Template not found: ' .. template_name)
  end
end, {
  nargs = 1,
  complete = function()
    local template_dir = vim.fn.stdpath 'config' .. '/templates/html/'
    local templates = vim.fn.globpath(template_dir, '*.html', false, true)
    local result = {}
    for _, template in ipairs(templates) do
      table.insert(result, vim.fn.fnamemodify(template, ':t:r'))
    end
    return result
  end,
})

-- Auto-template for new HTML files (optional)
vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
  pattern = '*.html',
  callback = function()
    vim.cmd 'Template basic'
  end,
})
-- HTML specific indentation settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'html',
  callback = function()
    vim.bo.tabstop = 2 -- Width of tab character
    vim.bo.softtabstop = 2 -- Fine tunes amount of whitespace
    vim.bo.shiftwidth = 2 -- Number of spaces for each indentation
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.autoindent = true -- Copy indent from current line when starting a new line
  end,
})
-- Create the commands
vim.api.nvim_create_user_command('Term', create_term, {})
vim.api.nvim_create_user_command('TermClose', _G.terminal_utils.close_term, {})

-- Set up the keymaps
vim.keymap.set('n', '<Leader>tt', ':Term<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>x', ':TermClose<CR>', { noremap = true, silent = true })
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.shiftwidth = 2 -- Indent with 4 spaces
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'cpp', 'c' },
  callback = function()
    local is_go = vim.bo.filetype == 'go'
    -- Use real tabs only in Go, spaces in C++
    vim.bo.expandtab = not is_go
    -- Set tab width to 4
    vim.bo.tabstop = 2
    -- Set shift width for autoindent
    vim.bo.shiftwidth = 2
    -- Set how many spaces a tab counts for
    vim.bo.softtabstop = 2
  end,
})

vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- floating windows

-- Global floating window border configuration
-- local border = 'rounded'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- cargo commands
vim.keymap.set('n', '<Leader>cc', "<cmd>lua vim.cmd('Cargo clippy')<CR>", { desc = 'Cargo clippy' })
vim.keymap.set('n', '<Leader>cr', "<cmd>lua vim.cmd('Cargo run')<CR>", { desc = 'Cargo run' })
-- bash commands
vim.keymap.set('n', '<Leader>hh', ':!chmod +x %<CR>', { silent = true, desc = 'Make bash executable' })
vim.keymap.set('n', '<Leader>hr', ':!%<CR>', { silent = true, desc = 'Run bash executable' })
-- Solidity filetype detection
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.sol',
  callback = function()
    vim.opt_local.filetype = 'solidity'
  end,
})

-- Solidity-specific indentation
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'solidity',
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
    vim.bo.smartindent = true
  end,
})

-- Function to toggle Anvil terminal
local anvil_term_id = nil

function _G.toggle_anvil()
  if anvil_term_id == nil or not vim.api.nvim_buf_is_valid(anvil_term_id) then
    vim.cmd 'botright split'
    vim.cmd 'resize 15'
    anvil_term_id = vim.api.nvim_get_current_buf()
    vim.fn.termopen 'anvil'
    vim.cmd 'set nobuflisted'
  else
    local win_ids = vim.fn.win_findbuf(anvil_term_id)
    if #win_ids == 0 then
      vim.cmd 'botright split'
      vim.cmd 'resize 15'
      vim.cmd('buffer ' .. anvil_term_id)
    else
      vim.api.nvim_win_close(win_ids[1], true)
    end
  end
end
vim.api.nvim_create_user_command('BiomeInit', function()
  local biome_config = [[
{
  "$schema": "https://biomejs.dev/schemas/1.5.3/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double",
      "trailingCommas": "es5",
      "semicolons": "always"
    }
  },
  "files": {
    "include": ["**/*.js", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.html"],
    "ignore": ["node_modules", "dist"]
  }
}
]]
  local file = io.open('biome.json', 'w')
  if file then
    file:write(biome_config)
    file:close()
    print 'Created biome.json with HTML support'
  else
    print 'Failed to create biome.json'
  end
end, {})
vim.keymap.set('n', '<leader>bb', ':BiomeInit<CR>', { noremap = true, silent = true, desc = 'Create biome.json' })
-- Zig specific keymaps
vim.keymap.set('n', '<leader>zb', ':!zig build<CR>')
vim.keymap.set('n', '<leader>zr', ':!zig build run<CR>')
vim.keymap.set('n', '<leader>zt', ':!zig test<CR>')
vim.keymap.set('n', '<leader>zf', ':!zig fmt %<CR>')

-- C++ commands
-- C++ compilation and execution
--
vim.keymap.set('n', '<Leader>rc', function()
  local filename = vim.fn.expand '%:p'
  local output = vim.fn.expand '%:p:r'
  local cmd = string.format('!g++ -Wall -Wextra -pedantic -std=c++17 "%s" -o "%s"', filename, output)
  vim.cmd(cmd)
end, { desc = 'Compile C++' })

vim.keymap.set('n', '<Leader>rr', function()
  local output = vim.fn.expand '%:p:r'
  vim.cmd(string.format('!%s', output))
end, { desc = 'Run compiled program' })

-- Configuration table
local cpp_config = {
  compiler = 'g++',
  standard = 'c++17',
  output_prefix = vim.fn.expand '%:p:h',
  default_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), -- Uses current directory name
  flags = {
    '-Wall',
    '-Wextra',
    '-O2',
  },
}

-- Function to ensure build directory exists
local function ensure_build_dir()
  local dir = cpp_config.output_prefix
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
  return dir
end
-- Compile project (all cpp files in directory)
vim.keymap.set('n', '<Leader>rp', function()
  local project_dir = vim.fn.expand '%:p:h'
  local output = ensure_build_dir() .. '/' .. cpp_config.default_name

  -- Construct flags string
  local flags_str = table.concat(cpp_config.flags, ' ')

  local cmd = string.format('!%s -std=%s %s %s/*.cpp -o "%s"', cpp_config.compiler, cpp_config.standard, flags_str, project_dir, output)

  vim.cmd(cmd)
end, { desc = 'Compile C++ Project' })
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Open diagnostic float' })
-- LazyGit
vim.keymap.set('n', '<Leader>gg', '<cmd>LazyGit<CR>', { desc = 'Open LazyGit' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Cmake Keybinds
vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>', { desc = 'Generate cmake files' })
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { desc = 'Build cmake target' })
vim.keymap.set('n', '<leader>cmr', ':CMakeRun<CR>', { desc = 'Run cmake target' })
vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>', { desc = 'Debug cmake target' })
--
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--Bufferline
-- Keymaps for bufferline navigation
vim.keymap.set('n', '<Tab>', ':BufferNext<CR>', { silent = true, desc = 'Next Buffer' })
vim.keymap.set('n', '<S-Tab>', ':BufferPrevious<CR>', { silent = true, desc = 'Previous Buffer' })
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { silent = true, desc = 'Pick Buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true, desc = 'Close Buffer' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.asm', '*.nasm' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8

    vim.opt_local.number = true
    vim.opt_local.relativenumber = true

    -- Highlight current line
    vim.opt_local.cursorline = true

    -- Enable folding based on indentation
    vim.opt_local.foldmethod = 'indent'
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local border = 'rounded'
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#3b4261' }) -- Adjust color as needed

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
  max_width = 80,
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

--
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        load = 'lazy',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },

    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end
      vim.diagnostic.config {
        virtual_text = {
          virt_text_pos = 'eol',
        },
      }
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.offsetEncoding = { 'utf-16' }
      local util = require 'lspconfig/util'

      local ls = require 'luasnip'
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets('solidity', {
        s('contract', {
          t '// SPDX-License-Identifier: MIT',
          t { '', 'pragma solidity ^0.8.20;', '', 'contract ' },
          i(1, 'Name'),
          t ' {',
          t { '', '\t' },
          i(0),
          t { '', '}' },
        }),

        s('func', {
          t 'function ',
          i(1, 'name'),
          t '(',
          i(2),
          t ') ',
          i(3, 'public'),
          t ' ',
          i(4),
          t ' {',
          t { '', '\t' },
          i(0),
          t { '', '}' },
        }),

        s('event', {
          t 'event ',
          i(1, 'Name'),
          t '(',
          i(2),
          t ');',
          i(0),
        }),

        s('error', {
          t 'error ',
          i(1, 'Name'),
          t '(',
          i(2),
          t ');',
          i(0),
        }),

        s('struct', {
          t 'struct ',
          i(1, 'Name'),
          t ' {',
          t { '', '\t' },
          i(0),
          t { '', '}' },
        }),

        s('imp', {
          t 'import "',
          i(1, './Contract.sol'),
          t '";',
          i(0),
        }),

        s('req', {
          t 'require(',
          i(1, 'condition'),
          t ', "',
          i(2, 'error message'),
          t '");',
          i(0),
        }),

        s('constructor', {
          t 'constructor(',
          i(1),
          t ') ',
          i(2),
          t ' {',
          t { '', '\t' },
          i(0),
          t { '', '}' },
        }),

        s('mapping', {
          t 'mapping(',
          i(1, 'key'),
          t ' => ',
          i(2, 'value'),
          t ') ',
          i(3, 'public'),
          t ' ',
          i(4, 'variableName'),
          t ';',
          i(0),
        }),
      })
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--header-insertion=iwyu',
            '--header-insertion-decorators',
            '--offset-encoding=utf-16',
            '--enable-config',
            '--pch-storage=memory', -- Faster PCH storage
            '--cross-file-rename', -- Enable cross-file renaming
            '--suggest-missing-includes', -- Suggest missing includes
            '--all-scopes-completion', -- Complete symbols from all scopes
            '--function-arg-placeholders', -- Show function argument placeholders
            '--fallback-style=LLVM', -- Fallback formatting style
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
            fallbackFlags = { '-std=c++17' }, -- Default C++ standard
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
          root_dir = require('lspconfig').util.root_pattern(
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac',
            'CMakeLists.txt',
            '.git'
          ),
          single_file_support = true,
          settings = {
            clangd = {
              semanticHighlighting = true,
              inlayHints = {
                parameterNames = {
                  enabled = true,
                  suppressWhenArgumentMatchesName = false,
                },
                deducedTypes = {
                  enabled = true,
                },
                designatedInitializers = true,
                blockEnd = true,
              },
              completion = {
                allScopes = true,
              },
              hover = {
                showAKA = true,
              },
            },
          },
          commands = {
            ClangdSwitchSourceHeader = {
              function()
                vim.lsp.buf.execute_command {
                  command = 'clangd.switchheader',
                }
              end,
              description = 'Switch between source and header file',
            },
          },
        },

        cmake = {
          filetypes = { 'cmake' },
          highlight = true,
          init_options = {
            buildDirectory = 'build',
          },
          settings = {
            cmake = {
              configureOnOpen = true,
            },
          },
        },
        pyright = {
          cmd = { 'pyright-langserver', '--stdio' },
          filetypes = { 'python' },
          root_dir = util.root_pattern('.git', 'pyproject.toml', 'setup.py', 'requirements.txt', '.venv', 'venv'),
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
                typeCheckingMode = 'basic',
                extraPaths = {},
              },
              pythonPath = '', -- This will use the default Python path
            },
          },
          on_init = function(client)
            -- Dynamically determine Python path when the LSP initializes
            local function get_python_path()
              local poetry_path = vim.fn.trim(vim.fn.system 'poetry env info --path 2>/dev/null')
              if poetry_path ~= '' and vim.v.shell_error == 0 then
                return poetry_path .. '/bin/python'
              end

              local venv_paths = {
                vim.fn.getcwd() .. '/.venv',
                vim.fn.getcwd() .. '/venv',
                vim.fn.getcwd() .. '/env',
              }

              for _, path in ipairs(venv_paths) do
                if vim.fn.isdirectory(path) == 1 then
                  return path .. '/bin/python'
                end
              end

              return vim.fn.exepath 'python'
            end

            client.config.settings.python.pythonPath = get_python_path()
            client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
          end,
          single_file_support = true,
        },
        biome = {
          cmd = { 'biome', 'lsp-proxy' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'html' },
          root_dir = require('lspconfig').util.root_pattern('biome.json', 'biome.jsonc'),
          single_file_support = true,
        },
        ts_ls = {
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
          root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
          init_options = {
            preferences = {
              disableSuggestions = false,
            },
          },
        },
        gopls = {
          cmd = { 'gopls' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              semanticTokens = true,
            },
          },
        },
        rust_analyzer = {
          capabilities = capabilities,
          auto_attach = true,
          settings = {
            inlayHints = {
              enable = true,
              typeHints = true,
              parameterHints = true,
              chainingHints = true,
            },
            checkOnSave = {
              command = 'clippy',
              extraArgs = { '--all', '---all-features' },
              allTargets = false,
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
              attributes = {
                enable = true,
              },
            },
            experimental = {
              procAttrMacros = false,
            },
            completion = {
              addCallArgumentSnippets = true,
              addCallParenthesis = true,
              postfix = {
                enable = true,
              },
            },
          },
        },
        html = {
          filetypes = { 'html', 'blade', 'php', 'htmldjango' },
          capabilities = capabilities,
          init_options = {
            configurationSection = { 'html', 'css' },
            embeddedLanguages = {
              css = true,
              -- javascript = true,
              -- typescript = true,
            },
            provideFormatter = true,
          },
        },
        emmet_ls = {
          capabilities = capabilities,
          filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }
      vim.keymap.set('n', '<space>f', vim.lsp.buf.format)

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        javascriptreact = { 'biome' },
        typescriptreact = { 'biome' },
        -- Conform can also run multiple formatters sequentially
        blade = { 'blade-formatter' },
        python = { 'black' },
        cpp = { 'clang-format' },
        c = { 'clang-format' },
        cmake = { 'cmake_format' },
        asm = { 'asmfmt' },
        go = { 'gofmt' },
      },
      formatters = {
        ['clang-format'] = {
          prepend_args = {
            '--style=file', -- Use .clang-format file if available
            '--fallback-style=LLVM',
          },
        },
      },
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  { 'folke/todo-comments.nvim', event = { 'BufReadPost', 'BufNewFile' }, dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { 'TovarishFin/vim-solidity', ft = 'solidity' },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = {
      'TSInstall',
      'TSBufEnable',
      'TSBufDisable',
      'TSBufToggle',
      'TSModuleInfo',
    },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'cmake',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'javascript',
        'tsx',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- Load Solidity configuration
require('solidity_setup').setup()

-- Add explicit file type detection
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.sol',
  command = 'set filetype=solidity',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.bo.autoindent = true
  end,
})

vim.api.nvim_create_user_command('TsConfig', function()
  local tsconfig = [[
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "dist",
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
]]
  local file = io.open('tsconfig.json', 'w')
  if file then
    file:write(tsconfig)
    file:close()
    print 'Created tsconfig.json'
  else
    print 'Failed to create tsconfig.json'
  end
end, {})

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.blade = {
  install_info = {
    url = 'https://github.com/EmranMR/tree-sitter-blade',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'blade',
}

-- Configure Blade filetype recognition
vim.filetype.add {
  pattern = {
    ['.*%.blade%.php'] = 'blade',
  },
}
-- HTML specific indentation settings (works for Blade too since it's HTML-based)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'blade', 'js', 'jsx', 'tsx', 'ts' },
  callback = function()
    vim.bo.tabstop = 2 -- Width of tab character
    vim.bo.softtabstop = 2 -- Fine tunes amount of whitespace
    vim.bo.shiftwidth = 2 -- Number of spaces for each indentation
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.autoindent = true -- Copy indent from current line when starting a new line
  end,
})
vim.api.nvim_create_user_command('ClangFormat', function()
  local clang_format_config = [[
---
Language: Cpp
BasedOnStyle: LLVM
IndentWidth: 2
TabWidth: 2
UseTab: Never
ColumnLimit: 100
BreakBeforeBraces: Attach
AllowShortIfStatementsOnASingleLine: WithoutElse
AllowShortLoopsOnASingleLine: true
AllowShortFunctionsOnASingleLine: Empty
IndentCaseLabels: true
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpaceAfterCStyleCast: false
SpaceBeforeAssignmentOperators: true
KeepEmptyLinesAtTheStartOfBlocks: false
MaxEmptyLinesToKeep: 1
AccessModifierOffset: -2
NamespaceIndentation: None
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
BinPackArguments: false
BinPackParameters: false
AllowAllArgumentsOnNextLine: false
AllowAllParametersOfDeclarationOnNextLine: false
PackConstructorInitializers: Never
AlignConsecutiveDeclarations: Consecutive
AlignConsecutiveAssignments: Consecutive
AlignConsecutiveMacros: Consecutive
ColumnLimit: 80
]]

  local file = io.open('.clang-format', 'w')
  if file then
    file:write(clang_format_config)
    file:close()
    print 'Created .clang-format configuration'
  else
    print 'Failed to create .clang-format'
  end
end, {})
