#Requires AutoHotkey v2.0
#SingleInstance force

未定义 := "未定义"
空值 := ""
配置 := "配置.ini"
编辑器 := IniRead(配置, "缺省值", "编辑器", "notepad")
一小会儿 := IniRead(配置, "缺省值", "一小会儿", 3000)
要步进 := IniRead(配置, "缺省值", "要步进", false)
图库1 := IniRead(配置, "图库1")
记事本标题 := "无标题 - 记事本 ahk_class Notepad ahk_exe notepad.exe"

打开(程序)
{
    return Run(程序)
}

按图索骥(&横坐标, &竖坐标, 左上角x, 左上角y, 右下角x, 右下角y, 图片)
{
    ret := ImageSearch(&横坐标, &竖坐标, 左上角x, 左上角y, 右下角x, 右下角y, 图片)
    if 0 == ret 
        msgbox "没找到目标"
}

主程序()
{
    打开(编辑器)
    sleep 一小会儿
    目标坐标x := 目标坐标y := 0
    左上角x := 左上角y := -100
    右下角x := 右下角y := 1000
    图片 := "5.png"
    按图索骥(&目标坐标x, &目标坐标y, 左上角x, 左上角y, 右下角x, 右下角y, 图片)
    msgBox 目标坐标x "," 目标坐标y
}

主程序