return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      vim.keymap.set("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end,
        { desc = 'Comment line' })
      vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        { desc = 'Comment selection' })
    end
  }
}
