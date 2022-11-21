MenuTitle = autohotdog

; This is how long the mouse button must be held to cause the menu to appear:
UMDelay = 20

SetFormat, float, 0.0
SetBatchLines, 10ms 
#SingleInstance

GPastEntries := []
GPastEntriesEx := []
GPastEntrySelected :=
GPastEntriesSelected :=
GProjectSelected :=
GConf = config.ini
IniRead, GSubjects, %GConf%, default, subjects
IniRead, GEditor, %GConf%, default, editor, notepad
IniRead, GIcon, %GConf%, default, icon, icon.png
IniRead, GDevMode, %GConf%, default, dev, Flase
IniRead, GGitBash, %GConf%, default, git, ""
IniRead, GMenuItems, %GConf%, items
IniRead, GProjects, %GConf%, projects
if FileExist(GIcon)
	Menu, Tray, Icon, %GIcon%

Gui, MixGui:Add, DateTime, w200 y10 vGMyDateTime
Gui, MixGui:Add, Button, x+10 y10 gTodaySelected, 今日
Gui, MixGui:Add, Button, x10 y+10 gDefaultSelected, 默认路径
Gui, MixGui:Add, Button, x+10 gProjectsSelected, 自定义项目
Gui, MixGui:Add, Button, x+10 gLatestSelected, 上次选定
Gui, MixGui:Add, Button, x+10 gRecordsSelected, 历史
Gui, SubjectGui:Add, DropDownList, y10 gSubmit vGSubject, %GSubjects%
Gui, SubjectGui:Add, Button, x+10 y10 gSubjectsManagement, 分类管理
Gui, TitleGui:Add, Edit, r9 vGtitle w135, 今日纪要
Gui, TitleGui:Add, Button, gSubmit -theme +0x900 w40, 确定
Gui, PastEntriesGui:Add, ListBox, gSubmit vGPastEntrySelected HwndPastEntriesList w800 h400
Gui, ProjectsGui:Add, ListBox, gSubmit vGProjectSelected HwndProjectsList w800 h400
Gui, ProjectsGui:Add, Button, x10 y+10 gProjectsManagement, 项目管理

;___________________________________________
;_____Development mode______________________

GLatestModTimestamps := []
if("True" = GDevMode)
{
	DevFocuses := ["main.ahk", "config.ini", "icon.png"]
	for _, DevFocus in DevFocuses
	{
		FileGetTime, ModTimestamp, %A_ScriptDir%\%DevFocus%, M
		GLatestModTimestamps[DevFocus] := ModTimestamp
	}
	loop
	{
		for _, DevFocus in DevFocuses
		{
			FileGetTime, ModTimestamp, %A_ScriptDir%\%DevFocus%, M
			if (GLatestModTimestamps[DevFocus] != ModTimestamp)
			{
				Msgbox, 36,, 重新加载？
				IfMsgBox Yes
					Reload
				else
					GLatestModTimestamps[DevFocus] := ModTimestamp
			}
		}
		sleep 3
	}
}
Exit

;___________________________________________
;_____Menu Sections_________________________

; Create / Edit Menu Sections here.

Button计算器: 
	Run, Calc
Return

Button打开文件夹:
	path := CustomGetPath()
	Run, explorer %path%
Return

Button复制window风格路径:
	Clipboard := CustomGetPath()
Return

