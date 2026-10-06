-- Remembers the file buffers open when Neovim exits, so the dashboard can reopen them
-- and cd into the project of the buffer that was focused last.
local M = {}

local session_file = vim.fn.stdpath 'state' .. '/last_session.json'
local root_markers = { '.git', 'Cargo.toml', 'CMakeLists.txt', 'go.mod', 'package.json', 'dune-project', 'Makefile' }

local function is_file_buffer(buf)
  return vim.bo[buf].buflisted and vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= ''
end

local function save()
  local current = vim.api.nvim_get_current_buf()
  local files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_file_buffer(buf) then
      local pos = buf == current and vim.api.nvim_win_get_cursor(0) or vim.api.nvim_buf_get_mark(buf, '"')
      table.insert(files, { path = vim.api.nvim_buf_get_name(buf), line = pos[1], col = pos[2] })
    end
  end
  -- Keep the previous session when quitting from an empty Neovim (e.g. straight from the dashboard)
  if #files == 0 then
    return
  end

  local current_path = is_file_buffer(current) and vim.api.nvim_buf_get_name(current) or files[#files].path
  local cwd = vim.fs.root(current_path, root_markers) or vim.fs.dirname(current_path)

  vim.fn.writefile({ vim.json.encode { files = files, current = current_path, cwd = cwd } }, session_file)
end

function M.load()
  if vim.fn.filereadable(session_file) == 0 then
    vim.notify('No saved session yet', vim.log.levels.WARN)
    return
  end
  local ok, session = pcall(vim.json.decode, table.concat(vim.fn.readfile(session_file), '\n'))
  if not ok or type(session) ~= 'table' or not session.files then
    vim.notify('Saved session is unreadable', vim.log.levels.ERROR)
    return
  end

  if session.cwd and vim.fn.isdirectory(session.cwd) == 1 then
    vim.fn.chdir(session.cwd)
  end

  local current_entry
  for _, file in ipairs(session.files) do
    if vim.fn.filereadable(file.path) == 1 then
      vim.cmd.badd(vim.fn.fnameescape(file.path))
      if file.path == session.current then
        current_entry = file
      end
    end
  end

  current_entry = current_entry or session.files[#session.files]
  if current_entry and vim.fn.filereadable(current_entry.path) == 1 then
    vim.cmd.edit(vim.fn.fnameescape(current_entry.path))
    pcall(vim.api.nvim_win_set_cursor, 0, { current_entry.line, current_entry.col })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('VimLeavePre', {
    desc = 'Save open buffers for the dashboard restore key',
    group = vim.api.nvim_create_augroup('last-session', { clear = true }),
    callback = save,
  })
  vim.api.nvim_create_user_command('SessionRestore', M.load, { desc = 'Reopen buffers from the last Neovim session' })
end

return M
