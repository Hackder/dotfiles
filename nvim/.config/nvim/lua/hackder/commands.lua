vim.api.nvim_create_user_command("Open", function(opts)
	local path = vim.fn.expand("%:p:h")
	os.execute("open " .. path)
end, {})

vim.api.nvim_create_user_command("RustAnalyzerTarget", function(opts)
	local target = opts.args
	if not target or target == "" then
		vim.notify("Please provide a target triple", vim.log.levels.ERROR)
		return
	end
	local cmd = string.format("RustAnalyzer config { cargo = { target = '%s' } }", target)
	vim.cmd(cmd)
end, {
	nargs = 1,
	complete = function(ArgLead, CmdLine, CursorPos)
		local list = vim.fn.systemlist("rustc --print target-list")
		if type(list) ~= "table" then
			return {}
		end
		if not ArgLead or ArgLead == "" then
			return list
		end
		local matches = {}
		for _, item in ipairs(list) do
			if vim.startswith(item, ArgLead) then
				table.insert(matches, item)
			end
		end
		return matches
	end,
})

vim.api.nvim_create_user_command("DiffLines", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	-- Get current line and the one below
	local lines = vim.api.nvim_buf_get_lines(bufnr, row - 1, row + 1, false)

	if #lines < 2 then
		vim.notify("EOF: No line below to diff.", vim.log.levels.ERROR)
		return
	end

	local result = vim.diff(lines[1], lines[2])
	print(result ~= "" and result or "Lines are identical")
end, { desc = "Diff current line and the line below" })
