$ErrorActionPreference = "Stop"

$CONFIG = "install.conf.windows.yaml"
$DOTBOT_DIR = "dotbot"

$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

# 安装 Chocolatey
Write-Host "Installing Chocolatey..."
if (!(Test-Path -Path "$env:ProgramData\chocolatey\bin\choco.exe")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed. Skipping."
}

Set-Location $BASEDIR

git submodule update --init --recursive

Set-Location $BASEDIR
$pythonFound = $false
$pythonCmd = $null
$pythonVersions = @('python3', 'python', 'python2')

foreach ($PYTHON in $pythonVersions) {
    # Python redirects to Microsoft Store in Windows 10 when not installed
    if (& { $ErrorActionPreference = "SilentlyContinue"
            ![string]::IsNullOrEmpty((&$PYTHON -V))
            $ErrorActionPreference = "Stop" }) {
        $pythonCmd = $PYTHON
        $pythonFound = $true
        break
    }
}

if ($pythonFound) {
    &$pythonCmd $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) -d $BASEDIR -c $CONFIG $Args

    # 安装 cmake
    Write-Host "Installing cmake..."
    if (!(Test-Path -Path "$(Get-Command cmake -ErrorAction SilentlyContinue).Source")) {
        choco install cmake
    } else {
        Write-Host "cmake is already installed. Skipping."
    }

    # 安装 bob
    Write-Host "Installing bob..."
    if (!(Test-Path -Path "$(Get-Command bob -ErrorAction SilentlyContinue).Source")) {
        choco install bob
    } else {
        Write-Host "bob is already installed. Skipping."
    }

    # 使用 bob 安装最新版 nvim
    Write-Host "Installing latest nvim..."
    if (Test-Path -Path "$(Get-Command bob -ErrorAction SilentlyContinue).Source") {
        bob install nvim
    } else {
        Write-Host "bob is not installed. Skipping nvim installation."
    }

    Write-Host "Installation completed."
} else {
    Write-Error "Error: Cannot find Python."
}

