#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; This scripts connects a key press on the keyboard to a (remote) Companion button

; Set Companion host/ip and HTTP port
companion_host:= "192.168.1.240:8000"


; Key mapping
1::
companionButton(1, 1)
return

2::
companionButton(1, 2)
return

3::
companionButton(1, 3)
return

4::
companionButton(1, 4)
return

5::
companionButton(1, 5)
return


; Press a button on Companion using HTTP API
; logLevel:
;   0 = no messages
;   1 = only errors
;   2 = response + errors
;   3 = debug + errors
companionButton(bank, button, logLevel = 0)
{
	global companion_host
	companion_url:= "http://" . companion_host . "/press/bank/" . bank . "/" . button 
	try{ ; only way to properly protect from an error here
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", companion_url . view, true)
		whr.Send()
		; Using 'true' above and the call below allows the script to remain responsive.
		whr.WaitForResponse()
		if(logLevel == 2) {
			MsgBox % whr.ResponseText
		}
		if(logLevel == 3) {
			aMess := StrSplit(whr.ResponseText, A_Space, """")
			MsgBox ,, %A_ScriptName% - Row %A_LineNumber%, % "GET request: `n1) Result: " aMess[1] "`n2) trackingid: " aMess[2]
		}
	} catch e {
		if(logLevel >= 1) {
			MsgBox 64, %A_ScriptName% - Row %A_LineNumber%, % e.message
			return e.message
		}
	}
	return
}