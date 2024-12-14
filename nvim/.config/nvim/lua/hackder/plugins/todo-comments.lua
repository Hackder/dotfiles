return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		opts = {
			search = {
				command = "rg",
				args = {
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
				},
				pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
			},
			highlight = {
				pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
			},
		},
	},
}
