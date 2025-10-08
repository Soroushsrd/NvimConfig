local M = {}
function M.setup()
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

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

  vim.keymap.set('n', '<leader>ct', ':TsConfig<CR>', { noremap = true, silent = true, desc = 'Create tsconfig.json' })

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
end

return M
