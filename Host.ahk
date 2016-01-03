; Created by Asger Juul Brunshøj
; Modified by Michael Schmidt-Korth

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#SingleInstance
#SingleInstance force SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SetCapsLockState, AlwaysOff

; #InstallKeybdHook

;-------------------------------------------------------
; AUTO EXECUTE SECTION FOR INCLUDED SCRIPTS
; Scripts being included need to have their auto execute
; section in a function or subroutine which is then
; executed below.
;-------------------------------------------------------
main()
;-------------------------------------------------------
; END AUTO EXECUTE SECTION
Return
;-------------------------------------------------------

; Load the GUI code
#Include %A_ScriptDir%\GUI\GUI.ahk

; General settings
#Include %A_ScriptDir%\Miscellaneous\miscellaneous.ahk

main() {
	Menu, Tray, Icon, %A_ScriptDir%\Icon.ico ; schmimae: Change systray icon
	gui_autoexecute()
}
