# 变更方案输入结构

生成器读取 UTF-8 或 UTF-8 BOM JSON。根 JSON 必须是对象，未知字段或任意层级的重复键都会导致失败。生成器不推断业务事实，也不会用模板样例补齐空值。

## 严格校验规则

- 字符串必须非空；正文字段可为非空字符串，或非空字符串数组。
- `audience` 必填且只能是 `internal` 或 `customer`。
- 尚未确认的事实可显式写 `待补充` 或 `待确认`；缺字段、空字符串、`null` 和空正文数组均会失败。
- 文本中可使用 `**重点内容**` 标记加粗。
- `checklist_items` 和 `checklist_decisions` 至少要出现一个；空数组表示已审核且无涉及项，是合法的。
- `internal` 和 `customer` 都拒绝明显凭据，包括 Bearer/Basic 凭据、密码/Token/Secret 赋值、普通/加密/PGP 私钥标记、URL userinfo 及常见云端或代码托管 Token。

## 客户版身份契约

当 `audience` 为 `customer` 时，必须增加 `customer_identity_handling`：

- `confirmed_same_customer`：仅当文档直接交付同一客户，且用户已明确确认文档中项目/客户/联系人只属于该收件客户时使用。不得包含第三方标识。
- `generalized`：输入编写者确认所有客户、项目、联系人和第三方标识已泛化。

客户版在写入前和原子发布前都会扫描内容，拒绝任意 IP/IPv6（含常见混淆形式）、GUID/UUID、`TIC/BUG/SUG/JIRA-NNN`、编码或明文的 BBS/Jira/Confluence 绝对/相对链接、内网/文件端点、批注、修订和隐藏文本。发布前还会按 OOXML Relationship 与 Content Types 图检查所有可达部件，只接受批准的标准关系和 HTTP(S) 外部超链接，并拒绝孤儿/未知部件、外部图片/附加模板、嵌入对象、ActiveX、宏、缩略图和非标准模板媒体哈希。`internal` 不得传入 `customer_identity_handling`。

上述确定性扫描不等于完整分享批准。无论 `audience` 是 `internal` 还是 `customer`，生成后都必须通过 `$ZStackSupport:脱敏检查` 的同受众复核；未通过不得交付。

## 必填字段

`audience`、`cover_title`、`change_title`、`risk_level`、`document_date`、`software_info`、`hardware_config`、`business_info`、`overview`、`change_principles`、`overall_flow`、`detailed_steps`、`risks`、`risk_mitigations`、`rollback_plan`、`emergency_plan`。

变更计划必须二选一：

- 提供 `change_plan` 正文；或
- 同时提供 `change_time`、`maintenance_window`、`executor`、`executor_phone`、`supervisor`、`supervisor_phone` 六个字符串。

两种变更计划形式不得混用。

## Checklist 选择器

先运行：

```powershell
<python.exe> scripts/generate_change_proposal.py --print-checklist
```

输出来自模板实时探测，每行包含稳定 `row_id`、`row_index`、`module_id`、`module`、`operation`、`impact`、`level`。`row_id` 基于 `module_id + operation + impact + level` 生成，不因模板前方插入新行而变化。

模板必须完整包含以下精确模块/等级契约；模块名和等级不做子串推断，缺失、未知或等级冲突都会失败：

| `module_id` | 模块 | 等级 |
| --- | --- | --- |
| `cloud-platform-unmount` | 云平台/卸载 | 高 |
| `cloud-platform-delete` | 云平台/删除 | 高 |
| `host-layer-change` | 底层/变更 | 高 |
| `distributed-storage-high` | 分布式/存储/高风险 | 高 |
| `distributed-storage-medium` | 分布式/存储/中风险 | 中 |
| `network` | 网络 | 高 |
| `other-medium-high` | 其他/中高/风险 | 高 |

`checklist_items` 中的每项可以是：

- 唯一的 operation 字符串；
- `{"row_id": "cl-..."}`；
- `{"module_id": "...", "operation": "...", "impact": "...", "level": "..."}`；
- `{"module": "...", "operation": "...", "impact": "...", "level": "..."}`。

同名 operation 字符串会以“匹配歧义”失败；必须用 `row_id` 或 `module + operation + impact` 消歧。任何未匹配选择器都会失败。

`checklist_decisions` 的每项在同样的选择器上增加：

```json
{
  "row_id": "cl-...",
  "involved": false,
  "reason": "本次不执行该操作。"
}
```

`involved` 必须是 JSON 布尔值。`mark_unmatched_checklist_as_no` 也必须是 JSON 布尔值；字符串 `"false"` 不会被宽松转换。

## 完整示例

```json
{
  "audience": "internal",
  "cover_title": "ZStack运维变更方案",
  "change_title": "XX项目授权导入变更",
  "risk_level": "低",
  "document_date": "2026-07-12",
  "software_info": "ZStack Cloud 版本：待补充",
  "hardware_config": "本次变更不涉及硬件调整。",
  "business_info": "影响范围：待确认。",
  "overview": ["变更目标：导入已审批的授权文件。"],
  "change_principles": ["变更前确认文件来源、版本和审批结果。"],
  "overall_flow": ["检查、导入、验证、观察。"],
  "detailed_steps": ["执行动作：按审批文件执行导入。", "验证动作：确认授权状态和相关功能。"],
  "risks": ["授权文件与平台版本不匹配可能导致导入失败。"],
  "risk_mitigations": ["执行前由客户或项目负责人确认文件和变更窗口。"],
  "rollback_plan": ["回退动作：如平台支持，恢复客户确认的原授权文件。"],
  "emergency_plan": ["如出现非预期影响，立即暂停后续操作并升级处理。"],
  "change_time": "待补充",
  "maintenance_window": "待补充",
  "executor": "待补充",
  "executor_phone": "待补充",
  "supervisor": "待补充",
  "supervisor_phone": "待补充",
  "checklist_items": []
}
```

## 路径与输出

- 输入、模板和输出都会解析为绝对路径。
- 输出必须是 `.docx`，不得与输入 JSON 或模板同路径。
- 只有校验、生成、元数据清理和 ZIP 完整性检查全部成功后，才会原子替换输出。
- `--print-template` 会打开模板并探测封面、配置表、正文段和 checklist 结构。
