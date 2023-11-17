# PowerShell version of the code.cmd
#
# One-to-one translation of the the code.cmd as seen in installs of vscode.
# See below cmd version
# @echo off
# setlocal
# set VSCODE_DEV=
# set ELECTRON_RUN_AS_NODE=1
# "%~dp0..\Code.exe" "%~dp0..\resources\app\out\cli.js" --ms-enable-electron-run-as-node %*
# endlocal

$env:VSCODE_DEV = $null
$env:ELECTRON_RUN_AS_NODE = 1
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "$scriptPath"
$codePath = Join-Path $scriptPath "..\Code.exe"
$cliJsPath = Join-Path $scriptPath "..\resources\app\out\cli.js"
& $codePath $cliJsPath --ms-enable-electron-run-as-node $args

# Typical location of code.cmd 
# 'C:\Users\USERNAME\AppData\Local\Programs\Microsoft VS Code\bin\'
# You can copy and paste ps_code.ps1 in the vscode bin folder.
# But it will be deleted if VSCode updates.
# Another option is symbolic links
#
# PS > New-Item -ItemType SymbolicLink -Path "Link" -Target "Target"
# or 
# cmd /c mklink /d "path\to\link" "path\to\target"
#
# Good luck! 