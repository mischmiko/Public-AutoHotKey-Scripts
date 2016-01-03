; Created by Asger Juul Brunshøj
; Modified by Michael Schmidt-Korth

;-------------------------------------------------------
; AUTO EXECUTE
;-------------------------------------------------------
gui_autoexecute() {
    global

    #WinActivateForce

    ; Tomorrow Night Color Definitions:
    cBackground  := "c" . "1d1f21"
    cCurrentLine := "c" . "282a2e"
    cSelection   := "c" . "373b41"
    cForeground  := "c" . "c5c8c6"
    cComment     := "c" . "969896"
    cRed         := "c" . "cc6666"
    cOrange      := "c" . "de935f"
    cYellow      := "c" . "f0c674"
    cGreen       := "c" . "b5bd68"
    cAqua        := "c" . "8abeb7"
    cBlue        := "c" . "81a2be"
    cPurple      := "c" . "b294bb"

    gui_control_options  := "xm w220 " . cForeground . " -E0x200" ; -E0x200 removes border around Edit controls
    gui_control_options2 := "x10 y55 w220 " . cForeground . " -E0x200" ; schmimae Just for "readjusting" the GUI
}

;-------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------
; CapsLock & Space:: ; schmimae
#Y::
    IfWinNotExist, myGUI
    {
        gui_spawn()
    } Else
    {
        gui_destroy()
    }
    Return

gui_spawn() {
    global
    Gui, Margin, 16, 16
    Gui, Color, 1d1f21, 282a2e
    Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption +Border

    ; Define header
    Gui, Font, s11 , Segoe UI
    ; %gui_control_options%  just pastes the content of the variable - defines x and y size and color
    Gui, Add, Text, %gui_control_options% vgui_main_title, ¯\_(ツ)_/¯               %A_IPAddress1%

    ; Define list of possible commands
    Gui, Font, %cOrange% ; Change text color for next GUI action
    Gui, Add, Text, x10 w220 vgui_foundCommand, %A_Space% ; Create GUI element: Display text " " (last parameter), and store in variable gui_foundCommand. We define the width of the text field the same as for gui_control_options, so we have enough space for showing possible commands.

    ; Define input
    Gui, Font, s10, Segoe UI
    ; The gFindus is a g-label / goSub - launches the subroutine upon action
    Gui, Add, Edit, %gui_control_options% vCommand gFindus
    Gui, Show,, myGUI
}

;-------------------------------------------------------
; GUI FUNCTIONS
;-------------------------------------------------------
; Automatically triggered on Escape key:
GuiEscape:
    gui_destroy()
    Return

; The callback function when the text changes in the input field.
Findus:
    Gui, Submit, NoHide
    ;Tooltip,Input (findus) = %Command%,500,500,3 ; Command = from vCommand, somehow
    gui_cmdLibrary("search", Command)
    #Include %A_ScriptDir%\GUI\UserCommands.ahk
    Return

gui_destroy() {
    gui_tooltip_clear()
    gui_search_reset()
    Gui, Destroy ; Hide GUI
    WinActivate ; Bring focus back to another window found on the desktop
    Return
}

gui_change_title(message,color = "") {
    ; If parameter color is omitted, the message is assumed to be an error message.
    If color =
    {
        global cRed
        color := cRed
    }
    GuiControl,, gui_main_title, %message%
    Gui, Font, s11 %color%
    GuiControl, Font, gui_main_title
    Gui, Font, s10 cffffff ; reset
}

;-------------------------------------------------------
; SEARCH ENGINES
;-------------------------------------------------------

gui_search() {
    global
    ; Gui, Add, Text, %gui_control_options% %cYellow%, %gui_search_title% ; schmimae
    Gui, Add, Edit, %gui_control_options2% %cOrange% vgui_SearchEdit -WantReturn ; schmimae: Use gui_control_options2 to move the edit box up (over command suggestions) so all irrelevant content is hidden
    If Command = +
	    Gui, Add, Button, x-10 y-10 w1 h1 +default ggui_CalcEnter
	Else
	    Gui, Add, Button, x-10 y-10 w1 h1 +default ggui_SearchEnter ; hidden button
    ; Disable input of cmd box as we now need a parameter
    ;GuiControl, Disable, Command
    GuiControl, Hide, Command ; schmimae remove inputted line, is not relevant, title is enough. Unfortunately, there is no "Destroy" sub command
    Gui, Show, AutoSize
    gui_change_title(gui_search_title, cForeground) ; schmimae Change Title to search
    Return
}

