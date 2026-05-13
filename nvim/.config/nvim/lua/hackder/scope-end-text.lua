local M = {}

local ns = vim.api.nvim_create_namespace("scope_end_text")
local group = vim.api.nvim_create_augroup("ScopeEndText", { clear = true })

local defaults = {
	prefix = " // ",
	max_len = 100,
	min_rows = 2,
	debounce_ms = 80,
	excluded_filetypes = { "help", "markdown", "text", "gitcommit" },
	-- Node types to skip: call chains, argument lists, collection literals — they
	-- get folded but their "header" isn't useful end-of-scope context.
	excluded_node_types = {
		call_expression = true,
		call = true,
		method_invocation = true,
		arguments = true,
		argument_list = true,
		parameters = true,
		formal_parameters = true,
		parameter_list = true,
		tuple_expression = true,
		tuple = true,
		array_expression = true,
		array_literal = true,
		array = true,
		list = true,
		dictionary = true,
		set = true,
		object = true,
		object_expression = true,
		parenthesized_expression = true,
		macro_invocation = true,
		token_tree = true,
	},
}

local enabled = true
local timers = {}

local function clear(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function header_for(bufnr, start_row, opts)
	local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
	if not line then
		return nil
	end

	line = line:gsub("[%s{%(%[]+$", "")
	line = vim.trim(line)

	if line == "" then
		return nil
	end

	-- Skip continuation lines (method chains ".foo()", trailing ")...", etc.) but
	-- keep things like closures "|x| {" or arrow functions.
	if line:match("^[%.,%)%]}]") then
		return nil
	end

	if vim.fn.strdisplaywidth(line) > opts.max_len then
		line = line:sub(1, opts.max_len - 1) .. "…"
	end

	return opts.prefix .. line
end

function M.refresh(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	clear(bufnr)

	if not enabled then
		return
	end

	local ft = vim.bo[bufnr].filetype
	if ft == "" or vim.tbl_contains(M.opts.excluded_filetypes, ft) then
		return
	end

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return
	end

	local trees = parser:parse()
	if not trees or not trees[1] then
		return
	end

	local lang = parser:lang()
	local query = vim.treesitter.query.get(lang, "folds")
	if not query then
		return
	end

	local used_rows = {}

	for _, tree in ipairs(trees) do
		for _, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
			local start_row, _, end_row, end_col = node:range()
			if end_col == 0 then
				end_row = end_row - 1
			end

			if
				end_row - start_row >= M.opts.min_rows
				and not used_rows[end_row]
				and not M.opts.excluded_node_types[node:type()]
			then
				local text = header_for(bufnr, start_row, M.opts)
				if text then
					used_rows[end_row] = true
					vim.api.nvim_buf_set_extmark(bufnr, ns, end_row, 0, {
						virt_text = { { text, "ScopeEndText" } },
						virt_text_pos = "eol",
						hl_mode = "combine",
						priority = 200,
					})
				end
			end
		end
	end
end

local function schedule_refresh(bufnr)
	local existing = timers[bufnr]
	if existing then
		existing:stop()
		if not existing:is_closing() then
			existing:close()
		end
		timers[bufnr] = nil
	end

	local timer = vim.uv.new_timer()
	timers[bufnr] = timer

	timer:start(M.opts.debounce_ms, 0, function()
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(bufnr) then
				M.refresh(bufnr)
			end
			local t = timers[bufnr]
			if t then
				t:stop()
				if not t:is_closing() then
					t:close()
				end
				timers[bufnr] = nil
			end
		end)
	end)
end

function M.enable()
	enabled = true
	M.refresh()
end

function M.disable()
	enabled = false
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			clear(bufnr)
		end
	end
end

function M.toggle()
	if enabled then
		M.disable()
	else
		M.enable()
	end
end

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", defaults, opts or {})

	vim.api.nvim_set_hl(0, "ScopeEndText", { default = true, link = "Comment" })

	vim.api.nvim_create_user_command("ScopeEndTextRefresh", function()
		M.refresh()
	end, {})

	vim.api.nvim_create_user_command("ScopeEndTextToggle", function()
		M.toggle()
	end, {})

	vim.api.nvim_create_autocmd({
		"BufEnter",
		"BufWinEnter",
		"TextChanged",
		"InsertLeave",
		"BufWritePost",
	}, {
		group = group,
		callback = function(args)
			schedule_refresh(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(args)
			clear(args.buf)
			local t = timers[args.buf]
			if t then
				t:stop()
				if not t:is_closing() then
					t:close()
				end
				timers[args.buf] = nil
			end
		end,
	})
end

return M
