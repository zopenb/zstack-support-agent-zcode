---
name: "ZStackSupport:事件分析"
description: Evidence-first ZStack support event analysis with internal knowledge system priority, mandatory source and version verification, audience-aware direct links, and closure workflows.
---

# ZStack 事件分析

分析 ZStack Cloud、ZStack AIOS、ZSphere、KVM/Libvirt/QEMU 和 AIOS 相关 vLLM/SGLang 支持事件。具体客户反馈、报错、告警、日志、失败 API、兼容性或客户回复口径必须主动查证；低风险概念问题可以直接回答。

开始前读取 [查证路由规则](../ZStack%20Support%20Knowledge/references/evidence-routing.md)。完整分析还要读取 [工作流方法论](../ZStack%20Support%20Knowledge/references/workflow-methodology.md)；涉及日志路径时读取 [日志路径基准](../ZStack%20Support%20Knowledge/references/log-paths.md)。这些参考分别是路由、证据模型和路径的唯一来源，不在本技能另建相反规则。

内部 Jira/Confluence 只使用插件声明的共享远端 `zstack_atlassian_shared` 的有效只读工具。不得使用旧 `zstack_atlassian` 本机适配器、`support_archive`、`support_sql_analyst` 或其他旧目标替代。

## 执行流程

### 1. 判断入口

- 概念、通用机制、一般排查：直接回答。
- 缺少可搜索的静态信号：只问组件、版本、静态错误文本或操作路径等最小信息。
- 用户明确限定单一来源：只查该来源，并只输出该来源能支持的限定结论；例如只查 GitHub 时可以确认公开合入事实，但不能给出 Jira 状态或完整内部版本结论。
- 具体支持事件：先整理当前事件证据并形成去标识化的最小故障指纹，再首批查证 BBS、Jira 和 Confluence 内部知识系统。
- 完整根因、闭环、交接或研发材料：使用完整分析结构。

同时确定输出受众。用户未指定时，事件分析默认生成明确标注为 `受众：internal` 的内部分析草稿，不得声称可直接发给客户；用户明确要求可直接发给客户时使用 `受众：customer` 并移除内部链接、端点、编号和操作细节。即使主分析是 internal，其中单列的“客户回复口径”也始终按 customer 规则生成。

续问“这个修复、继续查、那 Jira 呢、源码呢、有没有类似案例”时继承上一轮对象、版本、脱敏指纹、来源结果和证据边界，不从零开始。

### 2. 提取双层指纹

```text
内部事件摘要：仅保留分析所需的最小现场上下文。
可查询故障指纹：产品/组件、公开版本范围、静态错误模板、告警名、异常/类/方法名、API、配置键和通用操作路径。
```

向 GitHub、Tavily、公开 Web 或厂商论坛查询前，强制删除客户/项目/租户/集群/主机/虚拟机名称、UUID、IP、MAC、域名、主机名、账号、邮箱、序列号、许可证标识、URL 参数和原始日志上下文。外部查询只使用静态错误模板、类名、API、配置键、组件和必要公开版本号；禁止直接发送整行原始日志。

BBS/Jira/Confluence 查询同样最小化，优先静态指纹，不发送与命中无关的客户标识、完整日志、附件或凭证。

### 3. 内部知识系统优先

当前事件证据始终优先，参考来源不能替代现场证据。具体 ZStack 支持事件形成去标识化的最小故障指纹后，首批查证必须包含 BBS、Jira 和 Confluence：

- **BBS**：查询少量高相关历史案例、差异和可复用验证动作。
- **Jira**：查询相关已知缺陷/需求、跟踪状态、组件归属、影响版本和修复版本。
- **Confluence**：查询相关内部说明、版本边界、兼容矩阵、规范操作、发布说明和产品口径。
- **GitHub**：问题涉及源码、机制、调用链、API/配置键/字段下发、类/方法/堆栈、commit/tag/branch、版本合入、版本差异或修复确认时，同一首批查证必须包含 GitHub；不得等内部知识系统查完后才决定是否查 GitHub。
- **官网文档**：配置含义、官方限制、步骤和产品边界按版本补充查证。
- **Tavily/公开 Web**：OS、内核、驱动、Ceph、QEMU/KVM、libvirt、GPU、AI 框架等外部生态按需补充查证。

