-- debug.lua
return {
  'mfussenegger/nvim-dap',
  -- Only load debug functionality when pressing F5 or other debug keys
  keys = {
    { '<F5>', desc = 'Debug: Start/Continue' },
    { '<F1>', desc = 'Debug: Step Into' },
    { '<F2>', desc = 'Debug: Step Over' },
    { '<F3>', desc = 'Debug: Step Out' },
    { '<leader>b', desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', desc = 'Debug: Set Breakpoint' },
    { '<F7>', desc = 'Debug: Toggle UI' },
  },
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      -- lazy load when dap is actually used
      lazy = true,
    },
    'nvim-neotest/nvim-nio',
    {
      'williamboman/mason.nvim',
      lazy = true,
    },
    {
      'jay-babu/mason-nvim-dap.nvim',
      lazy = true,
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Setup keymaps only after dap is loaded
    vim.keymap.set('n', '<F5>', function()
      dap.continue()
    end)
    vim.keymap.set('n', '<F1>', function()
      dap.step_into()
    end)
    vim.keymap.set('n', '<F2>', function()
      dap.step_over()
    end)
    vim.keymap.set('n', '<F3>', function()
      dap.step_out()
    end)
    vim.keymap.set('n', '<leader>b', function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)
    vim.keymap.set('n', '<F7>', function()
      dapui.toggle()
    end)

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'codelldb', -- For both Rust and C++
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Adapters setup
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Rust configuration
    dap.configurations.rust = {
      {
        name = 'Launch Rust',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local metadata_command = 'cargo metadata --format-version 1 --no-deps'
          local handle = io.popen(metadata_command)
          local result = handle:read '*a'
          handle:close()

          local metadata = vim.fn.json_decode(result)
          local target_dir = metadata.target_directory
          local binary_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

          return target_dir .. '/debug/' .. binary_name
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- C++ configuration
    dap.configurations.cpp = {
      {
        name = 'Launch C++',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Auto UI handling
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
