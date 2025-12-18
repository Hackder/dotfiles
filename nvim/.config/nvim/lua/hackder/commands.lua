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
