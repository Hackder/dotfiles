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

-- Extra captures layered on top of the bundled `folds` query for the JS/TS
-- family. The folds query only captures the whole `if_statement`, so the
-- intermediate `} else if {` / `} else {` braces get no label. Capturing each
-- branch body (and giving it priority over folds for shared end rows) lets every
-- closing brace label the branch it actually closes.
local branch_query_src = [[
	(if_statement consequence: (statement_block) @branch)
	(else_clause (statement_block) @branch)
]]

local branch_query_langs = {
	typescript = true,
	tsx = true,
	javascript = true,
}

local branch_query_cache = {}

local function get_branch_query(lang)
	if not branch_query_langs[lang] then
		return nil
	end
	if branch_query_cache[lang] == nil then
		local ok, q = pcall(vim.treesitter.query.parse, lang, branch_query_src)
		branch_query_cache[lang] = ok and q or false
	end
	return branch_query_cache[lang] or nil
end

local function clear(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function header_for(bufnr, start_row, opts, normalize_else)
	local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
	if not line then
		return nil
	end

	line = line:gsub("[%s{%(%[]+$", "")
	line = vim.trim(line)

	if line == "" then
		return nil
	end

	-- Normalize `} else {` and `} else if (...) {` so the label reads
	-- "else" / "else if (...)" instead of being dropped by the leading-`}`
	-- continuation check below. Gated per-language so other filetypes keep
	-- their existing behavior.
	if normalize_else then
		local else_part = line:match("^}%s*(else.*)$")
		if else_part then
			line = else_part
		end
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

	-- Parse the whole document, including injected languages (e.g. the TS in a
	-- Svelte `<script>` block), so we can label scopes inside them too.
	local pok = pcall(parser.parse, parser, true)
	if not pok then
		return
	end

	local used_rows = {}

	local function process(query, tree, normalize_else)
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
				local text = header_for(bufnr, start_row, M.opts, normalize_else)
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

	-- Walk every language tree (root + injections). Each gets its own `folds`
	-- query, plus the branch query for the JS/TS family.
	local folds_cache = {}
	parser:for_each_tree(function(tstree, ltree)
		local lang = ltree:lang()

		if folds_cache[lang] == nil then
			folds_cache[lang] = vim.treesitter.query.get(lang, "folds") or false
		end
		local folds_query = folds_cache[lang]
		if not folds_query then
			return
		end

		local branch_query = get_branch_query(lang)
		local normalize_else = branch_query ~= nil

		-- Branch captures run first so an `else`/`else if` branch wins its
		-- closing brace over the enclosing `if_statement` from the folds query.
		if branch_query then
			process(branch_query, tstree, normalize_else)
		end
		process(folds_query, tstree, normalize_else)
	end)
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
