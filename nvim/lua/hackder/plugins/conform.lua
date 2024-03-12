function ConformFormatOnSave()
	local group = vim.api.nvim_create_augroup("formatting", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		group = group,
		callback = function(args)
			require("conform").format({ bufnr = args.buf, timeout = 1000 })
		end,
	})
end

return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					javascriptreact = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					typescriptreact = { { "prettierd", "prettier" } },
					java = { "google-java-format" },
					php = { "phpcbf" },
					latex = { "latexindent" },
				},
			})

			vim.api.nvim_create_user_command("FormatOnSave", function(opts)
				if opts.fargs[1] == "on" then
					ConformFormatOnSave()
				elseif opts.fargs[1] == "off" then
					vim.api.nvim_exec("autocmd! formatting", true)
				else
					print("Invalid argument")
				end
			end, {
				nargs = 1,
				complete = function(ArgLead, CmdLine, CursorPos)
					return { "on", "off" }
				end,
			})

			ConformFormatOnSave()
		end,
	},
}
