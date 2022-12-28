#Requires AutoHotkey v2.0-beta

GMouseDelay := 20
#SingleInstance

;;;;;;;;;;;;;;;;;;;
;; global values ;;
;;;;;;;;;;;;;;;;;;;
types := {
	Undefined: 0,
	DateTime: 1,
	Custom: 2,
	LatestSelected: 3,
	History: 4,
	Ingnore: 99,
}
GPastEntries := Map()
GPastEntriesSorted := []
GConf := "config.ini"
GEditor := IniRead(GConf, "default", "editor", "notepad")
GIcon := IniRead(GConf, "default", "icon", "icon.png")
GDevMode := IniRead(GConf, "default", "dev", "Flase")
GGitBash := IniRead(GConf, "default", "git", "")
GMenuItems := IniRead(GConf, "items")
GSubjects := IniRead(GConf, "subjects")
if FileExist(GIcon)
	TraySetIcon GIcon
GLatestModTimestamps := Map()

;;;;;;;;;;;;
;; Reload ;;
;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;
setValueViaGui(&variable, &inputGui)
{
	variable.type := types.Undefined
	inputGui.Show()
	Loop
	{
		if variable.type
		{
			inputGui.Destroy
			Return variable
		}
		sleep 500
	}
	Return
}

setSubject(&subject)
{
	variable := {
		type: types.Undefined,
		val: ""
	}
	subjectGui := Gui()
	arr := []
	Loop parse, GSubjects, "`n`r"
		arr.Push(A_LoopField)
	subjectGui.Add("DropDownList", , arr)
	.OnEvent("change", (_*)=>(variable.type := types.Ingnore, subject := arr[_[1].value]))
	setValueViaGui(&variable, &subjectGui)
}

setTitle(&title)
{
	variable := {
		type: types.Undefined,
		val: ""
	}
	titleGui := Gui()
	titleGui.Add("Edit", "w160 r9 vContent", "今日记录")
	titleGui.Add("Button",  "w80", "确定")
	.OnEvent("click", (_*)=>(variable.type := types.Ingnore, title := StrReplace(_[1].Gui["Content"].value, "`n", "")))
	setValueViaGui(&variable, &titleGui)
}

splicePath(variable, _*)
{
	arr := [A_WorkingDir, SubStr(variable.val, 1, 6), SubStr(variable.val, 5, 4), _[1], _[2]]
	return Format("{}\{}\{}.{}.{}", arr*)
}

setCustomPath(&path, &variable)
{
	projects := []
	Loop parse, IniRead(GConf, "projects"), "`n`r"
		projects.Push(A_LoopField)
	projectsGui := Gui()
	projectsGui.Add("ListBox", "r20 w800", projects)
	.OnEvent("change", (_*)=>(variable.type := types.Ingnore, path := projects[_[1].value]))
	setValueViaGui(&variable, &projectsGui)
}

selectHistoryEntry(&path, &variable)
{
	global GPastEntriesSorted
	if GPastEntriesSorted.Length
	{
		pastEntriesGui := Gui()
		pastEntriesGui.Add("ListBox", "r20 w800", GPastEntriesSorted)
		.OnEvent("change", (_*)=>(variable.type := types.Ingnore, path := GPastEntriesSorted[_[1].value]))
		setValueViaGui(&variable, &pastEntriesGui)
	} else {
		path := A_WorkingDir
	}
}

selectLatestEntry(&path)
{
	global GPastEntriesSorted
	path := GPastEntriesSorted.Length ? GPastEntriesSorted[1] : A_WorkingDir
}

record(value, &entries, cb*)
{
	entries[value] := A_Now
	if cb.Length
		for fn in cb
			fn(entries)
}

