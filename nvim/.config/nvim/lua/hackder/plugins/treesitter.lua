return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").install({
				"javascript",
				"typescript",
				"python",
				"cpp",
				"lua",
				"rust",
				"query",
				"html",
			})

			-- Enable treesitter highlighting for all buffers
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or not vim.treesitter.language.add(lang) then
						return
					end

					if vim.treesitter.query.get(lang, "highlights") then
						vim.treesitter.start(args.buf)
					end

					if vim.treesitter.query.get(lang, "indents") then
						vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
			})

			-- keymaps
			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)
			-- You can also use captures from other query groups like `locals.scm`
			vim.keymap.set({ "x", "o" }, "as", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
			end)
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	branch = "master",
	-- 	config = function()
	-- 		require("treesitter-context").setup({
	-- 			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	-- 			multiwindow = false, -- Enable multiwindow support.
	-- 			max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
	-- 			min_window_height = 30, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	-- 			line_numbers = true,
	-- 			multiline_threshold = 1, -- Maximum number of lines to show for a single context
	-- 			trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	-- 			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- 			-- Separator between context and content. Should be a single character string, like '-'.
	-- 			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	-- 			separator = nil,
	-- 			zindex = 20, -- The Z-index of the context window
	-- 			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	-- 		})
	-- 	end,
	-- },
}
