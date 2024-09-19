-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

local find_command = {
	"fd",
	"--type",
	"f",
	"--strip-cwd-prefix",
	"--hidden",
	"--no-ignore",
	"-E",
	"**/\\.git",
	"-E",
	"**/node_modules",
	"-E",
	"**/\\.next",
	"-E",
	"\\.turbo",
}

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({})
		local pickers = require("hackder.telescope-pickers")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-p>", function()
			local cwd = vim.fn.getcwd()
			if is_inside_work_tree[cwd] == nil then
				vim.fn.system("git rev-parse --is-inside-work-tree")
				is_inside_work_tree[cwd] = vim.v.shell_error == 0
			end

			if is_inside_work_tree[cwd] then
				pickers.prettyFilesPicker({
					picker = "git_files",
					options = { show_untracked = true },
				})
			else
				pickers.prettyFilesPicker({ picker = "find_files", options = { find_command = find_command } })
			end
		end, { desc = "Search git files" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search diagnostics" })
		vim.keymap.set("n", "<leader>fa", function()
			pickers.prettyFilesPicker({
				picker = "find_files",
				options = {
					find_command = find_command,
				},
			})
		end, { desc = "Search all files" })
		vim.keymap.set("n", "<leader>fg", function()
			pickers.prettyGrepPicker({ picker = "live_grep" })
		end, { desc = "Search all files" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep string in current file" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search buffers" })
		vim.keymap.set("n", "<leader>fW", function()
			require("telescope.builtin").live_grep({
				additional_args = function(args)
					return vim.list_extend(args, { "--hidden", "--glob", "!\\.git", "--glob", "!node_modules" })
				end,
			})
		end, {
			desc = "Grep string in all files (including hidden)",
		})

		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Search document symbols" })
		vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Search workspace symbols" })

		vim.keymap.set("n", "<leader>gB", builtin.git_branches, { desc = "Search git branches" })
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search git commits" })
	end,
}
