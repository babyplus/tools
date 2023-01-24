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
    Exit: 100
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
GHotkeysMap := Map()
GConf := "config.ini"
GEditor := IniRead(GConf, "default", "editor", "notepad")
GIcon := IniRead(GConf, "default", "icon", "icon.png")
GReloadMode := IniRead(GConf, "default", "reload", "Flase")
GGitBash := IniRead(GConf, "default", "git", null)
GTimeout := IniRead(GConf, "default", "timeout", 5000)
GKeysMenuDelayStyle := IniRead(GConf, "default", "keys_menu_delay", "custom")
GKeysMenuStyle := IniRead(GConf, "default", "keys_menu", "built-in")
GCustomItems := IniRead(GConf, "custom-items")
GSubjects := IniRead(GConf, "subjects")
GCustomGuiButton := IniRead(GConf, "custom-gui", "button", "w260 h30")
GHotkeys := IniRead(GConf, "hotkeys")

if FileExist(GIcon)
    TraySetIcon GIcon
GLatestModTimestamps := Map()
GGuiComOpt := "-Caption +AlwaysOnTop +LastFound"
GGuiUniTitle := "shortcuts_" A_NowUTC
GKeysMenu:= IniRead(GConf, "keys_menu")
GKeysMenuDelay:= IniRead(GConf, "keys_menu_delay")

;;;;;;;;;;;;
;; Action ;;
;;;;;;;;;;;;
Loop parse, GKeysMenu, "`n`r"
    Hotkey A_LoopField, keysMenu
Loop parse, GKeysMenuDelay, "`n`r"
    Hotkey A_LoopField, keysMenuDelay
hotkeys


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

elof(el, els)
{
    for k,v in els
        if ! StrCompare(el, v)
            return false
    return true
}

setSubject(&variable, &subject, _*)
{
    global GSubjects, GGuiComOpt, GGuiUniTitle 
    fileList := ""
    arr := []
    Loop parse, GSubjects, "`n`r"
        arr.Push(A_LoopField)
    Loop Files, A_WorkingDir "\" _[1] "\" _[2] ".*", "D"
    {
        temp := StrReplace(A_LoopFileName, _[2] ".", null)
        fileList .= Substr(temp, 1, Instr(temp, '.')-1) "`n"
    }
    Loop parse, fileList, "`n`r"
        if A_LoopField and elof(A_LoopField, arr)
            arr.Push(A_LoopField)
    subjectGui := Gui(GGuiComOpt, GGuiUniTitle)
    subjectGui.Add("DropDownList", "y10 w180", arr)
    .OnEvent("change", (_*)=>(variable.type := types.Ingnore, subject := arr[_[1].value]))
    subjectGui.Add("Edit", "w80 x+10 vContent", "新临时分类")
    subjectGui.Add("Button", "x+10 w80", "确定")
    .OnEvent("click", (_*)=>(
        variable.type := types.Ingnore, subject := StrReplace(_[1].Gui["Content"].value, "`n", null)
    ))
    setValueViaGui(&variable, &subjectGui)
}

setTitle(&variable, &title, _*)
{
    global GuiComOpt, GGuiUniTitle 
    fileList := ""
    titles := []
    Loop Files, A_WorkingDir "\" _[1] "\" _[2] "." _[3] ".*", "D"
        fileList .= StrReplace(A_LoopFileName, _[2] "." _[3] ".", null) "`n"
    Loop Parse, fileList, "`n"
        if A_LoopField
            titles.push(A_LoopField)
    titleGui := Gui(GGuiComOpt, GGuiUniTitle)
    titleGui.Add("Edit", "w160 h200 vContent", "今日记录")
    titleGui.Add("ListBox", "w160 h200 x+10 vTitle", titles)
    .OnEvent("change", (_*)=>(variable.type := types.Ingnore, title := titles[_[1].Gui["Title"].value]))
    titleGui.Add("Button", "x10 w80", "确定")
    .OnEvent("click", (_*)=>(
        variable.type := types.Ingnore, title := StrReplace(_[1].Gui["Content"].value, "`n", null)
    ))
    titleGui.Add("Button", "x+10 w80", "关闭")
    .OnEvent("click", (_*)=>(variable.type := types.Exit))
    setValueViaGui(&variable, &titleGui)
}

splicePath(_*)
{
    arr := [A_WorkingDir,  _[1], _[2], _[3], _[4]]
    return Format("{}\{}\{}.{}.{}", arr*)
}

