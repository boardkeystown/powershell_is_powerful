# collection of useful everyday commands
# ---
# 

# beats typing cls or clear all day:)
# ---
function c { Clear-Host }

# print working directory clipped!
# ---
# Also will from command line copy full of file / folder 
# or just join text to working directory
function pwdc {
    param (
        $file_path
    )
    if (-not $file_path) {
        ((Get-Location).Path).Replace("`n", "") | clip.exe
    }
    else {
        $joined_path = (Resolve-Path $file_path -ErrorAction SilentlyContinue)
        # path does not exists?
        if (($null -eq $joined_path)) {
            $joined_path = $($file_path).Replace(".\", "")
            $joined_path = (Join-Path (Get-Location).Path "$file_path")
        }
        $joined_path = $("$joined_path").Replace("`n", "")
        Write-Host -f Green "CLIP <-" $joined_path
        $joined_path | clip.exe
    }
}

# open file explorer
# ---
# *sigh* sometimes you have to use file explorer...
function files {
    if ($args) {
        explorer.exe $args
    }
    else {
        explorer.exe .
    }
}

# yay *nix !!!


function lrt() {
    if (!$args) {
        Get-ChildItem | Sort-Object LastWriteTime
    }
    else {
        if ($args[0] -eq "-n") {
            Get-ChildItem | Sort-Object LastAccessTime | Select-Object -ExpandProperty Name
        }
        elseif ($args[0] -eq "-h") {
            Get-ChildItem -Force | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime, @{Name = 'Size'; Expression = { "{0:N2} MB" -f ($_.Length / 1MB) } }
        }
        elseif ($args[0] -eq "-hk") {
            Get-ChildItem -Force | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime, @{Name = 'Size'; Expression = { "{0:N2} KB" -f ($_.Length / 1KB) } }
        } 
        else {
            Get-ChildItem $args | Sort-Object LastWriteTime
        }
    } 
}


function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function nproc() {
    if ($args[0] -eq "-v") {
        $output2 = Invoke-Expression -Command "(Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors" | Out-String
        Write-Host "Number of cores : $output2" -ForegroundColor Green
        $output = Invoke-Expression -Command "(Get-WmiObject -Class Win32_ComputerSystem)" | Out-String
        Write-Host $output -BackgroundColor Black -ForegroundColor Yellow
    }
    else {
        $output2 = Invoke-Expression -Command "(Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors" | Out-String
        Write-Host -NoNewline $output2 -ForegroundColor Green
    }
}

function head {
    param (
        $file,
        $number_of_lines
    )
    if ($null -eq $number_of_lines) {
        $number_of_lines = 10
    }
    Get-Content -Head $number_of_lines -Path $file
}

function tail {
    param (
        $file,
        $number_of_lines
    )
    if ($null -eq $number_of_lines) {
        $number_of_lines = 10
    }
    Get-Content -Tail $number_of_lines -Path $file
}

function tail-f {
    param (
        $file
    )
    Get-Content -Path $file -Wait
}

# remove recursive force force verbose
# ---
# yikes be careful with this !
# basically a *nix rm -rfv
# useful if you use make files
# Example:
# rmrfv .objects/*
function rmrfv {
    param (
        $path
    )
    if (-not (Test-Path -Path $file)) {
        Write-Host "does not not exits: $file" -ForegroundColor Yellow
    } else {
        Get-ChildItem -Path $file| ForEach-Object {
            if (Test-Path -Path $_.FullName) {
                Write-Host "Removing: $_" -Foreground Red
                Remove-iTem -Path $_.FullName
            } else {
                Write-Host "does not not exits: $_" -Foreground Yellow
            }
        }
    }
}