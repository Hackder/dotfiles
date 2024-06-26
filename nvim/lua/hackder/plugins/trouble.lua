return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Toggle trouble" })
    vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end,
      { desc = "Toggle trouble" })
    vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, { desc = "Toggle trouble" })
    vim.keymap.set("n", "<leader>gR", function() require("trouble").toggle("lsp_references") end,
      { desc = "Toggle trouble" })
    vim.keymap.set("n", "[d", function()
      require("trouble").next({ skip_groups = true, jump = true })
    end)
    vim.keymap.set("n", "]d", function()
      require("trouble").previous({ skip_groups = true, jump = true })
    end)
  end
}
