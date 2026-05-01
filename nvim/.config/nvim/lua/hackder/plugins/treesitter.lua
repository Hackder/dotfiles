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
}