低风险直答、用户明确指定单一来源，以及尚不能形成有效故障指纹的输入不强制查询三个内部来源。除此之外，不得因为预判某个内部来源“可能无帮助”而跳过；工具不可用或查询失败时记录“查证未完成”，不能写成“未命中”。内部知识系统命中高度相同问题时，给出处置路径、适用条件和差异校验；只有相似结果时标注“疑似同类”。完成首批内部查证后，只在结论仍需要时扩展官网或外部来源。来源冲突时保留冲突，不让内部跟踪覆盖源码或当前证据。

### 4. 记录证据

对每个关键断言分别记录：

```text
断言：
公开标签：已确认 / 较可能 / 可能 / 证据缺失
证据成熟度：E0-E5
来源类型：当前事件 / GitHub / 官网文档 / BBS / Tavily或公开Web / Jira / Confluence
来源定位：
能支持的范围：
不能支持的范围：
待补证：
```

来源类型和 E0-E5 成熟度互相独立。GitHub、官网、BBS、Jira 或 Confluence 都没有固定等级。E5 只用于当前事件执行处置后完成恢复验证和约定复测；修复提交、Jira 关闭或版本发布本身不是 E5。

E0-E2 不得作为当前事件最终根因；E2 可以确认范围有限的代码、文档或状态事实。当前根因通常需要 E4，“已关闭”必须达到 E5。

## 修复版本与回合确认

用户问“哪个版本修复、是否发布、是否合入某版本线、fixVersion 是否可信”时：

1. 具体支持事件的首批查证同时包含 BBS、Jira、Confluence 和 GitHub；GitHub 执行 code/commit/tag/branch/文件读取，确认机制入口和公开版本事实。
2. Jira 查询内部状态、影响版本、fixVersion 和关联项；不得先查完 Jira 再决定是否查 GitHub。
3. Confluence 查询版本边界、兼容口径和内部发布说明；BBS 补充历史现场与验证动作。两者都不能证明代码合入。
4. 用户明确只做单点版本求证时至少查 GitHub 与 Jira；BBS、Confluence 按该单点问题是否需要历史现场或内部版本口径补充。

只有 Jira fixVersion 时只能说“内部跟踪标记/规划为该版本”。确认合入需要目标 tag/branch、提交可达性或明确发布说明；一次未命中不能证明未合入。GitHub 查证未完成时，明确说明不能对目标版本线下最终结论。

输出：

```text
GitHub 提交/分支查证：
Jira 内部跟踪：
Confluence/内部版本口径：
目标版本线查证：
能确认的事实：
不能确认的事实：
来源冲突或缺口：
```

## 来源使用边界

### GitHub 源码硬约束

默认仓库：核心平台查 `zstackio/zstack`；KVM agent、存储/网络代理和 CLI 查 `zstackio/zstack-utility`；不确定时查两者。只读取最小源码片段。GitHub 不可用时写“GitHub 源码查证未完成”，不得用 Jira/BBS/Confluence 冒充源码结论。

### BBS

`internal` 输出只保留 1-3 个高相关帖子摘要；每个命中必须包含标题摘要和 Markdown 可点击直达链接，格式为 `[帖子标题](http://bbs.zstack.io/forum.php?mod=viewthread&tid=<tid>)`。只有 tid 而无标题时使用不含客户信息的短摘要作为链接文字。无法获得 tid 或完整 URL 时写“直达链接未返回”，不得输出相对链接或伪造链接。历史相似不能直接写成当前事件相同；列出版本、组件、路径和现象差异。

### Jira 与 Confluence

`internal` 输出中，每个 Jira 命中必须包含编号、标题摘要、状态、版本字段和 Markdown 可点击直达链接，格式为 `[<KEY>](http://jira.zstack.io/browse/<KEY>)`。每个 Confluence 命中必须包含标题摘要、适用版本、边界和 MCP 返回的完整 Markdown 可点击直达链接。Confluence 未返回完整 URL 时写“直达链接未返回”；不得猜测页面 URL，也不得输出相对链接或只有 key/pageId 的伪链接。