sortEntries(entries)
{
	global GPastEntriesSorted
	pastEntriesEx := Map()
	moments := ""
	for k,v in GPastEntries
		pastEntriesEx[v] := k
	for k,v in pastEntriesEx
		moments := moments " " k
	moments := Sort(moments, "R N D ")
	GPastEntriesSorted := []
	Loop parse, moments, " "
		if A_LoopField
			GPastEntriesSorted.Push(pastEntriesEx[A_LoopField])
}

getPath()
{
	global GPastEntries
	variable := {
		type: types.Undefined,
		val: ""
	}
	path := ""
	ex := Map()
	subject := ""
	title := ""

	mixGui := Gui()
	mixGui.Add("DateTime", "w220 y10", "yyyy-MM-dd")
	.OnEvent("Change", (_*)=>(variable.type := types.DateTime, variable.val := _[1].value))
	mixGui.Add("Button", "x+10 y10", "今日")
	.OnEvent("click", (_*)=>(variable.type := types.DateTime, variable.val := A_Now))
	mixGui.Add("Button", "x10 y+10", "默认路径")
	.OnEvent("click", (_*)=>(variable.type := types.Ingnore))
	mixGui.Add("Button", "x+10", "自定义项目")
	.OnEvent("click", (_*)=>(variable.type := types.Custom))
	mixGui.Add("Button", "x+10", "上次选定")
	.OnEvent("click", (_*)=>(variable.type := types.LatestSelected))
	mixGui.Add("Button", "x+10", "历史")
	.OnEvent("click", (_*)=>(variable.type := types.History))

	switch setValueViaGui(&variable, &mixGui).type {
		case types.DateTime:
			setSubject(&subject), setTitle(&title), path := splicePath(variable, subject, title),
			ex.subject := subject, ex.title := title, ex.time := variable.val
		case types.Custom:
			setCustomPath(&path, &variable)
		case types.History:
			selectHistoryEntry(&path, &variable)
		case types.LatestSelected:
			selectLatestEntry(&path)
		default:
	}
	
	path := "" == path ? A_WorkingDir : path
	record(path, &GPastEntries, sortEntries)
	If !FileExist(path)
		DirCreate path
	return {path: path, ex: ex}
}

editMarkdown(obj)
{
	path := obj.path
	if (A_WorkingDir = path)
		Return
	mdFile := path "\README.md"
	if !FileExist(mdFile)
	{
		FileAppend("# " obj.ex.title "  `n", mdFile, "UTF-8")
		FileAppend("*" obj.ex.time "  `n", mdFile, "UTF-8")
	}
	Run(GEditor " " mdFile)
}

item_click(params*)
{
	params[1].Gui.Hide()
	switch params[1].Text 
	{
		case "计算器":
			Run("Calc")
		case "打开文件夹":
			Run("explorer " getPath().path)
		case "复制window风格路径":
			A_Clipboard := getPath().path
		case "复制Linux风格路径":
			A_Clipboard := StrReplace(getPath().path, "\", "/")
		case "复制双反斜杠路径":
			A_Clipboard := StrReplace(getPath().path, "\", "\\")
		case "打开README.md":
			editMarkdown(getPath())
		case "Cmd":
			Run("cmd /s /k cd " getPath().path)
		case "Git bash":
			Run(GGitBash " --cd=" getPath().path)
		case "重新加载程序":
			Reload
		default:
			Msgbox "undefine"
	}
	Return
}

main()
{
	xpos := 0
	ypos := 0
	ItemsGui := Gui()
	Loop parse, GMenuItems, "`n`r"
		ItemsGui.Add("Button", "w260 h30", A_LoopField).OnEvent("Click", item_click)
	MouseGetPos &xpos, &ypos
	ItemsGui.Show("x" xpos " y" ypos)
	SetTimer(()=>(ItemsGui.Hide()), -5000)
	Return
}

~MButton::
{
	duration := 0
	Loop
	{
		duration += 1
		Sleep 10
        if !GetKeyState("MButton", "P")
            break
	}
    if duration < GMouseDelay
        Return
	main
    Return
}

~WheelRight::
~WheelLeft::
{
	main
	Return
}