setCustomPath(&path, &variable)
{
    global GuiComOpt, GGuiUniTitle 
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
    global GPastEntriesSorted, GGuiComOpt, GGuiUniTitle 
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
    global GPastEntriesSorted, GPastEntries
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

selectPathViaGui()
{
    global GPastEntries, GGuiComOpt, GGuiUniTitle
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
    mixGui.Add("Button", "x+10 y10", "昨日")
    .OnEvent("click", (_*)=>(variable.type := types.DateTime, variable.val := DateAdd(A_Now, -1, "days")))
    mixGui.Add("Button", "x10 y+10", "默认路径")
    .OnEvent("click", (_*)=>(variable.type := types.Ingnore))
    mixGui.Add("Button", "x+10", "自定义项目")
    .OnEvent("click", (_*)=>(variable.type := types.Custom))
    mixGui.Add("Button", "x+10", "上次选定")
    .OnEvent("click", (_*)=>(variable.type := types.LatestSelected))
    mixGui.Add("Button", "x+10", "历史")
    .OnEvent("click", (_*)=>(variable.type := types.History))
    mixGui.Add("Button", "x+10", "关闭")
    .OnEvent("click", (_*)=>(variable.type := types.Exit))
    
    switch setValueViaGui(&variable, &mixGui).type
    {
         case types.DateTime:
             yearMon := SubStr(variable.val, 1, 6)
             monDay := SubStr(variable.val, 5, 4)
             title := null
             setSubject(&variable, &subject, yearMon, monDay)
             setTitle(&variable, &title, yearMon, monDay, subject)
             path := splicePath(yearMon, monDay, subject, title)
         case types.Custom:
             setCustomPath(&path, &variable)
         case types.History:
             selectHistoryEntry(&path, &variable)
         case types.LatestSelected:
             selectLatestEntry(&path)
         default:
    }

    if types.Exit == variable.type
        return null
    
    path := null == path ? A_WorkingDir : path
    record(path, &GPastEntries, sortEntries)
    If !FileExist(path)
        DirCreate path
    return path
}

setPath(&path)
{
    path := selectPathViaGui()
    return null == path ? false : true
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
    path := null
    index := 1
    switch  c {
        case GCapacities[index++]:
	    Run "Calc"
        case GCapacities[index++]:
            if setPath(&path)
                Run "explorer " path
        case GCapacities[index++]:
            if setPath(&path)
                editMarkdown path
        case GCapacities[index++]:
            if setPath(&path)
                A_Clipboard := path
        case GCapacities[index++]:
            if setPath(&path)
                A_Clipboard := StrReplace(path, "\", "\\")
        case GCapacities[index++]:
            if setPath(&path)
                A_Clipboard := StrReplace(path, "\", "/")
        case GCapacities[index++]:
            if setPath(&path)
                Run "cmd /s /k cd " path
        case GCapacities[index++]:
            if setPath(&path)
                Run GGitBash " --cd=" path
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

menuHandler(Item, *)
{
    shunt(Item)
    Return
}

main(args*)
{
    global GGuiComOpt,GGuiUniTitle, GTimeout, GCapacities, GCustomItems, GCustomGuiButton
    switch args[1]
    {
        case "custom-gui":
            if not WinExist(GGuiUniTitle)
            {
                ItemsGui := Gui(GGuiComOpt, GGuiUniTitle)
                ItemsGui.MarginX := ItemsGui.MarginY := xpos := ypos := 0
                Loop parse, GCustomItems, "`n`r"
                    ItemsGui.Add("Button", GCustomGuiButton, A_LoopField).OnEvent("Click", itemClick)
                MouseGetPos &xpos, &ypos
                ItemsGui.Show("x" xpos " y" ypos)
                SetTimer(()=>(ItemsGui.Destroy()), -GTimeout)
            }
        case "custom":
            MyMenu := Menu()
            Loop parse, GCustomItems, "`n`r"
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

keysMenuDelay(args*)
{
    global GMouseDelay, GKeysMenuDelayStyle
    key := RegExReplace(args[1], "[^a-zA-Z\d]", null)
    duration := 0
    Loop
    {
        duration += 1
        Sleep 10
        if !GetKeyState(key, "P")
            break
    }
    if duration < GMouseDelay
        Return
    main GKeysMenuDelayStyle
    Return
}

keysMenu(args*)
{
    global GKeysMenuStyle
    main GKeysMenuStyle
    Return
}

hotkeys()
{
    global GHotkeys, GHotkeysMap
    Loop parse, GHotkeys, "`n`r"
    {
        kv := StrSplit(A_LoopField, "=")
        GHotkeysMap[kv[1]] := kv[2]
        hotkey kv[1], (_)=>(send(GHotkeysMap[_]))
    }
}
