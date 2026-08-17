# 故障报告输入结构

生成器读取 UTF-8 或 UTF-8 BOM JSON。根 JSON 必须是对象，未知字段或任意层级的重复键都会导致失败。生成器不推断业务事实，也不会用模板样例补齐空值。

## 严格校验规则

- 下文列出的所有字段均必填。
- `audience` 必填且只能是 `internal` 或 `customer`。
- 基础信息字段必须是非空字符串。
- `fault_description`、`analysis_process`、`root_cause_analysis` 必须是非空字符串，或非空字符串数组。
- `improvement_plan` 可继续使用非空字符串或字符串数组，也可使用结构化改进项数组；两种形式可混用。
- 尚未确认的事实可显式写 `待补充` 或 `待确认`；缺字段、空字符串、`null`、空数组都会失败。
- `root_cause_analysis` 必须出现证据边界或结论状态，例如 `证据边界：待补充`、`初步判断，仍需确认`、`已闭环`。
- 文本中可使用 `**重点内容**` 标记局部加粗。冒号前标签只加粗标签；普通正文不会继承模板粗体。
- 无手工编号的普通数组条目使用 Word 原生编号。已包含 `1.`、`1、` 或 `**1.**` 等编号时不会再次编号；重复的同号前缀会规范化为一个。
- `internal` 和 `customer` 都拒绝明显凭据，包括 Bearer/Basic 凭据、密码/Token/Secret 赋值、普通/加密/PGP 私钥标记、URL userinfo 及常见云端或代码托管 Token。

## 客户版身份契约

当 `audience` 为 `customer` 时，必须增加 `customer_identity_handling`：

- `confirmed_same_customer`：仅当文档直接交付同一客户，且用户已明确确认项目、客户名称和联系人均属于该收件客户时使用。不得包含第三方标识。
- `generalized`：必须将 `project_name`、`customer_name`、`customer_contact` 分别精确写为 `项目（已泛化）`、`客户（已泛化）`、`客户联系人（已泛化）`。

客户版在写入前和原子发布前都会扫描内容，拒绝任意 IP/IPv6（含常见混淆形式）、GUID/UUID、`TIC/BUG/SUG/JIRA-NNN`、编码或明文的 BBS/Jira/Confluence 绝对/相对链接、内网/文件端点、批注、修订和隐藏文本。发布前还会按 OOXML Relationship 与 Content Types 图检查所有可达部件，只接受批准的标准关系和 HTTP(S) 外部超链接，并拒绝孤儿/未知部件、外部图片/附加模板、嵌入对象、ActiveX、宏、缩略图和非标准模板媒体哈希。`internal` 不得传入 `customer_identity_handling`。

上述确定性扫描不等于完整分享批准。无论 `audience` 是 `internal` 还是 `customer`，生成后都必须通过 `$ZStackSupport:脱敏检查` 的同受众复核；未通过不得交付。

## 必填字段

| 字段 | 写入位置 |
| --- | --- |
| `audience` | 输出受众契约，不写入正文 |
| `report_title` | 封面主标题 |
| `report_subtitle` | 封面副标题 |
| `project_name` | 项目名称 |
| `customer_name` | 客户名称 |
| `fault_impact_scope` | 故障影响和范围 |
| `customer_contact` | 客户联系人 |
| `reporter` | 故障报告人 |
| `software_product` | 软件产品 |
| `version` | 版本号 |
| `fault_start_time` | 故障发生时间 |
| `business_recovery_time` | 业务恢复时间 |
| `fault_duration` | 故障总耗时长 |
| `fault_category` | 故障类别 |
| `responsible_department` | 故障责任部门 |
| `fault_level` | 故障级别 |
| `fault_description` | 故障情况描述 |
| `analysis_process` | 分析处理过程 |
| `root_cause_analysis` | 原因分析 |
| `improvement_plan` | 后续改进与预防方案；支持旧文本和结构化改进项 |

## 结构化改进措施

推荐使用结构化对象表达可执行措施：

```json
{
  "title": "取证增强",
  "prerequisites": ["维护窗口可用"],
  "actions": ["保持 kdump", "配置 netconsole"],
  "owner": "待指定",
  "validation": ["确认 vmcore 及远程日志可落盘"],
  "rollback": [],
  "high_risk": false
}
```

- `title`、`prerequisites`、`actions`、`owner`、`validation`、`rollback` 必须显式提供。
- `actions` 至少包含一项；其他数组在不适用时可为空。
- `owner` 不得为空；无法确认时写 `待指定`。
- `high_risk` 可选，默认为 `false`。设为 `true` 时，`prerequisites`、`validation`、`rollback` 都必须非空。
- 生成器只校验结构并稳定渲染，不判断某项措施是否高风险，也不补写业务内容。

## 完整示例

```json
{
  "audience": "internal",
  "report_title": "云平台资源操作异常故障报告",
  "report_subtitle": "——问题故障报告",
  "project_name": "XX项目",
  "customer_name": "XX客户",
  "fault_impact_scope": "影响范围待补充。",
  "customer_contact": "待补充",
  "reporter": "待补充",
  "software_product": "ZStack Cloud",
  "version": "待补充",
  "fault_start_time": "待补充",
  "business_recovery_time": "待补充",
  "fault_duration": "待补充",
  "fault_category": "软件",
  "responsible_department": "技术支持",
  "fault_level": "待确认",
  "fault_description": [
    "故障现象：待补充。",
    "影响对象：待补充。"
  ],
  "analysis_process": [
    "时间：待补充；动作：收集现场证据；结果：待补充。"
  ],
  "root_cause_analysis": [
    "初步判断：待补充，仍需确认。",
    "证据边界：待补充。"
  ],
  "improvement_plan": [
    {
      "title": "取证增强",
      "prerequisites": ["维护窗口可用"],
      "actions": ["保持 kdump", "配置 netconsole"],
      "owner": "待指定",
      "validation": ["确认 vmcore 及远程日志可落盘"],
      "rollback": [],
      "high_risk": false
    }
  ]
}
```

## 路径与输出

- 输入、模板和输出都会解析为绝对路径。
- 输出必须是 `.docx`，不得与输入 JSON 或模板同路径。
- 只有输入校验、内容规范化、模板写入、格式规范化、元数据清理、脱敏与关系检查、格式结构审计全部成功后，才会原子替换输出。
- 通过安全和格式审计后生成器不再修改 DOCX；任何后续修改都必须重新执行完整链路。
- `--print-template` 会实际打开模板并探测每个可写目标；不是静态字段清单。
