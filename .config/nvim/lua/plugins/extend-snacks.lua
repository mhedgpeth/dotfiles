return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
       ██████╗ ███████╗ ██████╗ ██████╗ ██╗     ███████╗      
       ██╔══██╗██╔════╝██╔═══██╗██╔══██╗██║     ██╔════╝      
       ██████╔╝█████╗  ██║   ██║██████╔╝██║     █████╗        
       ██╔═══╝ ██╔══╝  ██║   ██║██╔═══╝ ██║     ██╔══╝        
       ██║     ███████╗╚██████╔╝██║     ███████╗███████╗      
       ╚═╝     ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚══════╝ work 
]],
      },
    },
    picker = {
      previewers = {
        diff = {
          builtin = false,
          cmd = { "delta" },
        },
        git = {
          builtin = false, -- use delta
          args = {},
        },
      },
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
