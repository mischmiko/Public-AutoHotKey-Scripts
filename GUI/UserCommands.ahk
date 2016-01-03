; Created by Asger Juul Brunshøj
; Modified by Michael Schmidt-Korth
; Note: Save with encoding UTF-8 with BOM if possible. I had issues with special characters like in ¯\_(ツ)_/¯ that wouldn't work otherwise.

; Write your own AHK commands in this file to be recognized by the GUI. Take inspiration from the samples provided here.

If 1 = 2 ; Does not do anything. It is just here so that everything below will start with 'Else If', just so no syntax errors creep in if the order is switched or something.
{ }

; ========= SEARCH GOOGLE =========
Else If Command = g%A_Space% ; Search Google
{
    gui_search_title = Google
    gui_search_url := "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="
    gui_search()
}

; Else If Command = a%A_Space% ; Search Google for AutoHotkey related stuff
; {
;     gui_search_title = Autohotkey Google Search
;     gui_search_url := "https://www.google.com/search?num=50&safe=off&site=&source=hp&q=autohotkey%20REPLACEME&btnG=Search&oq=&gs_l="
;     gui_search()
; }
; Else If Command = l%A_Space% ; Search Google with ImFeelingLucky
; {
;     gui_search_title = I'm Feeling Lucky
;     gui_search_url := "http://www.google.com/search?q=REPLACEME&btnI=Im+Feeling+Lucky"
;     gui_search()
; }
Else If Command = x%A_Space% ; Search DuckDuckGo as Incognito
; A note on how this works:
;   The variable name "gui_search_url" is poorly chosen.
;   What you actually specify in the variable "gui_search_url" is a command to run. It does not have to be a URL
;   Before the command is run, the word REPLACEME is replaced by your input.
;   It does not have to be a search url, that was just the application I had in mind when I originally wrote it.
;   So what this does is that it runs chrome with the arguments "-incognito" and the google search URL where REPLACEME in the URL has been replaced by your input.
{
    gui_search_title = Search Incognito
    gui_search_url := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe -incognito https://duckduckgo.com/?q=REPLACEME"
    gui_search()
}

; ========= SEARCH OTHER THINGS =========

Else If Command = f%A_Space% ; Search Facebook
{
    gui_search_title = Search Facebook
    gui_search_url := "https://www.facebook.com/search/results.php?q=REPLACEME"
    gui_search()
}
Else If Command = y%A_Space% ; Search Youtube
{
    gui_search_title = Search Youtube
    gui_search_url := "https://www.youtube.com/results?search_query=REPLACEME"
    gui_search()
}
; Else If Command = t%A_Space% ; Search torrent networks
; {
;     gui_search_title = Sharing is caring
;     gui_search_url := "https://kickass.to/usearch/REPLACEME"
;     gui_search()
; }
Else If Command = / ; Open subreddit.
{
    gui_search_title := "/r/"
    gui_search_url := "https://www.reddit.com/r/REPLACEME"
    gui_search()
}
; Else If Command = kor ; Translate English to Korean
; {
;     gui_search_title = English to Korean
;     gui_search_url := "https://translate.google.com/#en/ko/REPLACEME"
;     gui_search()
; }
Else If Command = d%A_Space% ; Translate DE/EN
{
    gui_search_title = dict.cc
    gui_search_url := "http://www.dict.cc/?s=REPLACEME"
    gui_search()
}
Else If Command = serie%A_Space% ; Search Watchseries
{
    gui_search_title = Search Series
    gui_search_url := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe -incognito http://watchseries.ag/search/REPLACEME"
    gui_search()
}


; ========= LAUNCH WEBSITES AND PROGRAMS =========
Else If Command = music ; Pause/resume music
{
    gui_destroy()
    SetTitleMatchMode, 2 ; partial title matching
    If WinExist("Google Play Music") {
        WinActivate
        ControlSend,, {Space}, - Google Play Music
        ; WinMinimize ; prevents working on the second time
    } Else If WinExist("VLC") {
        WinActivate
        Send, {Media_Play_Pause}
    } Else If WinExist("Groove") {
        WinActivate
        Send, {Media_Play_Pause}
    } Else {
        Send, {LWin}
        Sleep 150
        SendRaw Groove
        Send, {Enter}
        WinActivate Groove
        Sleep 1550
        Send, {Media_Play_Pause}
    }
    Return
}
Else If Command = tab ; New browser tab
{
    gui_destroy()
    IfWinExist, ahk_class MozillaWindowClass
    {
        WinActivate
        Send, ^t
    }
}
Else If Command = face ; facebook.com
{
    gui_destroy()
    run www.facebook.com
}
Else If Command = red ; reddit.com
{
    gui_destroy()
    run www.reddit.com
}
Else If Command = cc ; Calculator - does not accept input
{
    gui_destroy()
    run calc
}
Else If Command = cal ; Google Calendar
{
    gui_destroy()
    run https://www.google.com/calendar
}
Else If Command = kp ; Keepass
{
    gui_destroy()
    run H:\KeePass\KeePass.exe
}
Else If Command = note ; New short note in Sublime
{
    gui_destroy()
    run, H:\Program Files\Sublime Text 3\sublime_text.exe newNote
}
; Else If Command = paint ; MS Paint
; {
;     gui_destroy()
;     run "C:\Windows\system32\mspaint.exe"
; }
Else If Command = maps ; Google Maps focused on Home
{
    gui_destroy()
    ; run https://www.google.com/maps/@49.4310635`,11.0431913,17`,17z
   run https://www.google.de/maps/place/Schweinauer+Hauptstrasse+68,+90441+Nuernberg/@49.4310635`,11.0431913`,17z
}
Else If Command = dest ; Google Maps destination
{
    gui_search_title = Directions from Home to...
    gui_search_url := "https://www.google.de/maps/dir/..."
    gui_search()
}

