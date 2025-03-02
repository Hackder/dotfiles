return {
	{
		"RRethy/nvim-base16",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.base16colorspace = 256
			vim.o.background = "dark"
			vim.cmd.colorscheme("base16-gruvbox-dark-hard")
			-- Setup lsp token highlights
			vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@namespace" })
			vim.api.nvim_set_hl(0, "@lsp.type.type", { link = "@type" })
			vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@type" })
			vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "@type" })
			vim.api.nvim_set_hl(0, "@lsp.type.interface", { link = "@type" })
			vim.api.nvim_set_hl(0, "@lsp.type.struct", { link = "@structure" })
			vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "@parameter" })
			vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "@property" })
			vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@property" })
			vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { link = "@constant" })
			vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })
			vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "@method" })
			vim.api.nvim_set_hl(0, "@lsp.type.macro", { link = "@macro" })
			vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "@function" })
			vim.api.nvim_set_hl(0, "TSTagDelimiter", { link = "@property" })
			vim.api.nvim_set_hl(0, "TSVariable", { link = "@property" })
			vim.api.nvim_set_hl(0, "TSPunctDelimiter", { link = "@property" })

			vim.api.nvim_set_hl(0, "@lsp.mod.global", { link = "@variable.builtin" })
			vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
			vim.api.nvim_set_hl(0, "@function.builtin", { link = "@variable.builtin" })

			-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		end,
	},
	{ "catppuccin/nvim", lazy = false, name = "catppuccin", priority = 1000 },
}
