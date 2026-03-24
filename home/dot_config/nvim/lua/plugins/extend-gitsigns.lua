return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "]h",
      "<cmd>Gitsigns next_hunk<cr>",
      desc = "Next Hunk",
    },
    {
      "[h",
      "<cmd>Gitsigns prev_hunk<cr>",
      desc = "Prev Hunk",
    },
    {
      "<leader>hb",
      "<cmd>Gitsigns blame_line<cr>",
      desc = "Blame Line",
    },
    {
      "<leader>hs",
      "<cmd>Gitsigns stage_hunk<cr>",
      desc = "Stage Hunk",
    },
    {
      "<leader>hS",
      "<cmd>Gitsigns stage_buffer<cr>",
      desc = "Stage Buffer",
    },
    {
      "<leader>hr",
      "<cmd>Gitsigns reset_hunk<cr>",
      desc = "Reset Hunk",
    },
    {
      "<leader>hR",
      "<cmd>Gitsigns reset_buffer<cr>",
      desc = "Reset Buffer",
    },
    {
      "<leader>hu",
      "<cmd>Gitsigns undo_stage_hunk<cr>",
      desc = "Undo Stage Hunk",
    },
  },
}
