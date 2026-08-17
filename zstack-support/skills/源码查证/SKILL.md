---
name: "ZStackSupport:源码查证"
description: Targeted read-only ZStack public source lookup on GitHub for mechanisms, APIs, configurations, errors, call paths, commits, branches, and version differences.
---

# ZStack 源码查证

使用 GitHub MCP 单点查证 ZStack 公开源码。默认不执行完整事件分析，也不默认查询 BBS、Jira、Confluence、Tavily 或官网。实际触发补充来源时，必须与 GitHub 分块记录，不能把补充证据标成 GitHub。涉及“哪个版本修复、是否发布、是否合入目标版本线、fixVersion 是否可信”的完整版本结论时，本技能只负责 GitHub 子结论，主流程必须转到 `@ZStackSupport:事件分析` 执行版本确认路径。

开始前读取 [查证路由规则](../ZStack%20Support%20Knowledge/references/evidence-routing.md)，尤其是故障指纹去标识化和版本确认规则。用户要求完整根因、闭环或交接时转用 `@ZStackSupport:事件分析`。

先确定输出受众。用户未指定时写 `受众：internal`；用户明确要求客户可用内容时写 `受众：customer`。customer 输出不得包含 BBS 编号、标题、链接、内部端点、原始内部内容或只能由 BBS 支持的特有事实；只保留已脱敏且能由 GitHub、官网或 Tavily 公共一手资料独立支持的结论与行动建议。

## 适用范围

- 类、方法、API、配置键、错误模板或模块路径；
- 产品机制、字段下发和必要调用链；
- commit、tag、release branch、公开 ref 差异或提交可达性。用户明确只要源码视角时可以输出限定的 GitHub 事实，但不得将其扩写成完整发布、内部跟踪或客户现场结论。

默认仓库：

- `zstackio/zstack`：核心平台 Java 代码、API、插件和数据库 schema；
- `zstackio/zstack-utility`：KVM agent、存储/网络代理、CLI 和部署工具。

不确定时查两者；问题明确指向其他公开 ZStack 仓库时可以扩展并说明原因。

## 查询前去标识化

用户至少提供产品/公开版本、静态错误信号、类/API/配置键/路径中的一项。没有静态信号时先问最小信息，不发送宽泛客户材料。

构造 GitHub 查询前必须删除：

- 客户、项目、租户、集群、主机、虚拟机、存储和网络名称；
- UUID、资源 ID、IP、MAC、域名、主机名、邮箱、账号和序列号；
- Token、Cookie、Authorization、许可证标识和 URL 参数；
- 原始日志上下文、完整命令输出和客户自定义文件路径。

只使用静态错误模板、异常/类/方法名、API 名、配置键、通用组件和必要公开版本号。禁止将整行原始日志直接发送到 GitHub 搜索。输出中的“查找术语”也只记录处理后的词。

## 执行

1. 验证当前会话的 GitHub 工具已通过插件有效只读白名单，并能完成结构化查询。
2. 首个查证动作必须是 GitHub code/search/commit/tag/branch 或文件读取。
3. 根据组件选择仓库和 ref；用户给出版本时优先目标 tag/branch，不只看主分支。
4. 先用去标识化术语定位入口，再读取最小相关片段。
5. 只追踪回答问题所需的调用链，记录关键分支和适用条件。
6. 区分“公开源码事实”和“当前客户行为”；源码版本不匹配时标注近似参考。
7. 对公开源码中的提交可达性判断同时检查 commit、目标 tag/branch 内容或可达性；一次搜索未命中不能证明未合入。若用户需要完整修复版本结论，返回 GitHub 子结论后转事件分析补 Jira 等实际触发来源。

硬约束：

- Jira、Confluence、BBS 或 Tavily 不得替代 GitHub 源码查证。
- GitHub 未注入、限流、认证失败或白名单校验失败时，写“GitHub 源码查证未完成”，不得转查内部来源后声称完成。
- 不创建 issue、评论、分支、提交或 PR，不合并、推送、编辑或删除任何资源。
- GitHub 只证明公开实现和版本事实，不能证明客户现场实际走过该路径。

