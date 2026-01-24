-- source: https://www.swift.org/documentation/articles/zero-to-swift-nvim.html
-- see also: https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim
-- but I am not quite ready for that yet.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
        omnisharp = {},
      },
    },
  },
}
