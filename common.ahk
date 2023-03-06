#Requires AutoHotkey v2.0

setValueViaGui(&variable, &inputGui)
{
    variable := ""
    inputGui.Show()
    Loop
    {
        if variable
        {
            inputGui.Hide
            Return variable
        }
        sleep 500
    }
    Return
}
