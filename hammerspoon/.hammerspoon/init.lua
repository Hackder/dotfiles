hs.hotkey.bind({ "alt" }, "J", function()
	local app = hs.application.find("Helium")
	if app then
		local windows = app:allWindows()
		if #windows == 0 then
			hs.application.launchOrFocus("Helium")
			return
		end

		local leftMostWindow = windows[1]

		for i, window in ipairs(windows) do
			if window:frame().x < leftMostWindow:frame().x then
				leftMostWindow = window
			end
		end

		leftMostWindow:focus()
		leftMostWindow:focus()
		leftMostWindow:focus()
	end
end)

hs.hotkey.bind({ "alt" }, "H", function()
	hs.application.launchOrFocus("Ghostty")
end)

hs.hotkey.bind({ "alt" }, "K", function()
	hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind({ "alt" }, "L", function()
	hs.application.launchOrFocus("Preview")
end)

hs.hotkey.bind({ "alt" }, "I", function()
	hs.application.launchOrFocus("ClickUp")
end)

hs.hotkey.bind({ "alt" }, "M", function()
	hs.application.launchOrFocus("Messages")
end)
