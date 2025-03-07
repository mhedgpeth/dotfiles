return {
  "Canop/nvim-bacon",
  keys = {
    { "<leader>cn", ":BaconLoad<CR>:w<CR>:BaconNext<CR>", desc = "Navigate to next bacon location" },
    { "<leader>co", ":BaconList<CR>", desc = "Open bacon locations list" },
  },
  config = function()
    require("bacon").setup({
      quickfix = {
        enabled = true,
        event_trigger = true,
      },
    })
  end,
}
