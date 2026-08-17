# ZStack Support Agent for ZCode

ZCode adaptation of the [ZStack Support Agent Codex plugin](https://github.com/zopenb/zstack-support-agent-codex). It provides ten
skills and four HTTP MCP connectors for GitHub, ZStack BBS, Tavily, and shared
Atlassian services.

The initial ZCode adaptation is based on upstream commit
`71acf973f422455c8a08a8be1ce15b027fab954f` (plugin version `2.9.6`).

## Security model

This repository contains no credentials. ZCode expands `${ENV_VAR}` placeholders
inside plugin MCP HTTP headers when a session starts. Configure credentials as
Windows user environment variables and restart ZCode after changing them.

Required variables:

- `GITHUB_MCP_TOKEN`: raw GitHub token; the plugin adds the `Bearer` prefix.
- `ZSTACK_BBS_AUTHORIZATION`: complete Authorization header value, normally
  `Basic ...`.
- `TAVILY_HIKARI_TOKEN`: raw Tavily token; the plugin adds the `Bearer` prefix.
- `ATLASSIAN_AUTHORIZATION`: complete Authorization header value, normally
  `Basic ...`.

Do not commit `.env` files, generated MCP files containing resolved values, or
ZCode runtime/cache directories.

## Install from GitHub

1. Open ZCode and go to **Settings > Plugin Management > Discover**.
2. Select **+** and add this GitHub repository as a marketplace.
3. Install and enable **zstack-support**.
4. Restart ZCode or create a new session.
5. Check **Settings > Skills** for ten plugin skills and **Settings > MCP** for
   the four namespaced connectors.

## Configure Windows credentials

Run PowerShell with the values for the target machine:

```powershell
[Environment]::SetEnvironmentVariable('GITHUB_MCP_TOKEN', '<token>', 'User')
[Environment]::SetEnvironmentVariable('ZSTACK_BBS_AUTHORIZATION', 'Basic <value>', 'User')
[Environment]::SetEnvironmentVariable('TAVILY_HIKARI_TOKEN', '<token>', 'User')
[Environment]::SetEnvironmentVariable('ATLASSIAN_AUTHORIZATION', 'Basic <value>', 'User')
```

Close all ZCode processes and reopen ZCode so the desktop process inherits the
new user environment.

## Expected components

- Plugin ID: `zstack-support@zstack-support-local`
- Skills: 10
- MCP servers: `github`, `zstack-bbs-support`, `tavily_hikari`, and
  `zstack_atlassian_shared`

ZCode currently ignores Codex-only `enabled_tools`, `disabled_tools`, and
`default_tools_approval_mode` fields. This adaptation omits those fields rather
than implying that the Codex tool allowlist is enforced. The skills retain their
read-only and confirmation requirements; review ZCode permissions before using
write-capable MCP tools.
