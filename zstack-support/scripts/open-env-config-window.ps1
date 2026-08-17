param(
    [switch]$SkipExisting
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$setupScript = Join-Path $scriptDir "set-user-env.ps1"

if (-not (Test-Path -LiteralPath $setupScript)) {
    throw "set-user-env.ps1 not found next to this script"
}

$quotedSetupScript = '"' + ($setupScript -replace '"', '\"') + '"'

$argsList = @(
    "-NoProfile",
    "-ExecutionPolicy",
    "Bypass",
    "-File",
    $quotedSetupScript
)

if ($SkipExisting) {
    $argsList += "-SkipExisting"
}

Write-Host "Opening a visible PowerShell window for secret input."
Write-Host "Do not paste tokens or passwords into the ZCode chat."

Start-Process -FilePath "powershell.exe" -ArgumentList $argsList -WindowStyle Normal
