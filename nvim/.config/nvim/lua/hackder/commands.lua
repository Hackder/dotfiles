vim.api.nvim_create_user_command("Open", function(opts)
	local path = vim.fn.expand("%:p:h")
	os.execute("open " .. path)
end, {})
