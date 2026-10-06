return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    picker = { enabled = true },
    notifier = { enabled = true },
    dashboard = {
      width = 60,
      preset = {
        keys = {
          { icon = '  ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = '  ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = '  ', key = 'c', desc = 'Config', action = ':e $MYVIMRC' },
          { icon = '  ', key = 's', desc = 'Restore Last Session', action = ':SessionRestore' },
          { icon = '  ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = '  ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = [[
          ██████╗ ███████╗██╗    ██╗██████╗ ██╗████████╗███████╗    ██╗████████╗
          ██╔══██╗██╔════╝██║    ██║██╔══██╗██║╚══██╔══╝██╔════╝    ██║╚══██╔══╝
          ██████╔╝█████╗  ██║ █╗ ██║██████╔╝██║   ██║   █████╗      ██║   ██║   
          ██╔══██╗██╔══╝  ██║███╗██║██╔══██╗██║   ██║   ██╔══╝      ██║   ██║   
          ██║  ██║███████╗╚███╔███╔╝██║  ██║██║   ██║   ███████╗    ██║   ██║   
          ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝    ╚═╝   ╚═╝   
                                                                                 
                            ██╗███╗   ██╗    ██████╗ ██╗   ██╗███████╗████████╗ 
                            ██║████╗  ██║    ██╔══██╗██║   ██║██╔════╝╚══██╔══╝ 
                            ██║██╔██╗ ██║    ██████╔╝██║   ██║███████╗   ██║    
                            ██║██║╚██╗██║    ██╔══██╗██║   ██║╚════██║   ██║    
                            ██║██║ ╚████║    ██║  ██║╚██████╔╝███████║   ██║    
                            ╚═╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝    
                            ]],
      },
    },
  },
}
