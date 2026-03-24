-- Cross-file hunk navigation: when at the last/first hunk in a buffer,
-- jump to the next/previous modified file and land on its first/last hunk.
-- This lets ]h/[h walk through ALL unstaged changes across the repo.
local function nav_hunk_across_files(direction)
  local gs = require("gitsigns")
  local hunks = gs.get_hunks()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]

  -- Check if there's another hunk in this buffer in the given direction
  local has_more = false
  if hunks and #hunks > 0 then
    if direction == "next" then
      has_more = hunks[#hunks].added.start > cur_line
    else
      local first_start = hunks[1].added.start
      if first_start == 0 then first_start = 1 end
      has_more = first_start < cur_line
    end
  end

  if has_more then
    gs.nav_hunk(direction, { wrap = false })
    return
  end

  -- No more hunks in this buffer — find the next/prev modified file
  local files = vim.fn.systemlist("git diff --name-only 2>/dev/null")
  if #files == 0 then return end
  table.sort(files)
  local current = vim.fn.expand("%:.")
  local target

  if direction == "next" then
    local found = false
    for _, f in ipairs(files) do
      if found then target = f break end
      if f == current then found = true end
    end
    target = target or files[1] -- wrap to first
  else
    local prev
    for _, f in ipairs(files) do
      if f == current then target = prev break end
      prev = f
    end
    target = target or files[#files] -- wrap to last
  end

  vim.cmd("edit " .. vim.fn.fnameescape(target))
  vim.schedule(function()
    gs.nav_hunk(direction == "next" and "first" or "last")
  end)
end

return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "]h",
      function() nav_hunk_across_files("next") end,
      desc = "Next Hunk (across files)",
    },
    {
      "[h",
      function() nav_hunk_across_files("prev") end,
      desc = "Prev Hunk (across files)",
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
