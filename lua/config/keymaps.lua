local M = {}
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

function M.setup()
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  -- cargo commands
  vim.keymap.set('n', '<Leader>cc', "<cmd>lua vim.cmd('Cargo clippy')<CR>", { desc = 'Cargo clippy' })
  vim.keymap.set('n', '<Leader>cr', "<cmd>lua vim.cmd('Cargo run')<CR>", { desc = 'Cargo run' })
  -- bash commands
  vim.keymap.set('n', '<Leader>hh', ':!chmod +x %<CR>', { silent = true, desc = 'Make bash executable' })
  vim.keymap.set('n', '<Leader>hr', ':!%<CR>', { silent = true, desc = 'Run bash executable' })
  -- Zig specific keymaps
  vim.keymap.set('n', '<leader>zb', ':!zig build<CR>')
  vim.keymap.set('n', '<leader>zr', ':!zig build run<CR>')
  vim.keymap.set('n', '<leader>zt', ':!zig test<CR>')
  vim.keymap.set('n', '<leader>zf', ':!zig fmt %<CR>')

  -- C++ commands
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
  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover { border = 'rounded' }
  end)

  -- LazyGit
  vim.keymap.set('n', '<Leader>gg', '<cmd>LazyGit<CR>', { desc = 'Open LazyGit' })

  -- Cmake Keybinds
  vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>', { desc = 'Generate cmake files' })
  vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { desc = 'Build cmake target' })
  vim.keymap.set('n', '<leader>cmr', ':CMakeRun<CR>', { desc = 'Run cmake target' })
  vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>', { desc = 'Debug cmake target' })
  --
  vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  --Bufferline
  -- Keymaps for bufferline navigation
  vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { silent = true, desc = 'Pick Buffer' })
  vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true, desc = 'Close Buffer' })

  -- snacks picker
  vim.keymap.set('n', '<leader>sh', function()
    Snacks.picker.help()
  end, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', function()
    Snacks.picker.keymaps()
  end, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', function()
    Snacks.picker.files()
  end, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', function()
    Snacks.picker.pickers()
  end, { desc = '[S]earch [S]elect Picker' })
  vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
    Snacks.picker.grep_word()
  end, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sd', function()
    Snacks.picker.diagnostics()
  end, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', function()
    Snacks.picker.resume()
  end, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', function()
    Snacks.picker.recent()
  end, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sN', function()
    Snacks.picker.notifications()
  end, { desc = '[S]earch [N]otification history' })
  vim.keymap.set('n', '<leader><leader>', function()
    Snacks.picker.buffers()
  end, { desc = '[ ] Find existing buffers' })

  vim.keymap.set('n', '<leader>/', function()
    Snacks.picker.grep()
  end, { desc = '[/] Grep project' })

  vim.keymap.set('n', '<leader>s/', function()
    Snacks.picker.grep_buffers()
  end, { desc = '[S]earch [/] in Open Files' })

  vim.keymap.set('n', '<leader>sn', function()
    Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })

  -- former fff bindings
  vim.keymap.set('n', '<leader>ff', function()
    Snacks.picker.files()
  end, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', function()
    Snacks.picker.grep()
  end, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fz', function()
    Snacks.picker.grep { regex = false }
  end, { desc = 'Live grep (literal)' })
  vim.keymap.set('n', '<leader>fc', function()
    Snacks.picker.grep_word()
  end, { desc = 'Search current word' })
end

return M
