---
name: "ZStackSupport:故障报告"
description: Generate a formal ZStack enterprise fault-analysis DOCX from completed event-analysis results. Invoke only when the user explicitly asks for a fault-report/RCA document or DOCX file; an RCA question or cause analysis by itself belongs to the event-analysis skill.
---

# 故障报告

基于标准 Word 模板输出 ZStack 企业版故障分析报告。必须复制并修改 `assets/ZStack企业版-故障分析报告模板V1.2.docx`，不要从空白文档重造。

## 触发边界

- 只有用户明确要求“正式故障报告/RCA 报告文件/DOCX”时才使用本技能。
- 用户只询问 RCA、根因、原因分析、处理过程或改进措施时，必须路由到事件分析，不得隐式生成 DOCX。
- 本技能是分析后的正式交付步骤，不替代证据查证。

## 工作流

1. 先明确 `audience` 是 `internal` 还是 `customer`。客户版必须按 [输入结构](references/input-schema.md) 确认同一收件客户身份或泛化所有标识。
2. 基于事件分析结果、当前证据、客户确认信息和恢复结果补全报告内容。AI 负责判断和撰写，脚本只负责模板渲染、确定性校验和原子发布。
3. 生成 JSON 前形成内部写作约束清单，至少包含：客户核心关注点、明确禁止内容、必须比较的节点或对象、结论成熟度、用户内容是写作方向还是要求原文、期望详细程度、改进方案允许的一级方向。逐项检查正文；遗漏关注点、违反禁止项、漏掉对照对象或机械照抄提纲时不得进入生成阶段。
4. 若缺少故障时间、恢复时间、影响范围、处理过程、原因分析、改进措施或证据边界，只补问最小必要信息；不要让脚本编造。
5. 使用可执行的 Python 3.10+。插件安装器会将锁定依赖安装到用户私有目录，生成器会自动将该目录加入 `sys.path`；可用 `ZSTACK_SUPPORT_PYTHONPATH` 覆盖。脚本绝不会在生成期自动联网安装。
6. 可先导出模板结构，确认可填字段：

```powershell
<python.exe> scripts/generate_fault_report.py --print-template
```

7. 将报告内容整理为 JSON，字段参考 [输入结构](references/input-schema.md)。改进措施优先使用结构化对象；责任人未知时显式写“待指定”，不得省略。
8. 使用脚本生成 DOCX：

```powershell
<python.exe> scripts/generate_fault_report.py input.json --out output.docx
```

9. 生成器内部按固定顺序执行：输入校验 → 内容规范化 → 模板写入 → 格式规范化 → 元数据清理 → 脱敏与关系检查 → 格式结构审计 → 原子发布。安全校验通过后不得再修改 DOCX；确需修改时必须重新运行生成器完整链路。
10. 生成后必须调用 `$ZStackSupport:脱敏检查` 按 JSON 中的 `internal` 或 `customer` 受众复核输出；未通过不得交付。生成器的确定性扫描是发布门禁，但不替代完整分享批准。
11. 按文档规则渲染并检查页面 PNG；发现版式问题后必须回到 JSON 或官方生成器修改，并重新执行完整发布链路。不得使用临时后处理脚本直接修最终文件。LibreOffice/`soffice` 只用于自动 PDF/PNG 视觉 QA，不是生成 DOCX 的硬依赖；若不可用，说明“DOCX 已生成，未完成自动视觉渲染 QA”。

## 报告边界

- 故障报告是对已分析事件的正式输出，不是排查工具。
- 原因分析必须基于证据分级和当前结论；未闭环时写“初步判断/仍需确认”，不要写成确定根因。
- `root_cause_analysis` 必须显式写出证据边界或结论状态；渲染器会拒绝没有这类说明的输入。
- 处理过程应按时间线写实际动作、观察结果和责任边界，不要补不存在的操作。
- 后续改进与预防方案应由 AI 根据事件分析结论生成，可以包含客户侧、支持侧、产品侧或流程侧措施。每项明确措施、责任人和验证标准；高风险项还必须明确前提和回退条件。
- 客户交付版本不得包含凭证、原始 MCP 载荷、未脱敏客户日志、内部原文或没有证据支撑的根因断言。
- 客户版禁止任意 IP/GUID、内部工单编号、BBS/Jira/Confluence 绝对或相对链接、受控端点、批注、修订、隐藏文本、未知 OOXML 关系和嵌入可执行内容；外部超链接只允许 HTTP(S)。
- `internal` 和 `customer` 都禁止 Bearer/Basic 凭据、密码/Token/Secret 赋值、普通/加密/PGP 私钥标记、常见云端/代码托管 Token 和 URL userinfo 凭据。

## 模板约束

- 保留模板的封面、故障基本信息表、分析处理过程表、原因分析表、后续改进与预防方案表。
- 只替换模板中的标题、基础信息和三个正文块内容。
- 保持主题字体；正文和表格行间距统一为 1.5。
- 普通正文必须显式为非粗体，不得继承模板 run 的粗体属性。
- 冒号前标签只加粗标签，`**重点**` 只加粗标记片段；只有封面标题、故障级别、关键时间字段和结构化改进项标题使用整行加粗。
- 无手工编号的普通条目使用 Word 原生编号；已有 `1.`、`1、` 或 Markdown 编号时不得重复追加。

## 脚本边界

`scripts/generate_fault_report.py` 是模板渲染器：

- 默认读取本技能 `assets/` 下的标准模板。
- 支持 `--template` 指定新版模板。
- 支持 `--print-template` 输出模板字段和正文块名称。
- 严格校验 JSON 必填项、类型、未知字段、重复键、`audience` 和明显凭据，支持 UTF-8 BOM。需要待确认的事实必须显式写“待补充/待确认”。
- 按 JSON 写入模板，保留原 run 字号、字体与表格对齐，但显式覆盖粗体语义；正文使用 1.5 倍行距、0 磅段前段后间距。
- 兼容旧字符串和字符串数组；`improvement_plan` 还支持包含前提、措施、责任人、验证标准和回退条件的结构化对象。
- 发布前审计普通正文整段粗体、混合加粗、重复编号、原生编号结构、行距、段前段后间距和模板占位符；失败时不替换输出文件。
- 原子写入输出，拒绝覆盖输入 JSON 或模板；清理核心/扩展/WPS/customXml 元数据、`rsid`/`docId` 追踪标识和自定义文档变量。
- 将 TOC/字段标记为待更新，并在模板结构漂移或请求字段无法写入时失败。
- 不生成业务内容、不补默认根因、不补默认整改措施。

输入字段参考 [输入结构](references/input-schema.md)。使用可执行的 Python 3.10+ 运行脚本，`python-docx` 由安装器安装到用户私有目录；不依赖本机全局包。
