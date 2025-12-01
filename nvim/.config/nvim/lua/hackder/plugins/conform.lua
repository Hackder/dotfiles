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
					json = { "prettierd", "prettier", stop_after_first = true },
					vue = { "prettierd", "prettier", stop_after_first = true },
					astro = { "prettierd", "prettier", stop_after_first = true },
					java = { "google-java-format" },
					php = { "phpcbf" },
					latex = { "latexindent" },
				},
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
				default_format_opts = {
					lsp_format = "fallback",
				},
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			vim.keymap.set("n", "<leader>gf", function()
				local hunks = require("gitsigns").get_hunks(vim.api.nvim_get_current_buf())
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
