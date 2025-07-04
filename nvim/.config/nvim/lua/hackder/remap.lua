vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>e", function()
	local status, image = pcall(require, "image")
	if status then
		image.clear()
	end
	vim.cmd.Ex()
end, { desc = "Open NetRW" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })

vim.keymap.set("n", "H", "^", { desc = "Go to beginning of a line" })
vim.keymap.set("n", "L", "$", { desc = "Go to end of a line" })

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy to clipboard" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>lf", function()
	vim.lsp.buf.format()
end, { desc = "Format document using LSP" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Rename current word" }
)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-n>", ":cprevious<CR>", { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "<C-m>", ":cnext<CR>", { desc = "Next item in quickfix list" })

vim.keymap.set("v", ">", ">gv", { desc = "Indent selection without losing selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent selection without losing selection" })

-- Resize window with Ctrl + Left
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Right
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Up
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Down
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })

local function get_json_path_value(json, path)
	local keys = {}
	for key in string.gmatch(path, "[^%.]+") do
		table.insert(keys, key)
	end
	local value = json
	for _, key in ipairs(keys) do
		if type(value) == "table" then
			value = value[key]
		else
			return nil
		end
	end
	return value
end

local function get_locale_value_for_visual_selection()
	vim.cmd('normal! "zy')

	local selected_text = vim.fn.getreg("z")

	local ok, json_contents = pcall(vim.fn.readfile, "./src/locales/en.json")
	if not ok then
		vim.notify("Failed to read locales file: " .. json_contents, vim.log.levels.ERROR)
		return
	end

	local json = vim.fn.json_decode(table.concat(json_contents, "\n"))
	if not json then
		vim.notify("Failed to decode JSON from locales file", vim.log.levels.ERROR)
		return
	end

	local value = get_json_path_value(json, selected_text)
	if value == nil then
		vim.notify("No value found for path: " .. selected_text, vim.log.levels.WARN)
	else
		vim.notify(value, vim.log.levels.INFO, { title = "Translation text" })
	end
end

vim.keymap.set("v", "<leader>dht", get_locale_value_for_visual_selection, {
	noremap = true,
	silent = true,
	desc = "Get translation for selected JSON path (from ./src/locales/en.json, via reg z)",
})

-- Factory function to create text objects for a given delimiter.
-- @param delimiter: The character to search for (e.g., '_', '/')
-- @param key: The key to map (e.g., '_', '/')
local function setup_delimited_textobj(delimiter, key)
	-- The core function that performs the selection.
	-- @param inner: boolean, true for 'inner', false for 'around'.
	local function select_region(inner)
		-- Escape the delimiter for use in a search pattern.
		local pattern = vim.pesc(delimiter)
		local pos = vim.api.nvim_win_get_cursor(0)

		-- 'b' = backwards, 'n' = no cursor move, 'W' = no wrap
		local left_pos = vim.fn.searchpos(pattern, "bnW", pos[1])
		-- 'n' = no cursor move, 'W' = no wrap
		local right_pos = vim.fn.searchpos(pattern, "nW", pos[1])

		-- Ensure both delimiters were found on the current line.
		if left_pos[1] == 0 or right_pos[1] == 0 then
			return
		end

		-- Set start and end columns based on 'inner' or 'around'.
		local start_col = inner and (left_pos[2] + 1) or left_pos[2]
		local end_col = inner and (right_pos[2] - 1) or right_pos[2]

		-- For operator-pending mode, we move to the start,
		-- enter visual mode, then move to the end to define the motion.
		vim.fn.cursor(pos[1], start_col)
		vim.cmd("normal! v")
		vim.fn.cursor(pos[1], end_col)
	end

	-- Create mappings for operator-pending ('o') and visual ('x') modes.
	vim.keymap.set({ "o", "x" }, "i" .. key, function()
		select_region(true)
	end, { desc = "Select inner " .. delimiter })

	vim.keymap.set({ "o", "x" }, "a" .. key, function()
		select_region(false)
	end, { desc = "Select around " .. delimiter })
end

-- Create the text objects.
setup_delimited_textobj("_", "_")
setup_delimited_textobj("/", "/")
