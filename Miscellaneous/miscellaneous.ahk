; Allow normal CapsLock functionality to be toggled by AltGr+CapsLock:
;!CapsLock:: ; schmimae (personal) Alt+CapsLock is used by AltTab.ahk
<^>!CapsLock:: ;
   GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
   If capsstate = U
      SetCapsLockState, AlwaysOn
   Else
      SetCapsLockState, AlwaysOff
   Return


; A function to escape characters like & for use in URLs.
; uriEncode(str) {
;    f = %A_FormatInteger%
;    SetFormat, Integer, Hex
;    If RegExMatch(str, "^\w+:/{0,2}", pr)
;       StringTrimLeft, str, str, StrLen(pr)
;    StringReplace, str, str, `%, `%25, All
;    Loop
;       If RegExMatch(str, "i)[^\w\.~%/:]", char)
;          StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
;       Else Break
;    SetFormat, Integer, %f%
;    Return, pr . str
; }

; schmimae New method for URI encoding, as the other one did not work correctly
; From https://www.reddit.com/r/AutoHotkey/comments/39gjam/what_are_your_favorite_ahk_tricks/
uriEncode(Uri) {
   VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
   StrPut(Uri, &Var, "UTF-8")
   f := A_FormatInteger
   Res := ""
   SetFormat, IntegerFast, H
   While Code := NumGet(Var, A_Index - 1, "UChar")
      If (Code >= 0x30 && Code <= 0x39 ; 0-9
         || Code >= 0x41 && Code <= 0x5A ; A-Z
         || Code >= 0x61 && Code <= 0x7A) ; a-z
         Res .= Chr(Code)
      Else
         Res .= "%" . SubStr(Code + 0x100, -1)
   SetFormat, IntegerFast, %f%
   Return, Res
}
