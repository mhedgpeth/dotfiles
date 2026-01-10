-- see https://codecompanion.olimorris.dev/
return {
  "olimorris/codecompanion.nvim",
  version = "^18.0.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Toggle [C]hat" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI [N]ew Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI [A]ction" },
    { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "AI [A]dd to Chat" },
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI [E]xplain" },
  },
  opts = {
    adapters = {
      anthropic = {
        schema = {
          model = { default = "claude-sonnet-4-5-20250929" },
        },
      },
    },
    interactions = {
      chat = { adapter = "anthropic" },
      inline = { adapter = "anthropic" },
    },
    prompt_library = {
      ["Diagnose errors"] = {
        strategy = "workflow",
        description = "Explain LSP diagnostics with source code context",
        opts = {
          index = 1,
          is_default = true,
          short_name = "lspx",
        },
        prompts = {
          {
            {
              role = "system",
              content = function(context)
                return string.format(
                  [[You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages. When appropriate, give solutions with code snippets as fenced codeblocks with a language identifier to enable syntax highlighting.

The programming language is %s.]],
                  context.filetype
                )
              end,
              opts = { visible = false },
            },
            {
              role = "user",
              content = [[Please explain the following LSP diagnostics and suggest fixes:

#{lsp}]],
              opts = { auto_submit = true },
            },
          },
        },
      },
    },
  },
}