Else If Command = ib ; Open google inbox
{
    gui_destroy()
    Tooltip C = Compose`n/ = Search`ni = Home`nShift ? = Help, 1024, 768, 1
    run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe https://inbox.google.com/u/0/
    Sleep 2000
    gui_tooltip_clear()
}
Else If Command = mes ; Opens Facebook unread messages
{
    gui_destroy()
    run https://www.facebook.com/messages?filter=unread&action=recent-messages
}
Else If Command = url ; Open an URL from the clipboard (naive - will try to run whatever is in the clipboard)
{
    gui_destroy()
    run %ClipBoard%
}



; ========= INTERACT WITH THIS AHK SCRIPT =========

Else If Command = rel ; Reload this script
{
    gui_destroy() ; removes the GUI even when the reload fails
    Reload
}
Else If Command = dir ; Open the directory for this script
{
    gui_destroy()
    Run, %A_ScriptDir%
}
; Else If Command = host ; Edit host script
; {
;     gui_destroy()
;     run, notepad.exe "%A_ScriptFullPath%"
; }
Else If Command = user ; Edit GUI user commands
{
    gui_destroy()
    run, H:\Program Files\Sublime Text 3\sublime_text.exe "%A_ScriptDir%\GUI\UserCommands.ahk"
}

; =========TYPE RAW TEXT =========

Else If Command = @ ; Email address
{
    gui_destroy()
    Send, email@test.de
}
Else If Command = name ; My name
{
    gui_destroy()
    Send, Your Name
}
; Else If Command = phone ; My phone number
; {
;     gui_destroy()
;     SendRaw, +45-12345678
; }
; Else If Command = int ; LaTeX integral
; {
;     gui_destroy()
;     SendRaw, \int_0^1  \; \mathrm{d}x\,
; }
; Else If Command = logo ; ¯\_(ツ)_/¯
; {
;     gui_destroy()
;     Send ¯\_(ツ)_/¯
; }
; Else If Command = clip ; Paste clipboard content
; {
;     gui_destroy()
;     SendRaw, %ClipBoard%
; }



; ========= FOLDERS =========

Else If Command = down ; Downloads
{
    gui_destroy()
    run I:\Libraries\Downloads
}
; Else If Command = rec ; Recycle Bin
; {
;     gui_destroy()
;     Run ::{645FF040-5081-101B-9F08-00AA002F954E}
; }



; ========= MISCELLANEOUS =========

Else If Command = ping ; Ping Google
{
    gui_destroy()
    Run, cmd /K "ping -t www.google.com"
}
Else If Command = date ; What is the date?
{
    gui_destroy()
    FormatTime, date,, LongDate
    MsgBox %date%
    date =
}
Else If Command = week ; Which week is it?
{
    gui_destroy()
    FormatTime, ugenummer,, YWeek
    StringTrimLeft, ugenummertrimmed, ugenummer, 4
    MsgBox Current week is:  %ugenummertrimmed%
    ugenummer =
    ugenummertrimmed =
}
Else If Command = ? ; Tooltip with list of commands
{
    GuiControl,, Command, ; Clear the input box
    gui_cmdLibrary("help")
}
Else If Command = sound ; Toggle default sound device
{
    gui_destroy()
    toggle := !toggle
    Run, mmsys.cpl
    WinWait,Sound ; Wait for window titled "Sound"
    If toggle
    {
        ControlSend,SysListView321,{Down 7}
        TrayTip, Changed sound device, Headset, 1, 1
    }
    Else
    {
        ControlSend,SysListView321,{Down 1}
        TrayTip, Changed sound device, Teufel, 1, 1
    }
    ControlClick,&Set Default,Sound,,,,na
    ControlClick,OK,Sound,,,,na
}
Else If Command = lync ; Lync: Set "Busy"
{
    TrayTip, Changed Lync status, Busy, 1, 1
    ; Use coordinates relative to Lync window
    ControlClick, X100 Y85, ahk_class CommunicatorMainWindowClass, , Left, 1 ; Click status
    Sleep 500 ; Wait until Status chooser pops up
    ControlClick, X70 Y35, ahk_class Net UI Tool Window, , Left, 1 ; Click "Busy"
    WinMinimize,Skype
}
Else If Command = + ; Calculation
{
    gui_search_title = calc
    gui_search_url := ""
    gui_search()
}
Else If Command = update ; Windows Update
{
    gui_destroy()
    Run, cmd /C "start ms-settings:windowsupdate"
    Sleep 500
    WinClose ahk_exe ConEmu64.exe
    Send, {Enter}
}