## 按需补充

- 官网文档：需要官方配置、限制或操作边界时补充；客户版本未知时先询问最小版本信息，不用最新文档替代客户版本结论。
- BBS：用户明确问历史案例，或源码事实需要历史验证动作时补充。customer 输出的 BBS 块只记录“内部历史参考已检查、无可直接对外的独立证据”及其边界，不写命中细节；同一结论有公共一手来源时在对应公共来源块独立记录。
- Tavily：涉及 OS、内核、QEMU/KVM、libvirt、Ceph、GPU、vLLM/SGLang 等外部生态时补充。

所有补充查询继续使用去标识化指纹。Jira/Confluence 不属于本技能的补充来源；只要问题需要内部缺陷/版本状态、fixVersion 可信度、是否发布或目标版本线的完整结论，就必须转用事件分析，不能停在 GitHub-only 输出。

## 证据标注

源码核心断言的来源类型记录为 `GitHub`，补充断言按实际来源记录为 `官网文档`、`BBS` 或 `Tavily或公开Web`。每种实际查询的来源使用一个独立证据块；同一来源的多次查询在该块内聚合查询词和命中边界，不能与其他来源合并后只标 GitHub。证据成熟度按实际断言独立评定。一个可检查源码片段通常只足以确认限定的代码事实，不能自动提升当前根因。修复 commit、tag 或发布存在本身不是 E5；E5 只用于当前事件处置后的恢复验证闭环。

## 输出

```text
受众：internal / customer
## GitHub 源码证据
GitHub MCP 状态：结构化查询成功 / MCP 查询未完成 / 已配置但未注入 / 未配置
仓库：
分支/Ref：
路径或提交：
查找术语：仅脱敏词
机制/版本事实：
必要调用链：
公开标签：已确认 / 较可能 / 可能 / 证据缺失
证据成熟度：E0-E5
来源类型：GitHub
能支持的判断：
不能支持的判断：
证据边界：公开源码参考，非当前客户环境证据
当前事件仍需验证：

## 补充来源证据（仅在实际查询时输出；每种来源一块）
来源类型：官网文档 / BBS / Tavily或公开Web
来源状态：结构化查询成功 / MCP 查询未完成 / 已配置但未注入 / 未配置
查询词：仅脱敏词
命中摘要：
链接：internal 的 BBS 命中必须包含标题摘要和完整 tid Markdown 直达链接，完整 URL 不可得时写“直达链接未返回”且不得猜测；customer 禁止 BBS/internal 链接和内部标识，官网/Tavily 只保留无查询参数的 HTTPS 公共一手链接
公开标签：已确认 / 较可能 / 可能 / 证据缺失
证据成熟度：E0-E5
能支持的判断：
不能支持的判断：
证据边界：历史案例 / 官方说明 / 外部生态参考，非当前客户环境证据
受众处理：internal / customer 下实际删除或保留了什么
```

## Subagent

只有用户明确要求多 agent/subagent/并行深查、源码任务能与其他有界任务并行，且宿主提供调度工具时，才把本技能作为“源码/版本”子任务。数量按当前可用并发动态决定，不设置来源数量门槛或预设 agent 数。

源码/版本子任务只查 GitHub，只接收去标识化指纹。GitHub 不可用时返回“GitHub 查证未完成”，不得改查 Jira/Confluence/BBS/Tavily。其余规则使用事件分析的 [动态 subagent 模板](../事件分析/references/subagent-prompts.md)。

## 规则

- 只读且最小读取。
- 不输出 Token、Authorization、原始 MCP 载荷或未过滤提供者输出。
- 实际使用 BBS、官网或 Tavily 时单独标注来源和受众处理，不得并入 GitHub 来源块。
- 不把源码事实写成客户现场事实。
- 只在确实查询 GitHub 后，可偶尔自然提示 ZStack 开源仓库；不要每次重复。
