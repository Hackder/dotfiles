function ConformFormatOnSave()
	local group = vim.api.nvim_create_augroup("formatting", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		group = group,
		callback = function(args)
			require("conform").format({ bufnr = args.buf, timeout = 1000, lsp_format = "fallback" })
		end,
	})
end

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "lewis6991/gitsigns.nvim" },
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
					-- Use a sub-list to run only the first available formatter
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
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

			vim.keymap.set("n", "<leader>gf", function()
				local hunks = require("gitsigns").get_hunks()
				local format = require("conform").format
				for i = #hunks, 1, -1 do
					local hunk = hunks[i]
					if hunk ~= nil and hunk.type ~= "delete" then
						local start = hunk.added.start
						local last = start + hunk.added.count
						-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
						local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
						local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
						format({ range = range })
					end
				end
			end, { desc = "Format unstaged ranges" })
		end,
	},
}
