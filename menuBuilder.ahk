#Requires AutoHotkey v2.0

buildMenu(target, conf, root, &selected)
{
    column := {
        type: 1,
        val:  2
    }
    items := IniRead(conf, root)
    Loop parse, items, "`n`r"
    {
        row := StrSplit(A_LoopField, " ")
        fullPath := row[column.val]
        title := StrSplit(fullPath, "\")[-1]
        if "F" == row[column.type] or "R" == row[column.type] or "P" == row[column.type]
            if not ".type" == title
                target[root].add(fullPath, (_*)=>(selected["val"] := _[1]))
        if "D" == row[column.type]
        {
            target[root].add(title, target[fullPath])
            buildMenu(target, conf, row[column.val], &selected)
        }
    }
}

