local M = {}

-- Create a global table for our terminal functions
_G.terminal_utils = {}

-- Variable to store the terminal buffer ID
local terminal_state = {
  buf_id = nil,
}

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

function M.setup()
  -- terminal keymaps
  vim.api.nvim_create_user_command('Term', create_term, {})
  vim.api.nvim_create_user_command('TermClose', _G.terminal_utils.close_term, {})

  vim.keymap.set('n', '<Leader>tt', ':Term<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<Leader>x', ':TermClose<CR>', { noremap = true, silent = true })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
end

return M