不得创建、更新或评论 Jira/Confluence，不输出原文、评论、附件、账号、凭证或原始 MCP 载荷。客户回复或 `customer` 输出禁止 BBS/Jira/Confluence 链接、内部端点和原始内部内容，只保留可由对外证据支持的脱敏结论与行动建议；不得因此删除 `internal` 主分析中必须返回的直达链接。

### 官网与公开 Web

官网查证先用 [官网文档映射](../ZStack%20Support%20Knowledge/references/docs-mapping.md) 和章节索引按版本定位。涉及操作、兼容性、限制或客户版本边界但版本未知时，先询问最小版本信息；仅做概览时可以并列 V4/V5 或暂看最新文档，但必须说明不能据此下客户版本结论。Tavily/公开 Web 优先官方、厂商 KB 和项目一手资料。所有公开查询使用去标识化指纹。

## MCP 状态

具体支持事件检查 BBS 和 Atlassian MCP；涉及源码或版本确认时同批检查 GitHub MCP；官网和外部生态按需检查对应来源：

```text
工具可见 / 已连接 / 结构化查询成功 / MCP 查询未完成 / 已配置但未注入 / 未配置
```

只有当前会话中通过只读白名单的工具完成结构化查询，才写“结构化查询成功”。若配置和环境变量存在但工具未出现在当前会话，写“已配置但未注入”。连通性不是事件证据；详细诊断转用 `@ZStackSupport:连通检查`。

## Subagent 并行

只有用户明确要求多 agent/subagent/并行深查、任务可拆成互不覆盖的有界子任务，且宿主提供调度工具时才派发。不设置来源数量门槛，也不预设 agent 数量。

按本次路由需要的来源分组，派发数量不超过当前可用并发槽位，主 agent 占一个槽位。具体支持事件默认覆盖历史 agent 的 BBS 和内部 agent 的 Jira/Confluence；源码/版本类同批增加只查 GitHub 的源码 agent。低风险直答、明确单点求证或无有效故障指纹时只派实际需要的组；文档/外部 agent 只查需要补充的官网/Tavily。所有子任务只接收去标识化指纹。

主 agent 等待影响结论的任务并合并结果。失败或超时标记“查证未完成”，不写成“未命中”。使用前读取 [动态 subagent 模板](references/subagent-prompts.md)。未触发时仅在用户明确要求并行的场景说明原因并由主 agent 降级完成。

## 轻量答复

```text
受众：internal / customer
结论：
适用条件：
关键断言：[公开标签][E0-E5][来源类型]
依据与边界：
影响范围：
建议验证：
客户回复口径（无内部链接）：
```

轻量答复不需要案例目录或完整报告，但不能省略断言标签、成熟度和来源边界。

## 完整分析

用户明确要求完整分析时输出：

```text
受众：internal / customer
## 问题摘要
## Intake
## 案例目录决策
## 产品、版本、影响与时间窗口
## 关键断言与证据映射
## 当前事件证据
## 实际查询过的参考来源
## 已执行与已排除
## 安全行动建议
## 多维闭环决策
## 案例更新
## 下一步
```

闭环必须分维度：状态单选；处置、分类和产物多选。字段和值以工作流方法论为准。“临时规避、追踪缺陷、知识更新”不能充当状态；只有当前事件达到 E5 才能选择“已关闭”。

默认建议只读验证。重启、删除、迁移、数据库修改、网络切换、升级等高风险操作必须给出影响、备份/回滚、窗口、后置验证和中止条件，并等待明确授权。日志路径不得凭经验编造。

分析后可提示使用 `@ZStackSupport:交接摘要` 和 `@ZStackSupport:脱敏检查`。问题完成恢复验证且有可复用处理经验时，可提示使用 `@ZStackSupport:BBS经验回流`；未达到闭环条件时不要催促发布知识。若需要继续追问，保留当前线程和上下文。
