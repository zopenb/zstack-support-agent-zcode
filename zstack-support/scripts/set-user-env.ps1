param(
    [switch]$SkipExisting
)

$ErrorActionPreference = "Stop"

function Get-EnvValue {
    param([string]$Name)

    foreach ($scope in @("User", "Machine", "Process")) {
        $value = [Environment]::GetEnvironmentVariable($Name, $scope)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
        }
    }

    return $null
}

function Get-PersistentEnvValue {
    param([string]$Name)

    foreach ($scope in @("User", "Machine")) {
        $value = [Environment]::GetEnvironmentVariable($Name, $scope)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
        }
    }

    return $null
}

function Use-ExistingValueWhenRequested {
    param([string]$Name)

    if (-not $SkipExisting) {
        return $false
    }

    $persistentValue = Get-PersistentEnvValue $Name
    if (-not [string]::IsNullOrWhiteSpace($persistentValue)) {
        Write-Host "Kept existing persistent variable: $Name"
        return $true
    }

    $processValue = [Environment]::GetEnvironmentVariable($Name, "Process")
    if (-not [string]::IsNullOrWhiteSpace($processValue)) {
        [Environment]::SetEnvironmentVariable($Name, $processValue, "User")
        Write-Host "Persisted existing process variable to user scope: $Name"
        return $true
    }

    return $false
}

function Read-SecretPlainText {
    param([string]$Prompt)

    $secure = Read-Host -Prompt $Prompt -AsSecureString
    if ($secure.Length -eq 0) {
        return ""
    }

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

function Set-UserEnvIfProvided {
    param(
        [string]$Name,
        [string]$Value
    )

    $persistentValue = Get-PersistentEnvValue $Name
    if ($SkipExisting -and -not [string]::IsNullOrWhiteSpace($persistentValue)) {
        Write-Host "Kept existing persistent variable: $Name"
        return
    }

    if ([string]::IsNullOrWhiteSpace($Value)) {
        $processValue = [Environment]::GetEnvironmentVariable($Name, "Process")
        if ($SkipExisting -and [string]::IsNullOrWhiteSpace($persistentValue) -and -not [string]::IsNullOrWhiteSpace($processValue)) {
            [Environment]::SetEnvironmentVariable($Name, $processValue, "User")
            Write-Host "Persisted process variable to user scope: $Name"
            return
        }

        Write-Host "Skipped: $Name"
        return
    }

    [Environment]::SetEnvironmentVariable($Name, $Value, "User")
    [Environment]::SetEnvironmentVariable($Name, $Value, "Process")
    Write-Host "Set user variable: $Name"
}

function Convert-ToBasicAuthorization {
    param(
        [string]$Username,
        [string]$Password
    )

    if ([string]::IsNullOrWhiteSpace($Username) -or [string]::IsNullOrWhiteSpace($Password)) {
        return ""
    }

    $pair = "${Username}:${Password}"
    $base64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($pair))
    return "Basic $base64"
}

$githubToken = $null
$tavilyToken = $null
$bbsUser = $null
$bbsPassword = $null
$bbsAuthorization = $null
$atlassianUser = $null
$atlassianPassword = $null
$atlassianAuthorization = $null

try {
    Write-Host "ZStack Support Agent environment setup"
    Write-Host "Secret values are accepted interactively and will not be printed."
    Write-Host "Press Enter to skip any item you do not want to set now."
    Write-Host ""

    if (-not (Use-ExistingValueWhenRequested "GITHUB_MCP_TOKEN")) {
        $githubToken = Read-SecretPlainText "GitHub token for GITHUB_MCP_TOKEN"
        Set-UserEnvIfProvided -Name "GITHUB_MCP_TOKEN" -Value $githubToken
    }

    if (-not (Use-ExistingValueWhenRequested "TAVILY_HIKARI_TOKEN")) {
        $tavilyToken = Read-SecretPlainText "Tavily token for TAVILY_HIKARI_TOKEN"
        Set-UserEnvIfProvided -Name "TAVILY_HIKARI_TOKEN" -Value $tavilyToken
    }

    if (-not (Use-ExistingValueWhenRequested "ZSTACK_BBS_AUTHORIZATION")) {
        $bbsUser = Read-Host -Prompt "ZStack BBS username for ZSTACK_BBS_AUTHORIZATION"
        $bbsPassword = Read-SecretPlainText "ZStack BBS password"
        $bbsAuthorization = Convert-ToBasicAuthorization -Username $bbsUser -Password $bbsPassword
        Set-UserEnvIfProvided -Name "ZSTACK_BBS_AUTHORIZATION" -Value $bbsAuthorization
    }

    if (-not (Use-ExistingValueWhenRequested "ATLASSIAN_AUTHORIZATION")) {
        $atlassianUser = Read-Host -Prompt "Jira/Confluence username for ATLASSIAN_AUTHORIZATION"
        $atlassianPassword = Read-SecretPlainText "Jira/Confluence password"
        $atlassianAuthorization = Convert-ToBasicAuthorization -Username $atlassianUser -Password $atlassianPassword
        Set-UserEnvIfProvided -Name "ATLASSIAN_AUTHORIZATION" -Value $atlassianAuthorization
    }

    Write-Host ""
    Write-Host "Current variable presence:"
    $names = @(
        "GITHUB_MCP_TOKEN",
        "ZSTACK_BBS_AUTHORIZATION",
        "TAVILY_HIKARI_TOKEN",
        "ATLASSIAN_AUTHORIZATION"
    )

    $rows = foreach ($name in $names) {
        [pscustomobject]@{
            Name = $name
            Present = -not [string]::IsNullOrWhiteSpace((Get-EnvValue $name))
        }
    }

    $rows | Format-Table -AutoSize

    Write-Host "Restart ZCode or open a new session after changing user environment variables."
} finally {
    $githubToken = $null
    $tavilyToken = $null
    $bbsUser = $null
    $bbsPassword = $null
    $bbsAuthorization = $null
    $atlassianUser = $null
    $atlassianPassword = $null
    $atlassianAuthorization = $null
    Remove-Variable -Name rows, names -ErrorAction SilentlyContinue
}
