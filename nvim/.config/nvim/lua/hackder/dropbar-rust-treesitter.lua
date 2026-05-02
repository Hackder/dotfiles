local configs = require("dropbar.configs")
local bar = require("dropbar.bar")
local utils = require("dropbar.utils")
local stock_treesitter = require("dropbar.sources.treesitter")

local M = {}

local specs = {
	impl_item = {
		kind = "Namespace",
	},
	function_item = {
		kind = "Function",
	},
	closure_expression = {
		kind = "Function",
	},
	match_expression = {
		kind = "Operator",
	},
	match_arm = {
		kind = "EnumMember",
	},
	loop_expression = {
		kind = "Operator",
	},
	while_expression = {
		kind = "Operator",
	},
	for_expression = {
		kind = "Operator",
	},
	call_expression = {
		kind = "Method",
	},
}

local function text_of(node, buf)
	local text = vim.treesitter.get_node_text(node, buf)

	if type(text) == "table" then
		text = table.concat(text, " ")
	end

	text = text:gsub("\n", " ")
	text = text:gsub("%s+", " ")
	return vim.trim(text)
end

local function truncate(str, max_len)
	max_len = max_len or 48

	if #str <= max_len then
		return str
	end

	return str:sub(1, max_len - 1) .. "…"
end

local function find_child(node, wanted_type)
	for child in node:iter_children() do
		if child:type() == wanted_type then
			return child
		end
	end

	return nil
end

local function label_impl(node, buf)
	local text = text_of(node, buf)
	local head = text:match("^(impl%s+.-)%s*%{")

	if head and head ~= "" then
		return truncate(head, 64)
	end

	return "impl"
end

local function label_function(node, buf)
	local ident = find_child(node, "identifier")

	if ident then
		return "fn " .. text_of(ident, buf)
	end

	local text = text_of(node, buf)
	local name = text:match("fn%s+([%w_]+)")

	if name then
		return "fn " .. name
	end

	return "fn"
end

local function label_closure(node, buf)
	local text = text_of(node, buf)
	local args = text:match("^(|.-|)")

	if args and args ~= "" then
		return truncate("closure " .. args, 48)
	end

	return "closure"
end

local function label_match(node, buf)
	local text = text_of(node, buf)
	local expr = text:match("^match%s+(.-)%s*%{")

	if expr and expr ~= "" then
		return truncate("match " .. expr, 64)
	end

	return "match"
end

local function label_match_arm(node, buf)
	local text = text_of(node, buf)
	local lhs = text:match("^(.-)%s*=>")

	if lhs and lhs ~= "" then
		return truncate(vim.trim(lhs), 64)
	end

	return "arm"
end

local function label_loop(_node, _buf)
	return "loop"
end

local function label_while(node, buf)
	local text = text_of(node, buf)
	local cond = text:match("^while%s+(.-)%s*%{")

	if cond and cond ~= "" then
		return truncate("while " .. cond, 64)
	end

	return "while"
end

local function label_for(node, buf)
	local text = text_of(node, buf)
	local head = text:match("^for%s+(.-)%s*%{")

	if head and head ~= "" then
		return truncate("for " .. head, 64)
	end

	return "for"
end

local function label_call(node, buf)
	local text = text_of(node, buf)
	local callee = text:match("^(.-)%s*%(")

	if not callee or callee == "" then
		return ""
	end

	callee = vim.trim(callee)

	if callee == "" then
		return ""
	end

	return truncate(callee, 64)
end

local labelers = {
	impl_item = label_impl,
	function_item = label_function,
	closure_expression = label_closure,
	match_expression = label_match,
	match_arm = label_match_arm,
	loop_expression = label_loop,
	while_expression = label_while,
	for_expression = label_for,
	call_expression = label_call,
}

local function get_node_kind(node)
	local spec = specs[node:type()]
	return spec and spec.kind or nil
end

local function get_node_name(node, buf)
	local f = labelers[node:type()]

	if not f then
		return ""
	end

	local ok, name = pcall(f, node, buf)

	if not ok or not name then
		return ""
	end

	name = vim.trim(name)
	return name
end

local function valid_node(node, buf)
	return specs[node:type()] ~= nil and get_node_name(node, buf) ~= ""
end

local function get_node_children(node, buf)
	local children = {}

	for child in node:iter_children() do
		if valid_node(child, buf) then
			table.insert(children, child)
		else
			vim.list_extend(children, get_node_children(child, buf))
		end
	end

	return children
end

local function get_node_siblings(node, buf)
	local siblings = {}

	local current = node
	while current do
		if valid_node(current, buf) then
			table.insert(siblings, 1, current)
		else
			siblings = vim.list_extend(get_node_children(current, buf), siblings)
		end
		current = current:prev_sibling()
	end

	local idx = #siblings

	current = node:next_sibling()
	while current do
		if valid_node(current, buf) then
			table.insert(siblings, current)
		else
			vim.list_extend(siblings, get_node_children(current, buf))
		end
		current = current:next_sibling()
	end

	return siblings, idx
end

local function convert(ts_node, buf, win)
	if not valid_node(ts_node, buf) then
		return nil
	end

	local kind = get_node_kind(ts_node)
	local name = get_node_name(ts_node, buf)
	local range = { ts_node:range() }

	return bar.dropbar_symbol_t:new(setmetatable({
		buf = buf,
		win = win,
		name = name,
		icon = configs.opts.icons.kinds.symbols[kind],
		icon_hl = "DropBarIconKind" .. kind,
		name_hl = "DropBarKind" .. kind,
		range = {
			start = {
				line = range[1],
				character = range[2],
			},
			["end"] = {
				line = range[3],
				character = range[4],
			},
		},
	}, {
		__index = function(self, k)
			if k == "children" then
				self.children = vim.tbl_map(function(child)
					return convert(child, buf, win)
				end, get_node_children(ts_node, buf))
				return self.children
			end

			if k == "siblings" or k == "sibling_idx" then
				local siblings, idx = get_node_siblings(ts_node, buf)
				self.siblings = vim.tbl_map(function(sibling)
					return convert(sibling, buf, win)
				end, siblings)
				self.sibling_idx = idx
				return self[k]
			end
		end,
	}))
end

local function get_cursor_node(buf, cursor)
	return vim.F.npcall(vim.treesitter.get_node, {
		ft = vim.filetype.match({ buf = buf }),
		bufnr = buf,
		pos = {
			cursor[1] - 1,
			cursor[2] - (cursor[2] >= 1 and vim.startswith(vim.fn.mode(), "i") and 1 or 0),
		},
	})
end

function M.get_symbols(buf, win, cursor)
	buf = vim._resolve_bufnr(buf)

	if vim.bo[buf].filetype ~= "rust" then
		return stock_treesitter.get_symbols(buf, win, cursor)
	end

	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
		return {}
	end

	local ts_ok = pcall(vim.treesitter.get_parser, buf)
	if not ts_ok then
		return {}
	end

	local node = get_cursor_node(buf, cursor)
	if not node then
		return {}
	end

	local symbols = {}

	while node and #symbols < configs.opts.sources.treesitter.max_depth do
		if valid_node(node, buf) then
			table.insert(symbols, 1, convert(node, buf, win))
		end
		node = node:parent()
	end

	utils.bar.set_min_widths(symbols, configs.opts.sources.treesitter.min_widths)
	return symbols
end

return M
