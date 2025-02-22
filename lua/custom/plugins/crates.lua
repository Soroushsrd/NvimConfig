return {
  'saecki/crates.nvim',
  ft = { 'toml' },
  config = function()
    require('crates').setup {
      curl_args = { '-sL', '--retry', '3', '--retry-delay', '1', '--connect-timeout', '5' },
      max_parallel_requests = 20, -- Lower this to reduce connection load
      loading_indicator = true,
      autoupdate_throttle = 1000, -- Increase throttle to reduce network requests
      completion = {
        cmp = {
          enabled = true,
        },
      },
    }
    require('cmp').setup.buffer {
      sources = { { name = 'crates' } },
    }
  end,
}
