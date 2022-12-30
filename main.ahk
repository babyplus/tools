#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;
;; global values ;;
;;;;;;;;;;;;;;;;;;;
undefined := "undefined"
null := ""
types := {
	Undefined: 0,
	DateTime: 1,
	Custom: 2,
	LatestSelected: 3,
	History: 4,
	Ingnore: 99,
}

GCapacities := [
	"计算器",
	"打开文件夹",
	"打开README.md",
	"复制window风格路径",
	"复制双反斜杠路径",
	"复制Linux风格路径",
	"Cmd",
	"Git bash",
	"重新加载程序"
]

GMouseDelay := 20
GPastEntries := Map()
GPastEntriesSorted := []
GConf := "config.ini"
GEditor := IniRead(GConf, "default", "editor", "notepad")
GIcon := IniRead(GConf, "default", "icon", "icon.png")
GReloadMode := IniRead(GConf, "default", "reload", "Flase")
GGitBash := IniRead(GConf, "default", "git", null)
GTimeout := IniRead(GConf, "default", "timeout", 5000)
GMButtonStyle := IniRead(GConf, "default", "mButtonStyle", "custom")
GWheelRLStyle := IniRead(GConf, "default", "wheelRLStyle", "built-in")
GMenuItems := IniRead(GConf, "items")
GSubjects := IniRead(GConf, "subjects")

if FileExist(GIcon)
	TraySetIcon GIcon
GLatestModTimestamps := Map()
GGuiComOpt := "-Caption +AlwaysOnTop +LastFound"
GGuiUniTitle := "shortcuts_" A_NowUTC

