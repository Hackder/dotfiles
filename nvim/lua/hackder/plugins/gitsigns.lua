return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          vim.keymap.set('n', '<leader>gb', function() gs.blame_line { full = true } end, { desc = 'Git blame line' })

          vim.keymap.set('n', '<leader>ghs', function() gs.stage_hunk() end, { desc = 'Git stage hunk' })
          vim.keymap.set('v', '<leader>ghs', function() gs.stage_hunk() end, { desc = 'Git stage hunk' })
          vim.keymap.set('n', '<leader>ghr', function() gs.reset_hunk() end, { desc = 'Git reset hunk' })
          vim.keymap.set('v', '<leader>ghr', function() gs.reset_hunk() end, { desc = 'Git reset hunk' })

          vim.keymap.set('n', '<leader>ghu', function() gs.undo_stage_hunk() end, { desc = 'Git undo stage hunk' })

          vim.keymap.set('n', '<leader>ghp', function() gs.preview_hunk() end, { desc = 'Git preview hunk' })
        end
      })
    end
  }
}
