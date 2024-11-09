+Esc::Send("0")  ; Maps Shift + Escape to output the character "0"

; Windows key + G hotkey to open Git Bash
^g:: {
    ; Check if Git Bash is already running
    if WinExist("ahk_class mintty") {
        WinActivate  ; Activate the existing window
    } else {
        ; Adjust the path below to match your Git Bash installation
        Run 'D:\Git\git-bash.exe'
        WinWait "ahk_class mintty"  ; Wait for the window to appear
        WinActivate
    }
}