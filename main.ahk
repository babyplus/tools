#Requires AutoHotkey v2.0
#Include "rptree.ahk"
#Include "menuBuilder.ahk"
#Include "processes.ahk"

undefined := "undefined"
null := ""
confs := {
    directoriesInI : A_Workingdir "\directories.ini",
    processesInI : A_Workingdir "\processes.ini"
}

preInspect(args)
{
    if 0 == args.length
        msgbox("Missing parameter(s).`nUsage: " A_scriptname " {<directory>...}"), exit(1)
}

scan(record, args)
{
    Loop Files, record, "F"
        FileDelete record 
    for n, param in args
        generateRepoTree(record, param)
}

generateMenu(conf, &selected, args)
{
    myMenuArray := Map()
    SectionNames := IniRead(conf)
    Loop parse, SectionNames, "`n"
        myMenuArray[A_Loopfield] := Menu()
    for n, param in args
        buildMenu(myMenuArray, conf, param, &selected)
    if args.Length > 1
    {
        rootMenu := Menu()
        for n, param in args
            rootMenu.add(param, myMenuArray[param])
        rootMenu.show()
    } else {
        myMenuArray[args[1]].show()
    }
}

exec(item)
{
    global confs
    processor := Map()
    generateMenu(confs.processesInI, &processor, ["processors"])
    if processor.has("val")
    {
        try
            %IniRead(confs.processesInI, "operators", processor["val"])%(item)
        catch
            msgbox "Operation `"" processor["val"] "`" is not defined in file " confs.processesInI "."
        
    }
}

handle(item)
{
    if InStr(FileGetAttrib(item), "D") ;git仓库，重新遍历生成新菜单目录。
        main [item]
    else                               ;普通文件，进入处理菜单进行处理。
        exec item
}

main(args)
{
    global confs
    item := Map()
    preInspect(args)
    scan(confs.directoriesInI, args)
    generateMenu(confs.directoriesInI, &item, args)
    if item.has("val")
        handle item["val"]
}

main A_Args
