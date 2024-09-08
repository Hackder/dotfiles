local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/opt/homebrew/bin/fd"
local rootPath = "/Users/jurajpetras/dev"

M.toggle = function(window, pane)
	local projects = {}

	wezterm.log_info("Running fd")

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		"-td",
		"^.git$",
		"--max-depth=4",
		rootPath,
		-- add more paths here
	})

	-- local success, stdout, stderr = wezterm.run_child_process({
	-- 	fd,
	-- 	"fd",
	-- 	"-HI",
	-- 	"-td",
	-- 	".*",
	-- 	"--max-depth=1",
	-- 	"/Users/jurajpetras/pmat",
	-- 	"/Users/jurajpetras/pmat/interactives",
	-- 	"/Users/jurajpetras",
	-- 	"/Users/jurajpetras/programming",
	-- 	"/Users/jurajpetras/temp",
	-- 	"/Users/jurajpetras/proxic",
	-- 	"/Users/jurajpetras/pollux",
	-- 	"/Users/jurajpetras/dev",
	-- 	"/Users/jurajpetras/dev/pmat",
	-- 	"/Users/jurajpetras/school",
	-- 	"/Users/jurajpetras/dev/gleam",
	-- })

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("/.git/$", "")
		project = project:gsub("^/Users/jurajpetras/", "~/")
		local label = project
		local id = project:gsub(".*/", "")
		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }), pane)
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace() .. " ")
end)

return M
