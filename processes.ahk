#Requires AutoHotkey v2.0
#include "common.ahk"

notepad(item)
{
    Run "notepad " item
}

create(conf)
{
    if not conf
       return
    dir := ""
    fname := ""
    SplitPath(conf, &fname, &dir)
    if not "新建" == fname
        return
    period := IniRead(conf, "period")
    title := null
    titleGui := Gui()
    titleGui.Add("Text", "w80 x10", "起始时间：")
    titleGui.Add("Edit", "w80 x+10 vBegin Number Limit08")
    titleGui.Add("Text", "w80 x10 y+10", "结束时间：")
    titleGui.Add("Edit", "w80 x+10 vEnd Number Limit08")
    titleGui.Add("Edit", "w170 x10 y+10 vTitle", "事件名称")
    titleGui.Add("Button", "x100 y+10 w80", "确定")
    .OnEvent("click", (_*)=>(
        title := _[1].Gui["Title"].value
    ))
    setValueViaGui(&title, &titleGui)
    mdFile := (dir "\" StrReplace((titleGui["Begin"].value ? titleGui["Begin"].value : "unknown")
                        "_to_"
                        (titleGui["End"].value ? titleGui["End"].value : "unknown")
                        "_" title, "_to_unknown", null))
    if !FileExist(mdFile)
    {
        FileAppend("# " title "  `n`n", mdFile, "UTF-8")
    }
    Run("notepad " mdFile)
    titleGui.Destroy()
}

