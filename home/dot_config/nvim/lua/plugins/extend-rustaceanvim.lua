return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Until some bugs are figured out
  lazy = false,
  ---@type RustaceanOpts
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          procMacro = {
            ignored = {
              leptos_macro = {
                "server",
              },
            },
          },
          cargo = {
            features = "all",
          },
        },
      },
    },
  },
}
