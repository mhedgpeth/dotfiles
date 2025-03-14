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
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          score_offset = 1000,
        },
        snippets = {
          name = "blink.cmp.source.snippets",
          enabled = true,
          module = "blink.cmp.sources.snippets",
          score_offset = 950,
        },
      },
    },
  },
}
