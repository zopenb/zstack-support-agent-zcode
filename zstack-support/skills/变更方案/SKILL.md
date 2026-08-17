---
name: "ZStackSupport:变更方案"
description: Generate a formal ZStack operation change-proposal DOCX from analyzed change content. Invoke only when the user explicitly asks for a change-proposal document or DOCX file.
---

# 变更方案

基于标准 Word 模板输出 ZStack 运维变更方案。必须复制并修改 `assets/2021XX-XX项目XX问题-ZStack变更方案模板v1.2.docx`，不要从空白文档重造。

## 触发边界

- 只有用户明确要求“正式变更方案文件/DOCX”时才使用本技能。
- 只询问操作步骤、风险或回退建议不会隐式生成 DOCX。

## 工作流

1. 先明确 `audience` 是 `internal` 还是 `customer`。客户版必须按 [输入结构](references/input-schema.md) 确认同一收件客户身份或泛化所有标识。
2. 基于事件分析结果、客户现场信息和变更目标，补全变更方案内容。AI 负责判断和撰写，脚本只负责把内容写进模板。
3. 若缺少变更窗口、执行人、监督人、回退条件、验证动作、影响范围等关键事实，只补问最小必要信息；不要让脚本编造。
4. 使用可执行的 Python 3.10+。插件安装器会将锁定依赖安装到用户私有目录，生成器会自动将该目录加入 `sys.path`；可用 `ZSTACK_SUPPORT_PYTHONPATH` 覆盖。脚本绝不会在生成期自动联网安装。
5. 导出模板风险 checklist 操作清单：

```powershell
<python.exe> scripts/generate_change_proposal.py --print-checklist
```

6. AI 逐项判断本次变更是否真的执行 checklist 中的某个“操作”。只有实际执行该操作时，才在 JSON 里写 `checklist_items` 或 `checklist_decisions`。
7. 使用脚本生成 DOCX：

```powershell
<python.exe> scripts/generate_change_proposal.py input.json --out output.docx
```

8. 生成后必须调用 `$ZStackSupport:脱敏检查` 按 JSON 中的 `internal` 或 `customer` 受众复核输出；未通过不得交付。生成器确定性扫描不是完整分享批准。
9. 按文档规则渲染并检查页面 PNG。LibreOffice/`soffice` 不是生成 DOCX 的硬依赖；若不可用，明确说明未完成自动视觉渲染 QA。

## Checklist 规则

- checklist 是人工/AI 审核结论，不是关键词搜索结果。
- 默认不勾选任何 checklist 行。
- 优先使用 `--print-checklist` 输出的稳定 `row_id`。也可使用唯一的操作名，或 `module + operation + impact` 精确消歧。
- 同名 operation 只写操作名会失败，未匹配项也会失败，不再以警告后生成。
- `checklist_decisions[].involved` 和 `mark_unmatched_checklist_as_no` 必须为 JSON 布尔值；字符串 `"false"` 会被拒绝。
- 不要用“业务、授权、许可证、平台、变更、回退、风险、功能、服务、告警、验证、网络、云主机”等泛词推断 checklist。
- `checklist_keywords` 已删除；作为未知字段传入时会失败。
- 风险正文可以写本次变更的具体风险；模板 checklist 只标记实际执行的模板高/中风险运维操作。
- 如果某个操作是否涉及不确定，保持空白并在方案正文或待确认项中说明，不要勾“是”。

## 模板约束

- 保留模板的封面、一级/二级标题、配置信息表、风险 checklist、回退方案、紧急预案和变更计划结构。
- 只替换模板中的项目、问题、变更步骤、风险预案、回退方案、执行计划等业务内容。
- 保持主题字体；正文和表格行间距统一为 1.5。
- 重要标签、风险级别、执行/回退/验证动作、用户用 `**重点**` 标出的内容必须加粗。
- 客户交付版本不得包含凭证、原始 MCP 载荷、未脱敏客户日志或没有证据支撑的根因断言。
- 客户版禁止任意 IP/GUID、内部工单编号、BBS/Jira/Confluence 绝对或相对链接、受控端点、批注、修订、隐藏文本、未知 OOXML 关系和嵌入可执行内容；外部超链接只允许 HTTP(S)。
- `internal` 和 `customer` 都禁止 Bearer/Basic 凭据、密码/Token/Secret 赋值、普通/加密/PGP 私钥标记、常见云端/代码托管 Token 和 URL userinfo 凭据。

## 脚本边界

`scripts/generate_change_proposal.py` 是模板渲染器：

- 默认读取本技能 `assets/` 下的标准模板。
- 支持 `--template` 指定新版模板。
- 支持 `--print-checklist` 输出模板 checklist 行，供 AI 审核。
- 支持 `--print-template` 实际探测封面、配置表、正文段和 checklist 结构。
- 严格校验 JSON 必填项、类型、未知字段、重复键、`audience` 和明显凭据，支持 UTF-8 BOM。需要待确认的事实必须显式写“待补充/待确认”。
- 按 JSON 写入模板，保留原 run 字号、字体、加粗与表格对齐，对文档段落应用 1.5 倍行距，仅修改明确内容与重点格式。
- 原子写入输出，拒绝覆盖输入 JSON 或模板；清理核心/扩展/WPS/customXml 元数据、`rsid`/`docId` 追踪标识和自定义文档变量。
- 将 TOC 字段标记为待更新，并在模板结构或 checklist 漂移时失败。
- 不生成业务内容、不补默认步骤、不根据关键词判断风险 checklist。

输入字段参考 [输入结构](references/input-schema.md)。使用可执行的 Python 3.10+ 运行脚本，`python-docx` 由安装器安装到用户私有目录；不依赖本机全局包。
