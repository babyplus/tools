#Requires AutoHotkey v2.0

generateRepoTree(target, rps*)
{
    for _, rp in rps
    {
        FileAppend("[" rp "]`n", target)
        Loop Files, rp "\*", "F"
            FileAppend("F " rp "\" A_LoopFileName "`n", target)
        Loop Files, rp "\*", "D"
        {
            path := rp "\" A_LoopFileName
            if DirExist(path "\.git")
                FileAppend("R " rp "\" A_LoopFileName "`n", target)
            else
                FileAppend("D " rp "\" A_LoopFileName "`n", target)

        }
        FileAppend("`n", target)
        Loop Files, rp "\*", "D"
            if not DirExist(path "\.git")
                generateRepoTree(target, rp "\" A_LoopFileName)
    }
}

