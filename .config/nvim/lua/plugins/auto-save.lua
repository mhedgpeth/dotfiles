return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  event = { "InsertLeave", "TextChanged" },
  keys = {
    { "<leader>bt", "<cmd>ASToggle<CR>", desc = "Toggle auto-save" },
  },
  opts = {
    -- Your auto-save config options here
  },
  -- The init function runs before the plugin is loaded
  init = function()
    -- Create the autocmd group for notifications
    local group = vim.api.nvim_create_augroup("autosave", {})

    -- Add notification for when files are saved
    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveWritePost",
      group = group,
      callback = function(opts)
        if opts.data and opts.data.saved_buffer ~= nil then
          local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
          vim.notify("AutoSave: saved " .. filename .. " at " .. vim.fn.strftime("%H:%M:%S"), vim.log.levels.INFO)
        end
      end,
    })

    -- Notifications for enable/disable events
    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveEnable",
      group = group,
      callback = function()
        vim.notify("AutoSave enabled", vim.log.levels.INFO)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveDisable",
      group = group,
      callback = function()
        vim.notify("AutoSave disabled", vim.log.levels.INFO)
      end,
    })
  end,
}
