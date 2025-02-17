return {
  "L3MON4D3/LuaSnip",
  config = function()
    require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets/" } })
  end,
  keys = {
    {
      "<C-k>",
      function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      mode = { "i", "s" },
      desc = "Expand or jump snippet",
    },
    {
      "<C-j>",
      function()
        local ls = require("luasnip")
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      mode = { "i", "s" },
      desc = "Jump back in snippet",
    },
    {
      "<C-e>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = { "i", "s" },
      desc = "Change choice in snippet",
    },
  },
}
