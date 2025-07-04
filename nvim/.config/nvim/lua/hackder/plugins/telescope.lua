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
	"**/.venv",
	"-E",
	"\\.turbo",
	"-E",
	"**/target",
}

local git_command = {
	"fd",
	"--type",
	"f",
	"--strip-cwd-prefix",
	"--hidden",
	"-E",
	"**/\\.git",
}

return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim" } },
		config = function()
			local open_with_trouble = require("trouble.sources.telescope").open

			require("telescope").setup({
				defaults = {
					mappings = {
						i = { ["<c-t>"] = open_with_trouble },
						n = { ["<c-t>"] = open_with_trouble },
					},
				},
				extensions = {
					fzf = {},
				},
			})
			require("telescope").load_extension("fzf")

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
						picker = "find_files",
						options = {
							find_command = git_command,
						},
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
			vim.keymap.set(
				"n",
				"<leader>fw",
				builtin.current_buffer_fuzzy_find,
				{ desc = "Grep string in current file" }
			)
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
			vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Search treesitter" })

			local default_pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local conf = require("telescope.config").values
			local grep_in_project = function(opts)
				local finder = finders.new_async_job({
					command_generator = function(prompt)
						if not prompt or prompt == "" then
							return nil
						end

						local pieces = vim.split(prompt, "  ")
						local args = { "rg" }

						if pieces[1] then
							table.insert(args, "-e")
							table.insert(args, pieces[1])
						end

						vim.list_extend(args, {
							"--hidden",
							"--glob",
							"!\\.git",
							"--glob",
							"!node_modules",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
						})

						if pieces[2] then
							table.insert(args, "--glob")
							table.insert(args, pieces[2])
						end

						return args
					end,

					entry_maker = make_entry.gen_from_vimgrep(opts),
				})

				default_pickers
					.new({}, {
						debounce = 100,
						prompt_title = "Multi Grep",
						finder = finder,
						previewer = conf.grep_previewer({}),
						sorter = require("telescope.sorters").empty(),
					})
					:find()
			end

			vim.keymap.set("n", "<leader>fW", grep_in_project, {
				desc = "Grep string in all files (including hidden)",
			})

			vim.keymap.set("n", "<F4>", grep_in_project, {
				desc = "Grep string in all files (including hidden)",
			})

			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Search document symbols" })
			vim.keymap.set(
				"n",
				"<leader>fS",
				builtin.lsp_dynamic_workspace_symbols,
				{ desc = "Search workspace symbols" }
			)

			vim.keymap.set("n", "<leader>gB", builtin.git_branches, { desc = "Search git branches" })
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search git commits" })
		end,
	},
}
