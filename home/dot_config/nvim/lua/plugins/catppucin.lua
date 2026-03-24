return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      -- Catppuccin comes in four flavors: mocha (dark), macchiato (darker), frappe (light-dark), and latte (light)
      flavour = "mocha",
      integrations = {
        treesitter = true,
        semantic_tokens = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
        functions = {},
        variables = {},
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "catppuccin/nvim" },
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "catppuccin-mocha"

      -- Show repo-wide file counts in statusline so we can track progress
      -- toward a clean working tree (like VS Code's source control badge).
      -- +N = staged files ready to commit, ~N = unstaged modified files.
      -- Cached and refreshed on save/focus to avoid shelling out on every render.
      local git_file_status = ""
      local function refresh_git_file_status()
        local lines = vim.fn.systemlist("git status --porcelain 2>/dev/null")
        local staged, unstaged = 0, 0
        for _, line in ipairs(lines) do
          if line:sub(1, 1):match("[MADRC]") then staged = staged + 1 end
          if line:sub(2, 2):match("[MADRC?]") then unstaged = unstaged + 1 end
        end
        local parts = {}
        if staged > 0 then parts[#parts + 1] = "+" .. staged end
        if unstaged > 0 then parts[#parts + 1] = "~" .. unstaged end
        git_file_status = table.concat(parts, " ")
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "VimEnter" }, {
        callback = refresh_git_file_status,
      })

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, {
        function() return git_file_status end,
        cond = function() return git_file_status ~= "" end,
      })
    end,
  },
}
