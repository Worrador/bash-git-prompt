#Persistent
SetTitleMatchMode, 2  ; Partial title match mode
SetTimer, CheckMousePosition, 100  ; Check mouse position every 100ms

hoverStartTime := 0   ; Variable to track the hover start time
hoverDuration := 1000  ; Hover duration in milliseconds (3 seconds)
hoverThreshold := 20   ; Hover region threshold

return

CheckMousePosition:
; Check if the window exists using the class name "mintty"
IfWinExist, ahk_class mintty
{
    ; Get the window position and dimensions
    WinGetPos, winX, winY, winWidth, winHeight, ahk_class mintty

    ; Get current mouse position
    MouseGetPos, mouseX, mouseY

    ; Check if mouse is near the window edges (within the threshold)
    if ((mouseY < hoverThreshold && mouseY > -hoverThreshold/2) && (mouseX < winWidth && mouseX > 0))
    {
        ; If the hover hasn't started yet, record the start time
        if (hoverStartTime == 0)
        {
            hoverStartTime := A_TickCount
        }
        ; If the mouse has been in the region for the hoverDuration (3 seconds)
        else if (A_TickCount - hoverStartTime >= hoverDuration)
        {
            ; Re-add the window borders if the timer completes and mouse is still in the region
            WinSet, Style, +0xC40000, ahk_class mintty
        }
    }
    else
    {
        ; If the mouse leaves the region, reset the hover timer and remove the borders
        hoverStartTime := 0
        WinSet, Style, -0xC40000, ahk_class mintty
    }
}
return