Button复制Linux风格路径:
	path := CustomGetPath()
	Clipboard := StrReplace(path, "\", "/")
Return

Button复制双反斜杠路径:
	path := CustomGetPath()
	Clipboard := StrReplace(path, "\", "\\")
Return

Button打开README.md:
	path := CustomGetPath()
	if (A_WorkingDir = path)
		Return
	mdFile := path "\README.md"
	if !FileExist(mdFile)
	{
		FileAppend, # %Gtitle%  `n, %mdFile%, UTF-8
		FileAppend, `n, %mdFile%
		RegExDate :=
		RegExFound := RegExMatch(GMyDateTime, "^[0-9]{8}", RegExDate)
		if RegExFound 
		{
			FileAppend, *创建于%RegExDate%*  `n, %mdFile%
			FileAppend, `n, %mdFile%
		}
	}
	Run, %GEditor% %mdFile%
Return

ButtonCmd:
	path := CustomGetPath()
	Run, cmd /s /k cd %path%
Return

ButtonGitbash:
	if FileExist(GGitBash)
	{
		path := CustomGetPath()
		Run, %GGitBash% --cd=%path%
	}
Return

Button重新加载程序:
	Reload
Return

Submit:
	Gui, Submit
Return

TodaySelected:
	GMyDateTime := A_Now
Return

DefaultSelected:
	GMyDateTime := "null"
Return

ProjectsSelected:
	GMyDateTime := "pass"
	GProjectSelected := 
	Projects :=

	Loop, Parse, GProjects, `n, `r
		Projects := "" = Projects ? A_LoopField : Projects "|" A_LoopField

	if Projects {
		GuiControl, , %ProjectsList%, |%Projects%
		CustomSetValueViaGui("ProjectsGui", GProjectSelected)
	}else
		GProjectSelected := A_WorkingDir
Return

LatestSelected:
	GMyDateTime := "pass"
	GPastEntrySelected := CustomGetLatestRecord(GPastEntries) ? CustomGetLatestRecord(GPastEntries) : A_WorkingDir
Return

RecordsSelected:
	GMyDateTime := "pass"
	GPastEntriesSelected := 
	sortedTimestamps := ""
	if GPastEntries.Count() {
		CustomRefreshPastEntriesEx()
		for k, v in GPastEntries
			sortedTimestamps := "" = sortedTimestamps ? v : sortedTimestamps "," v
		Sort sortedTimestamps, N D,
		Loop, Parse, sortedTimestamps, `,
			GPastEntriesSelected := "" = GPastEntriesSelected ? GPastEntriesEx[A_LoopField] : GPastEntriesSelected "|" GPastEntriesEx[A_LoopField]
		GuiControl, , %PastEntriesList%, |%GPastEntriesSelected%
		CustomSetValueViaGui("PastEntriesGui", GPastEntrySelected)
	} else 
		GPastEntrySelected := A_WorkingDir
Return

SubjectsManagement:
	GSubject:="null"
	Run, %GEditor% %GConf%
Return

ProjectsManagement:
	GProjectSelected := A_WorkingDir
	Run, %GEditor% %GConf%
Return

GuiHide:
	Gui, hide
return

;___________________________________________
;_____Hotkey Section________________________

~MButton::
	HowLong = 0
	Loop
	{
		HowLong ++
		Sleep, 10
		GetKeyState, MButton, MButton, P
		IfEqual, MButton, U, Break
	}
	IfLess, HowLong, %UMDelay%, Return
	gosub, ~WheelLeft
Return

~WheelLeft::
~WheelRight::
	TempMenu = %GMenuItems%

	;clears earlier entries
	Loop
	{
		IfEqual, MenuItem%A_Index%,, Break
		MenuItem%A_Index% =
	}
	Gui, +AlwaysOnTop -Caption
	Gui, Margin, 0, 0

	;creates new entries
	Loop, Parse, TempMenu, `n, `r
	{
		MenuItem%A_Index% = %A_LoopField%
		Gui, Add, Button, -theme +0x100 w160 h30, %A_LoopField%
	}

	;show the menu
	CoordMode, Mouse, Screen
	MouseGetPos, mX, mY
	SetTimer, GuiHide, -5000
	WinActivate, %MenuTitle%
	Gui +LastFound
	Gui, show, x%mX% y%mY%

	;hide the menu while inactive
	Loop
	{
		IfWinNotActive
		{
			sleep, 100
			IfWinNotActive
			{
				Gosub, GuiHide
				Return
			}
			
		}
		sleep 10
	}
Return

;___________________________________________
;_____Function Section______________________

CustomSetValueViaGui(ByRef input_gui,ByRef value)
{
	Gui, %input_gui%:-Caption
	Gui, %input_gui%:Show
	value = 
	Loop
	{
		if ("" != value)
		{
			Gui, %input_gui%:Hide
			Return value
		}
		sleep 100
	}
	Return
}

CustomGetPath()
{
	global GMyDateTime
	global GSubject
	global Gtitle
	global GPastEntries
	global GPastEntrySelected
	global GProjectSelected
	GPastEntrySelected := 
	GProjectSelected :=
	gosub, GuiHide
	if ("null" = CustomSetValueViaGui("MixGui", GMyDateTime))
		Return CustomRecord(A_WorkingDir, GPastEntries)
	if ("" != GPastEntrySelected)
		Return CustomRecord(GPastEntrySelected, GPastEntries)
	if ("" != GProjectSelected)
		Return  CustomRecord(GProjectSelected, GPastEntries)
	if ("null" = CustomSetValueViaGui("SubjectGui", GSubject))
		Return CustomRecord(A_WorkingDir, GPastEntries)
	CustomSetValueViaGui("TitleGui", Gtitle)
	arr := [ A_WorkingDir, SubStr(GMyDateTime, 1, 6), SubStr(GMyDateTime, 5, 4), GSubject, Gtitle]
	path := Format("{}\{}\{}.{}.{}", arr*)
	If !FileExist(path)
		FileCreateDir, %path%
	Return CustomRecord(path, GPastEntries)
}

CustomRecord(ByRef path, ByRef arr)
{
	arr[path] := A_Now
	Return path
}

CustomGetLatestRecord(ByRef arr)
{
	tempK := 
	tempV := 0
	for k,v in arr
	{
		if (tempV < v)
		{
			tempK := k
			tempV := v
		}	
	}
	Return tempK
}

CustomRefreshPastEntriesEx()
{
	global GPastEntries
	global GPastEntriesEx
	GPastEntriesEx := []
	for k,v in GPastEntries
		GPastEntriesEx[v] := k
}