-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "snacks"

-- enable overdrive scripts to be defined at the project level
vim.o.exrc = true
vim.o.secure = true

-- turn on bacon, instructions: https://dystroy.org/bacon/community/bacon-ls/#neovim-lazyvim
-- vim.g.lazyvim_rust_diagnostics = "bacon-ls"