;;;;;;;;;;;;
;; Reload ;;
;;;;;;;;;;;;
if "True" = GReloadMode
{
	focuses := ["main.ahk", "config.ini", "icon.png"]
	for _, focus in focuses
	{
		If !FileExist(focus)
			continue
		ModTimestamp := FileGetTime(focus, "M")
		GLatestModTimestamps[focus] := ModTimestamp
	}
	loop
	{
		for _, focus in focuses
		{
			If !FileExist(focus)
				continue
			ModTimestamp := FileGetTime(focus, "M")
			if GLatestModTimestamps[focus] != ModTimestamp
			{
				if "Yes" == Msgbox("检测到文件有变化，是否重新加载程序？", null, 36)
					Reload
				else
					GLatestModTimestamps[focus] := ModTimestamp
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
		val: null
	}
	subjectGui := Gui(GGuiComOpt, GGuiUniTitle)
	arr := []
	Loop parse, GSubjects, "`n`r"
		arr.Push(A_LoopField)
	subjectGui.Add("DropDownList", "w160", arr)
	.OnEvent("change", (_*)=>(variable.type := types.Ingnore, subject := arr[_[1].value]))
	setValueViaGui(&variable, &subjectGui)
}

setTitle(&title)
{
	variable := {
		type: types.Undefined,
		val: null
	}
	titleGui := Gui(GGuiComOpt, GGuiUniTitle)
	titleGui.Add("Edit", "w160 r10 vContent", "今日记录")
	titleGui.Add("Button",  "w80", "确定")
	.OnEvent("click", (_*)=>(variable.type := types.Ingnore, title := StrReplace(_[1].Gui["Content"].value, "`n", null)))
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
	projectsGui := Gui(GGuiComOpt, GGuiUniTitle)
	projectsGui.Add("ListBox", "r20 w800", projects)
	.OnEvent("change", (_*)=>(
		_[1].value ? variable.type := types.Ingnore path := projects[_[1].value] : path := null
	))
	setValueViaGui(&variable, &projectsGui)
}

selectHistoryEntry(&path, &variable)
{
	global GPastEntriesSorted
	if GPastEntriesSorted.Length
	{
		pastEntriesGui := Gui(GGuiComOpt, GGuiUniTitle)
		pastEntriesGui.Add("ListBox", "r20 w800", GPastEntriesSorted)
		.OnEvent("change", (_*)=>(
			_[1].value ? variable.type := types.Ingnore path := GPastEntriesSorted[_[1].value] : path := null
		))
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
	moments := null
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
		val: null
	}
	path := null

	mixGui := Gui(GGuiComOpt, GGuiUniTitle)
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

	switch setValueViaGui(&variable, &mixGui).type
	{
		case types.DateTime:
			setSubject(&subject), setTitle(&title), path := splicePath(variable, subject, title)
		case types.Custom:
			setCustomPath(&path, &variable)
		case types.History:
			selectHistoryEntry(&path, &variable)
		case types.LatestSelected:
			selectLatestEntry(&path)
		default:
	}
	
	path := null == path ? A_WorkingDir : path
	record(path, &GPastEntries, sortEntries)
	If !FileExist(path)
		DirCreate path
	return path
}

editMarkdown(path)
{
	title := date := undefined
	mdFile := path "\README.md"
	if !FileExist(mdFile)
	{
		Callout(m, *) 
		{
			title := m[5], date := m[1] m[3]
		}
		if RegExMatch(path, "([0-9]{6})\\([0-9]{2})([0-9]{2})\.(.*)\.(.*)$(?CCallout)")
		{
			FileAppend("# " title "  `n", mdFile, "UTF-8")
			FileAppend("*" date "  `n", mdFile, "UTF-8")
		} else {
			FileAppend("# 待编辑  `n", mdFile, "UTF-8")
		}
	}
	Run(GEditor " " mdFile)
}

shunt(c)
{
	global GCapacities
	index := 1
	switch  c {
		case GCapacities[index++]:
			Run "Calc"
		case GCapacities[index++]:
			Run "explorer " getPath()                          
		case GCapacities[index++]:
			editMarkdown getPath()
		case GCapacities[index++]:
			A_Clipboard := getPath()
		case GCapacities[index++]:
			A_Clipboard := StrReplace(getPath(), "\", "\\")
		case GCapacities[index++]:
			A_Clipboard := StrReplace(getPath(), "\", "/")
		case GCapacities[index++]:
			Run "cmd /s /k cd " getPath()
		case GCapacities[index++]:
			Run GGitBash " --cd=" getPath()
		case GCapacities[index++]:
			Reload
		default:
			Msgbox undefined
	}
	Return
}

itemClick(params*)
{
	params[1].Gui.Hide()
	shunt(params[1].Text)
	Return
}

menuHandler(Item, *) {
	shunt(Item)
	Return
}

main(args*)
{
	global GGuiUniTitle
	global GTimeout
	global GCapacities
	switch args[1]
	{
		case "custom-gui":
			if not WinExist(GGuiUniTitle)
			{
				ItemsGui := Gui(GGuiComOpt, GGuiUniTitle)
				ItemsGui.MarginX := ItemsGui.MarginY := xpos := ypos := 0
				Loop parse, GMenuItems, "`n`r"
					ItemsGui.Add("Button", "w260 h30", A_LoopField).OnEvent("Click", itemClick)
				MouseGetPos &xpos, &ypos
				ItemsGui.Show("x" xpos " y" ypos)
				SetTimer(()=>(ItemsGui.Destroy()), -GTimeout)
			}
		case "custom":
			MyMenu := Menu()
			Loop parse, GMenuItems, "`n`r"
				MyMenu.Add A_LoopField, menuHandler
			MyMenu.show
		case "built-in":
			MyMenu := Menu()
			index := 1
			MyMenu.Add GCapacities[index++], menuHandler
			MyMenu.Add GCapacities[index++], menuHandler
			MyMenu.Add GCapacities[index++], menuHandler
			MyMenu.Add
			Submenu1 := Menu()
			Submenu1.Add GCapacities[index++], menuHandler
			Submenu1.Add GCapacities[index++], menuHandler
			Submenu1.Add GCapacities[index++], menuHandler
			MyMenu.Add "复制路径", Submenu1
			MyMenu.Add
			Submenu2 := Menu()
			Submenu2.Add GCapacities[index++], menuHandler
			Submenu2.Add GCapacities[index++], menuHandler
			MyMenu.Add "命令行界面", Submenu2
			MyMenu.Add
			MyMenu.Add GCapacities[index++], menuHandler
			Mymenu.show
		default:
			msgbox "缺少参数"
	}
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
    main GMButtonStyle
    Return
}

~WheelRight::
~WheelLeft::
{
	main GWheelRLStyle
	Return
}