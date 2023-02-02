require('telescope').setup {
  defaults = {
    file_ignore_patters = { ".git", "node_modules" }
  },
  pickers = {
    find_files = { hidden = true, },
    git_files = { show_untracked = true }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fW', function()
  require('telescope.builtin').live_grep {
    additional_args = function(args) return vim.list_extend(args, { "--hidden" }) end,
  }
end, {})

vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, {})
