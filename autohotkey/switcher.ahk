; Alt+H focuses the window of WindowsTerminal.exe if it is open, if it's not open, it opens the program.
!h::
IfWinExist ahk_exe wezterm-gui.exe
{
    WinActivate
}
else
{
    Run wezterm.exe
}
return

; Alt+J focuses the window of chrome.exe if it is open, if it's not open, it opens the program.
!j::
IfWinExist ahk_exe chrome.exe
{
	WinGet, idList, List

target := 0
targetX := 10000000
; Loop through each window and print its position.
Loop %idList%
{
    thisID := idList%A_Index%
    WinGet, theExe, ProcessName, % "ahk_id " idList%A_Index%  ;get the name of the exe

    if (theExe == "chrome.exe")
    {
        WinGetPos, X, Y, Width, Height, ahk_id %thisID%
	if (X < targetX)
	{
	    targetX := X
	    target := thisID
	}
    }
    
}

WinActivate, ahk_id %target%
}
else
{
    Run chrome.exe
}
return

