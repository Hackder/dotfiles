-- fff doesn't remember which window the picker was opened from; after closing its
-- floats it opens the file in whatever window Neovim falls back to, which is the
-- first window when focus moved between the picker's floats. Remember it ourselves.
local origin_win = nil

local function with_origin(fn)
	return function()
		origin_win = vim.api.nvim_get_current_win()
		fn()
	end
end

local function can_host_file(win)
	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].buftype == ""
		and vim.bo[buf].modifiable
		and not require("fff.utils").window_has_winfixbuf(win)
end

return {
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- this will download prebuild binary or try to use existing rustup toolchain to build from source
			-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
			require("fff.download").download_or_build_binary()
		end,
		-- if you are using nixos
		-- build = "nix run .#release",
		opts = { -- (optional)
			select = {
				select_window = function(_, action)
					local win = origin_win
					origin_win = nil
					if
						not win
						or not vim.api.nvim_win_is_valid(win)
						or vim.api.nvim_win_get_tabpage(win) ~= vim.api.nvim_get_current_tabpage()
					then
						win = vim.api.nvim_get_current_win()
					end
					if action == "edit" and not can_host_file(win) then
						return require("fff.utils").find_suitable_window()
					end
					return win
				end,
			},
			debug = {
				enabled = false, -- we expect your collaboration at least during the beta
				show_scores = false, -- to help us optimize the scoring system, feel free to share your scores!
			},
		},
		-- No need to lazy-load with lazy.nvim.
		-- This plugin initializes itself lazily.
		lazy = false,
		keys = {
			{
				"<C-p>", -- try it if you didn't it is a banger keybinding for a picker
				with_origin(function()
					require("fff").find_files()
				end),
				desc = "FFFind files",
			},
			{
				"<F4>",
				with_origin(function()
					require("fff").live_grep()
				end),
				desc = "LiFFFe grep",
			},
			{
				"<leader>fa",
				with_origin(function()
					require("fff").live_grep({
						grep = {
							modes = { "fuzzy", "plain" },
						},
					})
				end),
				desc = "Live fffuzy grep",
			},
		},
	},
}
