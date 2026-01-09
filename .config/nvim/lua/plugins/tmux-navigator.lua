-- Seamless navigation between tmux panes and NeoVim splits
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
  },
}