gui_SearchEnter:
    Gui, Submit
    query_safe := uriEncode(gui_SearchEdit)
    StringReplace, gui_search_new_url, gui_search_url, REPLACEME, %query_safe%
    run %gui_search_new_url%
    gui_destroy()
    Return

gui_search_reset() {
    global
    gui_search_title =
    gui_search_url =
    gui_tooltip_clear()
    Return
}

; calculate() {
;     global
;     If Command = rechn
;     	MsgBox 1111111111111111111111111111111111111%Command%

;     ; Gui, Add, Text, %gui_control_options% %cYellow%, %gui_search_title% ; schmimae
;     Gui, Add, Edit, %gui_control_options2% %cYellow% vgui_SearchEdit -WantReturn ; schmimae: Use gui_control_options2 to move the edit box up (over command suggestions) so all irrelevant content is hidden
;     Gui, Add, Button, x-10 y-10 w1 h1 +default ggui_CalcEnter ; hidden button
;     ; Disable input of cmd box as we now need a parameter
;     ;GuiControl, Disable, Command
;     GuiControl, Hide, Command ; schmimae remove inputted line, is not relevant, title is enough. Unfortunately, there is no "Destroy" sub command
;     Gui, Show, AutoSize
;     gui_change_title(gui_search_title, cForeground) ; schmimae Change Title to search
;     Return
; }

gui_CalcEnter:
    Gui, Submit
    ; Calculator. We can use MsgBox 1+1 to do calculations, but we cannot convert the user's string input to a math expression. For this we use Calculator.ahk
    #Include %A_ScriptDir%\Miscellaneous\Calculator.ahk

	MsgBox % eval(gui_searchEdit)

    gui_destroy()
    Return

;-------------------------------------------------------
; TOOLTIP
;-------------------------------------------------------
gui_tooltip_clear() {
    ToolTip
    Return
}

