#Requires AutoHotkey v2.0
#NoTrayIcon

GConf := A_workingdir "/config.ini"
GItems := IniRead(GConf, "items")
GCustomGuiButton := IniRead(GConf, "custom-gui", "button", "w120 h20")
GCustomGuiFont := IniRead(GConf, "custom-gui", "font", "s10")
GTimeout := IniRead(GConf, "default", "timeout", 5000)
GGuiComOpt := "-Caption +AlwaysOnTop +LastFound"
Items := Map()
ItemsGui := Gui(GGuiComOpt)
ItemsGui.MarginX := ItemsGui.MarginY := xpos := ypos := 0
ItemsGui.setFont(GCustomGuiFont)

Loop parse, GItems, "`n`r"
    str := A_LoopField, pos := Instr(str, "="), Items[SubStr(str, 1, pos-1)] := SubStr(str, pos+1, StrLen(str)-pos)

for k,_ in Items
    ItemsGui.Add("Button", GCustomGuiButton, k).OnEvent("Click", (_*)=>(ItemsGui.Hide(), Run(Items[_[1].Text]), ItemsGui.Destroy()))

MouseGetPos &xpos, &ypos
ItemsGui.show("x" xpos " y" ypos)
SetTimer(()=>(ItemsGui.Destroy()), -GTimeout)
