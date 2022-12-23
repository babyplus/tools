#Requires AutoHotkey v2.0-beta

GMouseDelay := 20
#SingleInstance

GPastEntries := []
GPastEntriesEx := []
GPastEntrySelected := ""
GPastEntriesSelected := ""
GProjectSelected := ""
GConf := "config.ini"
GSubjects := IniRead(GConf, "default", "subjects")
GEditor := IniRead(GConf, "default", "editor", "notepad")
GIcon := IniRead(GConf, "default", "icon", "icon.png")
GDevMode := IniRead(GConf, "default", "dev", "Flase")
GGitBash := IniRead(GConf, "default", "git", "")
GMenuItems := IniRead(GConf, "items")
GProjects := IniRead(GConf, "projects")
if FileExist(GIcon)
	TraySetIcon GIcon

GLatestModTimestamps := Map()
if "True" = GDevMode
{
	DevFocuses := ["main.ahk", "config.ini", "icon.png"]
	for _, DevFocus in DevFocuses
	{
		ModTimestamp := FileGetTime(DevFocus, "M")
		GLatestModTimestamps[DevFocus] := ModTimestamp
	}
	loop
	{
		for _, DevFocus in DevFocuses
		{
            ModTimestamp := FileGetTime(DevFocus, "M")
			if GLatestModTimestamps[DevFocus] != ModTimestamp
			{
				if "Yes" == Msgbox("重新加载？", "", 36)
					Reload
				else
					GLatestModTimestamps[DevFocus] := ModTimestamp
			}
		}
		sleep 3
	}
}
Exit

main()
{
	MenuItems := Map()
	ItemsGui := Gui()
	Loop parse, GMenuItems, "`n`r"
		ItemsGui.Add("Button", "w260 h30", A_LoopField)
	ItemsGui.Show("xCenter y0")
	Return
}

; ~MButton::
; {
; 	duration := 0
; 	Loop
; 	{
; 		duration += 1
; 		Sleep 10
;         if !GetKeyState("MButton", "P")
;             break
; 	}
;     if duration < GMouseDelay
;         Return
; 	main
;     Return
; }

; ~WheelLeft::
; {
; 	main
; 	Return
; }

F1::
{
	main
	Return
}
