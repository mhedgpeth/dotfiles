return {
  "L3MON4D3/LuaSnip",
  opts = function(_, opts)
    require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets/" } })
  end,
  -- key bindings are defined in blink.cmp, see https://cmp.saghen.dev/configuration/keymap.html#default
}
