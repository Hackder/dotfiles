require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end)

    vim.keymap.set('n', '<leader>ghs', function() gs.stage_hunk() end)
    vim.keymap.set('v', '<leader>ghs', function() gs.stage_hunk() end)
    vim.keymap.set('n', '<leader>ghr', function() gs.reset_hunk() end)
    vim.keymap.set('v', '<leader>ghr', function() gs.reset_hunk() end)

    vim.keymap.set('n', '<leader>ghu', function() gs.undo_stage_hunk() end)

    vim.keymap.set('n', '<leader>ghp', function() gs.preview_hunk() end)
  end
}
