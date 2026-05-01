return {
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		init = function()
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
		end,
		opts = {
			useLspFoldsWithTreesitterFallback = {
				enabled = true,
			},
			foldtext = {
				enabled = true,
			},
			autoFold = {
				enabled = false,
			},
			foldKeymaps = {
				setup = false,
			},
		},
	},
}
