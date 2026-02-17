local M = {}

local function ensure_dir(path)
  vim.fn.mkdir(path, 'p')
end

local function write_file(path, content)
  local file = io.open(path, 'w')
  if file then
    file:write(content)
    file:close()
    return true
  end
  return false
end

local function create_input_window(title, callback)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = 40
  local height = 1
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local border_buf = vim.api.nvim_create_buf(false, true)
  local border_opts = {
    style = 'minimal',
    relative = 'editor',
    width = width + 2,
    height = height + 2,
    row = row - 1,
    col = col - 1,
    border = 'rounded',
  }

  local border_win = vim.api.nvim_open_win(border_buf, false, border_opts)
  vim.api.nvim_buf_set_lines(border_buf, 0, 1, false, { ' ' .. title })

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = width + 2,
    height = height + 2,
    row = row - 1,
    col = col - 1,
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- vim.api.nvim_buf_set_option(buf, 'buftype', 'prompt')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal')
  vim.cmd 'startinsert'

  vim.keymap.set('i', '<CR>', function()
    local input = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] or ''
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(border_win, true)
    if input ~= '' then
      callback(input)
    end
  end, { buffer = buf })
  vim.keymap.set('i', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(border_win, true)
  end, { buffer = buf })

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(border_win, true)
  end, { buffer = buf })
end

-- Create new C++ project
function M.new_project()
  -- First, ask for project name
  create_input_window('Enter Project Name:', function(project_name)
    -- Then ask for path
    create_input_window('Enter Project Path (relative or absolute):', function(project_path)
      -- Expand path
      local full_path = vim.fn.expand(project_path)

      -- If path is relative, prepend current directory
      if not vim.startswith(full_path, '/') and not vim.startswith(full_path, '~') then
        full_path = vim.fn.getcwd() .. '/' .. full_path
      end
      full_path = vim.fn.expand(full_path)

      -- Create full project path
      local project_dir = full_path .. '/' .. project_name

      -- Check if directory already exists
      if vim.fn.isdirectory(project_dir) == 1 then
        vim.notify('Project directory already exists: ' .. project_dir, vim.log.levels.ERROR)
        return
      end

      -- Create project structure
      ensure_dir(project_dir)
      ensure_dir(project_dir .. '/cmake-build-debug')

      -- Create CMakeLists.txt
      local cmake_content = string.format(
        [[cmake_minimum_required(VERSION 3.16)
project(%s LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(%s main.cpp

)
include(GNUInstallDirs)
install(TARGETS %s
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
]],
        project_name,
        project_name,
        project_name
      )

      if not write_file(project_dir .. '/CMakeLists.txt', cmake_content) then
        vim.notify('Failed to create CMakeLists.txt', vim.log.levels.ERROR)
        return
      end

      -- Create main.cpp
      local main_content = [[#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
]]

      if not write_file(project_dir .. '/main.cpp', main_content) then
        vim.notify('Failed to create main.cpp', vim.log.levels.ERROR)
        return
      end

      -- Change to project directory and open main.cpp
      vim.cmd('cd ' .. vim.fn.fnameescape(project_dir))
      vim.cmd 'edit main.cpp'

      vim.notify('✓ Project created successfully: ' .. project_name, vim.log.levels.INFO)
    end)
  end)
end

-- Add a new C++ class
function M.add_class()
  -- Check if we're in a project with CMakeLists.txt
  if vim.fn.filereadable 'CMakeLists.txt' == 0 then
    vim.notify('No CMakeLists.txt found in current directory. Are you in a C++ project?', vim.log.levels.ERROR)
    return
  end

  create_input_window('Enter Class Name:', function(class_name)
    local header_file = class_name .. '.h'
    local cpp_file = class_name .. '.cpp'

    -- Check if files already exist
    if vim.fn.filereadable(header_file) == 1 or vim.fn.filereadable(cpp_file) == 1 then
      vim.notify('Class files already exist!', vim.log.levels.ERROR)
      return
    end

    -- Create header file
    local header_content = string.format(
      [[#ifndef %s_H
#define %s_H

class %s {
public:
    %s();
    ~%s();
    
private:
    
};

#endif // %s_H
]],
      string.upper(class_name),
      string.upper(class_name),
      class_name,
      class_name,
      class_name,
      string.upper(class_name)
    )

    if not write_file(header_file, header_content) then
      vim.notify('Failed to create header file', vim.log.levels.ERROR)
      return
    end

    -- Create cpp file
    local cpp_content = string.format(
      [[#include "%s"

%s::%s() {
    
}

%s::~%s() {
    
}
]],
      header_file,
      class_name,
      class_name,
      class_name,
      class_name
    )

    if not write_file(cpp_file, cpp_content) then
      vim.notify('Failed to create cpp file', vim.log.levels.ERROR)
      return
    end

    -- Update CMakeLists.txt
    local cmake_path = 'CMakeLists.txt'
    local file = io.open(cmake_path, 'r')
    if not file then
      vim.notify('Failed to read CMakeLists.txt', vim.log.levels.ERROR)
      return
    end

    local content = file:read '*all'
    file:close()

    -- Find the add_executable line and add the new files before the closing parenthesis
    local pattern = '(add_executable%([^%)]+main%.cpp)'
    local replacement = '%1\n    ' .. cpp_file
    content = content:gsub(pattern, replacement)

    file = io.open(cmake_path, 'w')
    if not file then
      vim.notify('Failed to write CMakeLists.txt', vim.log.levels.ERROR)
      return
    end
    file:write(content)
    file:close()

    -- Open the cpp file
    vim.cmd('edit ' .. cpp_file)

    vim.notify('✓ Class created: ' .. class_name .. ' (added to CMakeLists.txt)', vim.log.levels.INFO)
  end)
end

-- Setup function to be called from init.lua
function M.setup(opts)
  opts = opts or {}

  -- Create user commands
  vim.api.nvim_create_user_command('CppNewProject', M.new_project, {})
  vim.api.nvim_create_user_command('CppAddClass', M.add_class, {})

  -- Set up keybindings if provided
  if opts.keymaps then
    if opts.keymaps.new_project then
      vim.keymap.set('n', opts.keymaps.new_project, M.new_project, { desc = 'Create new C++ project', silent = true })
    end

    if opts.keymaps.add_class then
      vim.keymap.set('n', opts.keymaps.add_class, M.add_class, { desc = 'Add C++ class', silent = true })
    end
  end
end

return M