; If mode = search (1): Only search for matching cmd
; If mode = help (2): Display all commands in tooltip
gui_cmdLibrary(mode, input:="") { ; input is an optional parameter, only for mode 1
    If ("" . mode = "help") {
        ; Hidden GUI used to pass font options to tooltip:
        CoordMode, Tooltip, Screen ; To make sure the tooltip coordinates is displayed according to the screen and not active window
        ; No longer works with Win10
        ; Gui, 2:Font,s10, Lucida Console
        ; Gui, 2:Add, Text, HwndhwndStatic

        tooltiptext =
        maxpadding = 0
    }

    StringCaseSense, Off ; Matching case insensitive for "If" (e.g. "if command")

    If ("" . mode = "search") {
        If input = ; Ignore empty input
        {
            GuiControl,, gui_foundCommand, %A_Space% ; last parameter = empty text
            Return
        }
        ; Tooltip,Input is: %input%,700,700,3 ; Command = from vCommand, somehow

        allCommands := Object()
    }
    Loop, read, %A_ScriptDir%/GUI/UserCommands.ahk
    {
        ; search for the string If Command =, but search for each word individually because spacing between words might not be consistent. (might be improved with regex)
        If Substr(A_LoopReadLine, 1, 1) != ";" ; Do not display commented commands
        {
            If A_LoopReadLine contains If Command =
            {
                ;Tooltip A_LoopReadLine, 3,3,1
                    StringGetPos, setpos, A_LoopReadLine,=
                    StringTrimLeft, trimmed, A_LoopReadLine, setpos+1 ; trim everything that comes before the = sign
                    StringReplace, trimmed, trimmed, `%A_Space`%, {space}, All ; Replace %A_Space% with "{space}"
                    StringReplace, trimmed, trimmed, " ", "", All
                    StringSplit, new_array, trimmed, ";", .  ; Omits periods.
                    ; Padding does not work, as we cannot use a monospaced font (defined by Windows). Furthermore, padding is already done - see tooltiptextpadded
                    ; padding =
                    ; StringLen, lengthCmd, new_array1 ; Assign length of new_array to lengthCmd
                    ; necPadding := 20 - lengthCmd
                    ; ; ToolTip %lengthCmd%, 700, 700, 1
                    ; ; Sleep 1000
                    ; If (necPadding > 0) {
                    ;     ; ToolTip Cmd has %lengthCmd% but we need %necPadding%, 700, 700, 1
                    ;     ; Sleep 1000
                    ;     Loop, %necPadding% {
                    ;         padding .= "X"
                    ;     }
                    ; }

                    If Substr(new_array1, 2, 1) != "?" ; Do not display "?" command
                    {
                        allCommands.Insert(new_array1) ; add command to list of all valid commands

                        If ("" . mode = "help") {
                            tooltiptext .= new_array1 "     " new_array2
                            tooltiptext .= "`n"

                            ; TestString = This is a test.
                            ; StringSplit, word_array, TestString, %A_Space%, .  ; Omits periods.
                            ; MsgBox, The 4th word issssssssssssssssssssssssssssss %word_array4%.

                            ; sARray := StrSplit(trimmed, A_Space, ";")
                            ; ToolTip %A_Space0%, 700, 700, 1
                            ; Sleep 1000

                            ; StringSplit, new_array, trimmed, ";", .  ; Omits periods.
                            ; ToolTip %new_array1%    %new_array2%, 700, 700, 1
                            ; Sleep 1000
                        }
                    }

                    If ("" . mode = "help") {
                        ; The following is used to correct padding:
                        StringGetPos, commentpos, trimmed,`;
                        If (maxpadding < commentpos)
                            maxpadding := commentpos
                    }
            }
        }
    }
    ; Built the list of all valid commands (allCommands), now lets loop over this
    If ("" . mode = "search") {
        StringLen, lenInput, input ; Assign length of input to lenInput
        For index, currCmd In allCommands ; Loop over all cmds
        {
            ; If input = x chars, then get the first x chars of the current cmd
            currFoundCmdWithSameLengthAsInput := Substr(currCmd, 2, lenInput) ; First char is a space, ignore

            ;Tooltip,input = %input%,500,500,2 ; Command = from vCommand, somehow
            ;Tooltip,currFoundCmdWithSameLengthAsInput = %currFoundCmdWithSameLengthAsInput%,500,550,3 ; Command = from vCommand, somehow

            If ("" . currFoundCmdWithSameLengthAsInput = input) ; Check if current typed chars are the beginning of a valid cmd
            {
                StringReplace, currCmd, currCmd, {space}, (), All ; Replace %A_Space% with "{space}"
                listofPossibleCommands .= currCmd ; Add current comands to list of possible commands
                ;msgbox Input=.%input%.Adding to listofPossibleCommands=.%currCmd%. so the list is now %listofPossibleCommands%
                ; Tooltip,Possible command: %currCmd%,500,600,4 ; Command = from vCommand, somehow
            }
            ; MsgBox "XXXXXXXXXXXXXXX Current currCmd: ."%currCmd%". Input: ."%input%". Length of input: "%lenInput%
        }

        If StrLen(listofPossibleCommands) > 0 { ; Otherwise no matching command was found
            ; listofPossibleCommands .= "?"
            GuiControl,, gui_foundCommand, %listofPossibleCommands%? ; Modify contents of vgui_foundCommand (beware: without v, see https://autohotkey.com/docs/commands/Gui.htm#Events). The second parameter is separated by a space (" "), anything added after with another space will be ignored. Beware: better don't add anything after the var, will lead to strange results
            ; Beware also: If results are too wide (too many characters), they are cut off. If you change a GuiControl, it cannot be any wider than as it was defined

            gui_completeInput(listofPossibleCommands)
        }

        listofPossibleCommands =  ; Clear for next input character
    } Else If ("" . mode = "help") {
        tooltiptextpadded =
        Loop, Parse, tooltiptext,`n
        {
            line = %A_LoopField%
            StringGetPos, commentpos, line, `;
            spaces_to_insert := maxpadding - commentpos
            Loop, %spaces_to_insert%
            {
                StringReplace, line, line,`;,%A_Space%`;
            }
            tooltiptextpadded .= line
            tooltiptextpadded .= "`n"
        }
        Sort, tooltiptextpadded

        ; The following allows the tooltip to display in a monospace font (uses GUI3 defined above)
        ; No longer works with Win10
        ; SendMessage, 0x31,,,, ahk_id %hwndStatic%
        ; font := ErrorLevel
        ToolTip %tooltiptextpadded%, 3, 3, 1

    ;    SendMessage, 0x30, font, 1,, ahk_class tooltips_class32 ahk_exe autohotkey.exe
    }

    Return
}

; Checks listofPossibleCommands if it only contains 1 possible command.
; If yes, replace current input with found command.
gui_completeInput(listofPossibleCommands) {
    StringSplit, possibleCmdsArray, listofPossibleCommands, %A_Space% ; split by spaces - it looks like [1]{ }cmd[2]{ }?[3] ({ } = space)
    If possibleCmdsArray0 = 3 ; only 1 cmd found, so we can complete it
    {
        listofPossibleCommands := Substr(listofPossibleCommands, 2, StrLen(listofPossibleCommands)-2) ; -2 as we have a leading and trailing space
        If listofPossibleCommands contains () ; If cmd awaits input, remote () to allow for adding a space (see below)
        {
            cmdAwaitsFurtherInput = true
            StringReplace, listofPossibleCommands, listofPossibleCommands, (), , All
        }
        GuiControl,, Command, %listofPossibleCommands% ; replace command input with completed command
        If cmdAwaitsFurtherInput = true ; Add space for commands with ()
        {
            Send, {End}
            Send, {Space}
        }
    }
}

; gui_commandlibrary() {
;     ; hidden GUI used to pass font options to tooltip:
;     CoordMode, Tooltip, Screen ; To make sure the tooltip coordinates is displayed according to the screen and not active window
;     Gui, 2:Font,s10, Lucida Console
;     Gui, 2:Add, Text, HwndhwndStatic

;     tooltiptext =
;     maxpadding = 0
;     StringCaseSense, Off ; Matching to both if/If in the IfInString command below
;     allCommands := Object()
;     Loop, read, %A_ScriptDir%/GUI/UserCommands.ahk
;     {
;         ; search for the string If Command =, but search for each word individually because spacing between words might not be consistent. (might be improved with regex)
;         If Substr(A_LoopReadLine, 1, 1) != ";" ; Do not display commented commands
;         {
;             If A_LoopReadLine contains If
;             {
;                 ;Tooltip A_LoopReadLine, 3,3,1
;                 IfInString, A_LoopReadLine, Command
;                 {
;                     IfInString, A_LoopReadLine, =
;                     {
;                         StringGetPos, setpos, A_LoopReadLine,=
;                         StringTrimLeft, trimmed, A_LoopReadLine, setpos+1 ; trim everything that comes before the = sign
;                         StringReplace, trimmed, trimmed, `%A_Space`%, {space}, All ; Replace %A_Space% with "{space}"
;                         StringReplace, trimmed, trimmed, " ", "", All
;                         StringSplit, new_array, trimmed, ";", .  ; Omits periods.
;                         ; Padding does not work, as we cannot use a monospaced font (defined by Windows). Furthermore, padding is already done - see tooltiptextpadded
;                         ; padding =
;                         ; StringLen, lengthCmd, new_array1 ; Assign length of new_array to lengthCmd
;                         ; necPadding := 20 - lengthCmd
;                         ; ; ToolTip %lengthCmd%, 700, 700, 1
;                         ; ; Sleep 1000
;                         ; If (necPadding > 0) {
;                         ;     ; ToolTip Cmd has %lengthCmd% but we need %necPadding%, 700, 700, 1
;                         ;     ; Sleep 1000
;                         ;     Loop, %necPadding% {
;                         ;         padding .= "X"
;                         ;     }
;                         ; }

;                         If Substr(new_array1, 2, 1) != "?" ; Do not display "?" command
;                         {
;                             tooltiptext .= new_array1 "     " new_array2
;                             tooltiptext .= "`n"
;                             allCommands.Insert(new_array1)
;                         }

;                         ; TestString = This is a test.
;                         ; StringSplit, word_array, TestString, %A_Space%, .  ; Omits periods.
;                         ; MsgBox, The 4th word issssssssssssssssssssssssssssss %word_array4%.

;                         ; sARray := StrSplit(trimmed, A_Space, ";")
;                         ; ToolTip %A_Space0%, 700, 700, 1
;                         ; Sleep 1000

;                         ; StringSplit, new_array, trimmed, ";", .  ; Omits periods.
;                         ; ToolTip %new_array1%    %new_array2%, 700, 700, 1
;                         ; Sleep 1000

;                         ; The following is used to correct padding:
;                         StringGetPos, commentpos, trimmed,`;
;                         If (maxpadding < commentpos)
;                         {
;                             maxpadding := commentpos
;                         }
;                     }
;                 }
;             }
;         }
;     }
;     tooltiptextpadded =
;     Loop, Parse, tooltiptext,`n
;     {
;         line = %A_LoopField%
;         StringGetPos, commentpos, line, `;
;         spaces_to_insert := maxpadding - commentpos
;         Loop, %spaces_to_insert%
;         {
;             StringReplace, line, line,`;,%A_Space%`;
;             continue
;         }
;         tooltiptextpadded .= line
;         tooltiptextpadded .= "`n"
;     }
;     Sort, tooltiptextpadded

;     ; The following allows the tooltip to display in a monospace font (uses GUI3 defined above)
;     SendMessage, 0x31,,,, ahk_id %hwndStatic%
;     font := ErrorLevel
;     ToolTip %tooltiptextpadded%, 3, 3, 1
; ;    SendMessage, 0x30, font, 1,, ahk_class tooltips_class32 ahk_exe autohotkey.exe

;     Return
; }

; gui_allCommands(input) {
;     If input = ; Ignore empty input
;     {
;         GuiControl,, gui_foundCommand, %A_Space% ; last parameter = empty text
;         Return
;     }

;     ; Tooltip,Input is: %input%,700,700,3 ; Command = from vCommand, somehow

;     StringCaseSense, Off ; Matching to both if/If in the IfInString command below
;     allCommands := Object()
;     Loop, read, %A_ScriptDir%/GUI/UserCommands.ahk
;     {
;         If Substr(A_LoopReadLine, 1, 1) != ";"
;         {
;             If A_LoopReadLine contains If
;             {
;                 IfInString, A_LoopReadLine, Command
;                 {
;                     IfInString, A_LoopReadLine, =
;                     {
;                         StringGetPos, setpos, A_LoopReadLine,=
;                         StringTrimLeft, trimmed, A_LoopReadLine, setpos+1 ; trim everything that comes before the = sign
;                         StringReplace, trimmed, trimmed, `%A_Space`%, {space}, All ; Replace %A_Space% with "{space}"
;                         StringReplace, trimmed, trimmed, " ", "", All
;                         StringSplit, new_array, trimmed, ";", .  ; Omits periods.

;                         If Substr(new_array1, 2, 1) != "?" ; Do not display "?" command
;                         {
;                             allCommands.Insert(new_array1)
;                             StringLen, lengthCmd, input ; Assign length of new_array to lengthCmd
;                             listofPossibleCommands =
;                             For index, element In allCommands ; Loop over all cmds
;                             {
;                                 ; Tooltip,input is: %input%,700,700,2 ; Command = from vCommand, somehow

;                                 currFoundCmdWithSameLengthAsInput := Substr(element, 2, lengthCmd) ; First char is a space, ignore
;                                 ; Tooltip,currFoundCmdWithSameLengthAsInput is: %currFoundCmdWithSameLengthAsInput%,750,750,3 ; Command = from vCommand, somehow
;                                 ; msgbox "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"%currFoundCmdWithSameLengthAsInput%

;                                 If ("" . currFoundCmdWithSameLengthAsInput = input) ; Check if current typed chars are the beginning of a valid cmd
;                                 {
;                                     listofPossibleCommands .= element ; Add current comands to list of possible commands
;                                     ; Tooltip,Possible command: %element%,700,700,2 ; Command = from vCommand, somehow
;                                     GuiControl,, gui_foundCommand, %listofPossibleCommands% ? ; Modify contents of vgui_foundCommand (beware: without v, see https://autohotkey.com/docs/commands/Gui.htm#Events)
;                                 }

;                                 ; MsgBox "XXXXXXXXXXXXXXX Current element: ."%element%". Input: ."%input%". Length of input: "%lengthCmd%
;                             }
;                         }
;                     }
;                 }
;             }
;         }
;     }
; }
