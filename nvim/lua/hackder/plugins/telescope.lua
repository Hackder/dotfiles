return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "^.git$", "node_modules", "/.next$" }
      },
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Search git files' })
    vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Search git files ' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>fa', function()
      builtin.find_files({
        find_command = { 'rg', '--files', '--hidden', '--ignore', '-u', '--iglob', '!.git' },
      })
    end, { desc = 'Search all files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search all files' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep string in current file' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Search buffers' })
    vim.keymap.set('n', '<leader>fW', function()
      require('telescope.builtin').live_grep {
        additional_args = function(args) return vim.list_extend(args, { "--hidden" }) end,
      }
    end, {
      desc = 'Grep string in all files (including hidden)'
    })

    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Search document symbols' })
    vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Search workspace symbols' })
  end
}
