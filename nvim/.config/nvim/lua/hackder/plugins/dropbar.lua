return {
	{
		"Bekaboo/dropbar.nvim",
		config = function()
			local sources = require("dropbar.sources")
			local utils = require("dropbar.utils")
			local rust_ts = require("hackder.dropbar-rust-treesitter")

			require("dropbar").setup({
				bar = {
					sources = function(buf, _)
						local ft = vim.bo[buf].filetype

						if ft == "rust" then
							return {
								sources.path,
								utils.source.fallback({
									rust_ts,
									sources.lsp,
								}),
							}
						end

						return {
							sources.path,
							utils.source.fallback({
								sources.lsp,
								sources.treesitter,
							}),
						}
					end,
				},
				sources = {
					treesitter = {
						max_depth = 32,
					},
					lsp = {
						max_depth = 32,
					},
				},
			})
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
}
