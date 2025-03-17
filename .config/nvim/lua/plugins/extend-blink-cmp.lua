return {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
  enabled = function()
    return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
      and vim.bo.buftype ~= "prompt"
      and vim.b.completion ~= false
  end,
  opts = {
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
