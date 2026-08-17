---
name: "ZStackSupport:连通检查"
description: Diagnose GitHub, ZStack BBS, Tavily, and shared Atlassian MCP declarations, environment-variable presence, current-session injection, and safe structured-query status in ZCode.
---

# MCP 连通检查

对四个插件连接器执行渐进式只读烟测。连通结果只描述工具状态，不是事件分析证据。

Atlassian 只检查 `zstack_atlassian_shared`，不接受旧 `zstack_atlassian`、`support_archive`、`support_sql_analyst` 或其他旧目标。

## 状态

| 状态 | 条件 |
|------|------|
| 未配置 | 插件未声明该服务器，或必要环境变量缺失 |
| 已配置但未注入 | 插件声明和环境变量存在，但当前对话没有该服务器的有效工具 |
| 工具可见 | 当前对话可见工具，尚未完成结构化查询 |
| 结构化查询成功 | 当前对话中的只读工具成功执行最小结构化查询 |
| MCP 查询未完成 | 认证、网络、schema、查询或安全校验失败 |

四个连接器都使用同一状态机。不得只为 BBS/Atlassian 使用“已配置但未注入”，而把同样状态的 GitHub/Tavily 误写成“未配置”。

## 配置来源

从当前技能目录向上找到最近的插件 `.mcp.json`。ZCode 安装缓存通常位于包含当前技能的版本目录。

| 连接器 | `.mcp.json` server | 必要变量 | 最小烟测工具示例 |
|--------|--------------------|----------|------------------|
| GitHub | `github` | `GITHUB_MCP_TOKEN` | `get_file_contents` |
| BBS | `zstack-bbs-support` | `ZSTACK_BBS_AUTHORIZATION` | `bbs_latest` 或 `bbs_search`；不调用 `bbs_create_thread` |
| Tavily | `tavily_hikari` | `TAVILY_HIKARI_TOKEN` | `tavily_search` |
| Atlassian | `zstack_atlassian_shared` | `ATLASSIAN_AUTHORIZATION` | `jira_search` 或 `confluence_search` |

先验证服务器类型、批准 URL、环境变量引用和 ZCode 支持字段。BBS 与 Atlassian 使用受控内部 HTTP 端点；成功连接不代表 TLS、加密传输或链路保密已经验证。

## ZCode 安全边界

ZCode 当前不会执行 Codex 的 `enabled_tools`、`disabled_tools` 或 `default_tools_approval_mode` 字段，因此本插件不声明这些字段，也不声称客户端白名单已生效。

连通检查遵循以下约束：

1. 只调用名称、description 和输入 schema 均明确只读的工具。
2. 不调用创建、更新、编辑、删除、评论、合并、推送、分配、转换、上传、提交、触发、取消或锁定等状态变更工具。
3. BBS 的 `bbs_create_thread` 即使可见也只报告可见性，绝不试发帖子。
4. 当前工具含写能力不等于已执行写操作；报告 `WARN：当前会话存在写能力`，并拒绝调用该工具。
5. 依赖 ZCode 权限模式和用户确认控制外部副作用；不得通过技能绕过权限。

## 通用检查流程

对每个连接器分别执行：

```text
第 1 步（插件声明）：server、URL、认证变量引用和字段是否有效
第 2 步（变量存在）：只检查存在性与格式，不输出值
第 3 步（当前会话注入）：列出当前对话实际可见的该服务器工具
第 4 步（安全校验）：拒绝写工具，只选择明确只读的最小工具
第 5 步（结构化查询）：执行去标识化的最小只读查询
```

判定优先级：

1. 声明或变量缺失：`未配置`。
2. 声明和变量存在、当前工具为空：`已配置但未注入`。
3. 当前工具存在但没有可安全调用的只读工具：`MCP 查询未完成（安全校验失败）`。
4. 只读结构化调用失败：`MCP 查询未完成`。
5. 当前对话只读结构化调用成功：`结构化查询成功`。

## 各连接器烟测

### GitHub

使用明确只读的工具读取 `zstackio/zstack` 顶层 `README.md` 或仓库元数据。不创建 issue、PR 或分支，不提交、评论、合并、推送、编辑或删除。

配置和 `GITHUB_MCP_TOKEN` 存在但当前无 GitHub 工具时，输出“已配置但未注入”，建议完全重启 ZCode 或新建会话，并在 Settings > MCP 查看状态。

### BBS

确认 `ZSTACK_BBS_AUTHORIZATION` 引用后，使用当前会话中的 `bbs_latest` 或 `bbs_search` 做最小查询。只报告 `bbs_create_thread` 是否可见，绝不调用。

### Tavily

使用搜索工具查询不含客户信息的公开静态词，例如 `Red Hat virtio Windows disk timeout`。变量存在但工具不可见时输出“已配置但未注入”。

### Atlassian

优先读取插件声明和 Settings > MCP 状态。使用 Jira/Confluence 只读搜索执行不含客户标识的最小查询；不创建、更新、评论、转换或删除任何内容。

## 输出

每个连接器输出：

```text
连接器：
插件声明：通过 / 未通过
变量存在：通过 / 未通过
当前会话注入：通过 / 未通过
当前工具安全检查：通过 / WARN（存在写能力） / 未验证
结构化查询：通过 / 未通过 / 未执行
最终状态：未配置 / 已配置但未注入 / MCP 查询未完成 / 结构化查询成功
诊断建议：
```

## 规则

- 不输出凭证、Authorization、原始 MCP 载荷或查询正文。
- 不调用任何写工具；对外副作用必须由对应业务技能另行要求用户确认。
- 远端原始工具集和当前对话有效工具集必须分别报告，不能混为一谈。
- 连通检查结果不映射为 E0-E5，也不能关闭支持事件。
