---@diagnostic disable: missing-fields
-- Run with: nvim --clean -u ~/.config/nvim-debug/minimal.lua
-- Or from this directory: nvim --clean -u minimal.lua

-- ============================================================================
-- BASIC VIM SETTINGS (make it usable)
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Copilot token path
vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

-- ============================================================================
-- PLUGINS
-- ============================================================================
local plugins = {
	-- LSP for testing diagnostics (lua_ls)
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},

	-- CodeCompanion
	{
		"olimorris/codecompanion.nvim",
		version = "^18.0.0",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-treesitter/nvim-treesitter",
				lazy = false,
				build = ":TSUpdate",
			},
			{
				"saghen/blink.cmp",
				lazy = false,
				version = "*",
				opts = {
					keymap = {
						preset = "enter",
						["<S-Tab>"] = { "select_prev", "fallback" },
						["<Tab>"] = { "select_next", "fallback" },
					},
					cmdline = { sources = { "cmdline" } },
					sources = {
						default = { "lsp", "path", "buffer", "codecompanion" },
					},
				},
			},
		},
		opts = {
			strategies = {
				chat = { adapter = "anthropic" },
				inline = { adapter = "anthropic" },
			},
			opts = {
				log_level = "DEBUG",
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
			{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Chat" },
			{ "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline" },
		},
	},
}

require("lazy.minit").repro({ spec = plugins })

-- ============================================================================
-- SETUP TREE-SITTER PARSERS (runs after plugins load)
-- ============================================================================
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		local ok, ts = pcall(require, "nvim-treesitter")
		if ok then
			ts.install({ "lua", "markdown", "markdown_inline" }, { summary = true }):wait(60000)
		end
	end,
})
