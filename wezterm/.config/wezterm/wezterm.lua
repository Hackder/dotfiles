local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.native_macos_fullscreen_mode = false

config.default_prog = { 'powershell.exe' }

-- function recompute_padding(window)
-- 	local window_dims = window:get_dimensions()
-- 	local overrides = window:get_config_overrides() or {}
--
-- 	if window_dims.is_full_screen then
-- 		window:set_position(0, 0)
-- 	end
-- 	window:set_config_overrides(overrides)
-- end

-- wezterm.on("window-resized", function(window, pane)
-- 	recompute_padding(window)
-- end)
--
-- wezterm.on("window-config-reloaded", function(window)
-- 	recompute_padding(window)
-- end)

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Gruvbox dark, hard (base16)"
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 12.0

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = "#3E3836",

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = "#83A598",
      -- The color of the text for the tab
      fg_color = "#1E2021",

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = "Normal",

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = "None",

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = "#3E3836",
      fg_color = "#C0AD90",

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = "#443C3A",
      fg_color = "#C0AD90",
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = "#3D3634",
      fg_color = "#C0AD90",

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = "#443C3A",
      fg_color = "#C0AD90",
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

config.window_padding = {
  top = 0,
  right = 0,
  bottom = 0,
  left = 0,
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- { key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
  -- Splitting
  { key = "%", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "=", mods = "LEADER|SHIFT", action = wezterm.action.TogglePaneZoomState },
  -- Moving between panes
  { key = "l", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "h", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Up") },
  -- Zooming pane
  { key = "z", mods = "LEADER",       action = wezterm.action.TogglePaneZoomState },
  -- New tab
  { key = "c", mods = "LEADER",       action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  -- Moving between tabs
  { key = "1", mods = "LEADER",       action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "LEADER",       action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "LEADER",       action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "LEADER",       action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "LEADER",       action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "LEADER",       action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "LEADER",       action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "LEADER",       action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "LEADER",       action = wezterm.action.ActivateTab(8) },
  -- Copy mode
  { key = "[", mods = "LEADER",       action = wezterm.action.ActivateCopyMode },
  -- Sessionizer
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = "f",
    mods = "LEADER",
    action = wezterm.action_callback(require("sessionizer").toggle),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  -- Debug
  {
    key = "?",
    mods = "LEADER|SHIFT",
    action = wezterm.action.ShowDebugOverlay,
  },
}

-- and finally, return the configuration to wezterm
return config
