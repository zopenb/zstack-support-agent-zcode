---
name: "ZStackSupport:知识库"
description: Internal knowledge base for ZStack support workflow methodology, case templates, and security policy. Referenced by other skills, not directly invoked by users.
---

# ZStack 支持工作流知识库

本知识库包含 ZStack 渠道支持工作流的核心方法论、案例模板和安全策略。其他技能在需要时自动引用此处的内容。

## 引用方式

- [工作流方法论](references/workflow-methodology.md) — 来源类型与证据成熟度分离、断言映射和多维闭环方法论
- [查证路由规则](references/evidence-routing.md) — 唯一的入口判断、查询去标识化、内部知识优先、GitHub 硬约束和 subagent 路由规则
- [案例模板](references/case-template.md) — 案例目录结构、元数据格式、notes.md 骨架、证据和参考条目格式
- [安全策略](references/security-policy.md) — internal/customer 受众边界、受控端点例外、提交规则和 MCP 只读边界
- [日志路径基准](references/log-paths.md) — 管理节点、计算节点日志路径和只读定位规则，避免编造不存在的日志路径
- [官网文档映射](references/docs-mapping.md) — ZStack 官网文档 URL 目录映射表（含开发手册章节索引），供 WebFetch 实时抓取产品手册、教程和 FAQ
- [用户手册章节索引](references/chapter-index-user-guide.md) — 用户手册 V5/V4 的 47 个章节页标题与关键词路由
- [CLI手册章节索引](references/chapter-index-cli-manual.md) — CLI 命令手册 V5/V4 的 36+ 个章节页标题与命令关键词路由
- [运维手册章节索引](references/chapter-index-maintenance-manual.md) — 运维手册 V5/V4 的 19 个章节页标题与运维关键词路由

## 使用场景

- 事件分析技能在分析过程中引用查证路由规则和工作流方法论，按问题类型选择直答、追问、单点查证或内部知识优先的多来源查证
- 事件分析技能在建议日志收集命令时引用日志路径基准；未列出的组件路径必须先用只读命令定位
- 交接摘要技能引用案例模板确保输出格式一致
- 脱敏检查技能引用安全策略确保检查标准一致
- 源码查证技能引用查证路由规则作为单点源码求证路径，必要时再引用官网文档映射补充官方文档参考
