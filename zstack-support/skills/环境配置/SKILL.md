---
name: "ZStackSupport:环境配置"
description: Configure and inspect ZStack Support Agent MCP environment variables on Windows for ZCode. Use for GitHub, BBS, Tavily, or Atlassian credential presence and injection diagnostics.
---

# ZStack 环境配置

本适配版面向 Windows ZCode。不要要求用户把 Token、密码、Authorization 或 base64 值粘贴到聊天或命令参数中。

## 变量

```text
GITHUB_MCP_TOKEN
ZSTACK_BBS_AUTHORIZATION
TAVILY_HIKARI_TOKEN
ATLASSIAN_AUTHORIZATION
```

BBS 使用完整的 `Basic <base64(username:password)>`，通过 `ZSTACK_BBS_AUTHORIZATION` 注入。Atlassian 同样使用完整 Basic Header。GitHub 和 Tavily 变量只保存原始 token，`.mcp.json` 负责添加 `Bearer` 前缀。

ZCode 会在插件 HTTP MCP `headers` 中展开 `${ENV_VAR}`。仓库和插件配置只保存变量名，不保存真实值。

## 定位插件根目录

脚本路径以本技能所属插件根目录为准，不依赖当前工作目录。安装缓存通常是技能目录向上找到包含 `.mcp.json` 的目录。

## Windows

### 快照

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File '<插件根目录>\scripts\snapshot-user-env.ps1'
```

快照只输出变量名、存在性、作用域和格式检查，不输出值。

### 可见窗口录入

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File '<插件根目录>\scripts\open-env-config-window.ps1'
```

只补缺失项：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File '<插件根目录>\scripts\open-env-config-window.ps1' -SkipExisting
```

后台终端可能无法安全交互输入；默认使用可见窗口。脚本使用隐藏输入，并将凭据写入 Windows 用户环境变量。

## 后续动作

配置或修改后，完全退出所有 ZCode 进程并重新打开，或创建确认重新加载插件和环境的新会话，然后运行 `ZStackSupport:连通检查`。在 Settings > MCP 查看四个插件 MCP 的连接状态。

四个连接器都可能出现“配置和变量存在，但当前会话未注入工具”。这种情况不是“未配置”；由连通检查区分插件声明、环境、远端连接和当前会话注入层。

## 安全边界

- 不在聊天、命令参数、仓库文件、`.mcp.json` 或日志中收集或写入真实密钥。
- 不回显变量值，不输出可还原凭据的长度、前缀或片段。
- 用户已粘贴真实密钥时，停止复述并建议立即轮换。
- 环境变量只写入当前 Windows 用户作用域，不修改机器级变量。
