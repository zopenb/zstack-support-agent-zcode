---
name: "ZStackSupport:交接摘要"
description: Generate an audience-explicit, channel-safe handoff summary from current ZStack case analysis, including evidence labels, maturity levels, source boundaries, and closure state.
---

# 交接摘要

从当前案例证据和分析结果生成可继续工作的交接文档。输出必须明确 `受众：internal` 或 `受众：customer`；如果用户意图不明确，默认生成 `internal` 草稿并明确标注，不得声称可直接发给客户。

当前事件尚未分析时，先使用 `@ZStackSupport:事件分析`。格式参考 [案例模板](../ZStack%20Support%20Knowledge/references/case-template.md)，受众边界参考 [渠道安全策略](../ZStack%20Support%20Knowledge/references/security-policy.md)。

## 输出结构

```text
## 交接摘要

- 受众：internal / customer
- 问题摘要：
- 影响范围：
- 时间线：
- 关键对象（已去标识化）：
- 最强证据：

### 关键断言

| ID | 关键断言 | 公开标签 | 成熟度 | 来源类型 | 来源定位 | 能支持的范围 | 不能支持的范围 |
|----|----------|----------|--------|----------|----------|--------------|----------------|
| A1 | | 已确认/较可能/可能/证据缺失 | E0-E5 | 当前事件/GitHub/官网文档/BBS/Tavily或公开Web/Jira/Confluence | | | |

- 已执行操作：
- 已排除方向：
- 未完成查证：
- 下一责任人：
- 客户安全下一步行动：

### 多维闭环决策

- 闭环状态（单选）：收集中 / 诊断中 / 待客户验证 / 待研发决策 / 监控中 / 已关闭
- 处置（多选）：
- 分类（多选）：
- 产物（多选）：
- 当前最高证据成熟度：
- 剩余缺失证据：
- 关闭验收条件：
```

## 规则

1. 每个关键断言同时填写公开标签、E0-E5 成熟度、来源类型和边界。不要用一段笼统“参考证据”代替逐断言映射。
2. 来源类型和成熟度分开。GitHub、官网、BBS、Jira 或 Confluence 没有固定等级；修复提交、版本发布或 Jira 关闭本身不是 E5。
3. 只把当前事件处置后恢复验证和约定复测完成的断言标为 E5；只有达到 E5 才能把闭环状态写为“已关闭”。
4. `internal` 必须保留上游已命中的 BBS/Jira/Confluence 编号、标题摘要和合规 Markdown 直达链接；上游未返回完整 URL 时保留“直达链接未返回”状态，不得猜测。仍禁止原文、评论、附件、凭证、许可证内容和原始 MCP 载荷。
5. `customer` 禁止所有内部链接、内部端点、未经批准的内部编号/标题和内部操作细节，只保留脱敏事实、适用边界与客户安全行动。
6. 不包含客户原始日志、截图、抓包或完整命令输出；关键对象只保留类型，UUID、IP、账号、项目名和主机名删除或泛化。
7. 行动建议默认只读或客户安全。高风险操作只有在已有授权、回滚和中止条件时才能列入，并明确状态。
8. 闭环状态单选；处置、分类和产物多选。不要把“临时规避、追踪缺陷、知识更新”写成状态。

生成后建议使用 `@ZStackSupport:脱敏检查`，并传入与本摘要一致的受众。
