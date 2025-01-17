return {
  {
    'Civitasv/cmake-tools.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {
      cmake_command = 'cmake', -- CMake executable
      cmake_build_directory = 'build', -- Default build directory
      cmake_generate_options = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' }, -- Generate compile_commands.json
      cmake_executable_prefix = '', -- Remove any prefix
      cmake_build_options = {}, -- Additional build options
      cmake_console_size = 10, -- CMake console size
      cmake_console_position = 'belowright', -- CMake console position
      cmake_show_console = 'always', -- "always", "only_on_error"
      cmake_dap_configuration = { -- DAP configuration
        name = 'cpp',
        type = 'codelldb',
        request = 'launch',
      },
      cmake_variants_message = {
        short = { show = true },
        long = { show = true, max_length = 40 },
      },
    },
  },
}
