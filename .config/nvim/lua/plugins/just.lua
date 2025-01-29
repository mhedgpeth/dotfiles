return {
  -- language support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "just" })
      end
    end,
  },
  -- associate file types
  {
    "LazyVim/LazyVim",
    opts = {
      autocmds = {
        {
          "BufRead,BufNewFile",
          { "Justfile", "justfile" },
          function()
            vim.cmd("set filetype=just")
          end,
        },
      },
    },
  },
  -- Syntax highlighting
  {
    "NoahTheDuke/vim-just",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "just" },
  },
  -- formatting support
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        just = { "just" },
      },
    },
  },
}
