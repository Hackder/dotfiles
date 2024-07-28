return {
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			local comment = require("Comment")
			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
			comment.setup({
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
			vim.keymap.set("n", "<leader>/", function()
				require("Comment.api").toggle.linewise.current()
			end, { desc = "Comment line" })
			vim.keymap.set(
				"v",
				"<leader>/",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				{ desc = "Comment selection" }
			)
		end,
	},
}
