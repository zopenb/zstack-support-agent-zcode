param(
    [string]$PluginRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

$manifestPath = Join-Path $PluginRoot '.zcode-plugin\plugin.json'
$mcpPath = Join-Path $PluginRoot '.mcp.json'
$skillsPath = Join-Path $PluginRoot 'skills'

foreach ($path in @($manifestPath, $mcpPath, $skillsPath)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required plugin path is missing: $path"
    }
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$mcp = Get-Content -LiteralPath $mcpPath -Raw | ConvertFrom-Json

if ($manifest.name -cne 'zstack-support') {
    throw "Unexpected plugin name: $($manifest.name)"
}
if ($manifest.skills -cne 'skills') {
    throw "Plugin skills must use the relative path 'skills'"
}

$expected = [ordered]@{
    github = [ordered]@{
        url = 'https://api.githubcopilot.com/mcp/'
        authorization = 'Bearer ${GITHUB_MCP_TOKEN}'
        accept = $null
    }
    'zstack-bbs-support' = [ordered]@{
        url = 'http://172.18.250.27:8768/mcp'
        authorization = '${ZSTACK_BBS_AUTHORIZATION}'
        accept = 'application/json, text/event-stream'
    }
    tavily_hikari = [ordered]@{
        url = 'https://tavily.zopen1.com/mcp'
        authorization = 'Bearer ${TAVILY_HIKARI_TOKEN}'
        accept = $null
    }
    zstack_atlassian_shared = [ordered]@{
        url = 'http://172.18.250.27:3340/mcp'
        authorization = '${ATLASSIAN_AUTHORIZATION}'
        accept = 'application/json, text/event-stream'
    }
}

$serverNames = @($mcp.mcpServers.PSObject.Properties.Name)
if (($serverNames -join ',') -cne (($expected.Keys) -join ',')) {
    throw "MCP server names or order differ from the approved manifest"
}

$allowedFields = @('type', 'url', 'headers', 'enabled')
foreach ($name in $expected.Keys) {
    $server = $mcp.mcpServers.$name
    $actualFields = @($server.PSObject.Properties.Name)
    $unexpected = @($actualFields | Where-Object { $_ -notin $allowedFields })
    if ($unexpected.Count -gt 0) {
        throw "$name contains unsupported ZCode fields: $($unexpected -join ', ')"
    }
    if ($server.type -cne 'http') {
        throw "$name.type must be http"
    }
    if ($server.url -cne $expected[$name].url) {
        throw "$name.url differs from the approved URL"
    }
    if ($server.enabled -ne $true) {
        throw "$name.enabled must be true"
    }
    if ($server.headers.Authorization -cne $expected[$name].authorization) {
        throw "$name.headers.Authorization must contain the approved environment placeholder"
    }
    if ($null -ne $expected[$name].accept -and $server.headers.Accept -cne $expected[$name].accept) {
        throw "$name.headers.Accept differs from the approved value"
    }
}

$skillFiles = @(Get-ChildItem -LiteralPath $skillsPath -Directory | ForEach-Object {
    Join-Path $_.FullName 'SKILL.md'
} | Where-Object { Test-Path -LiteralPath $_ })
if ($skillFiles.Count -ne 10) {
    throw "Expected 10 skills, found $($skillFiles.Count)"
}

Write-Output "OK plugin=$($manifest.name) version=$($manifest.version) skills=$($skillFiles.Count) mcp=$($serverNames.Count)"
