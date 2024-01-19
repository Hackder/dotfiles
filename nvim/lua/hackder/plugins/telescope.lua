-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

local find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--no-ignore", "-E", ".git", "-E", "node_modules", "-E", ".next", "-E", "\\.turbo" }

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({})

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', function()
      local cwd = vim.fn.getcwd()
      if is_inside_work_tree[cwd] == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
      end

      if is_inside_work_tree[cwd] then
        builtin.git_files({ show_untracked = true })
      else
        builtin.find_files({
          find_command = find_command,
        })
      end
    end, { desc = 'Search git files' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<leader>fa', function()
      builtin.find_files({
        find_command = find_command
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
