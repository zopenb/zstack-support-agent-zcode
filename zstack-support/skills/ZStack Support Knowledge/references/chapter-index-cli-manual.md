# ZStack Cloud CLI命令手册 — 章节索引

> 生成时间：2026-06-10 | 基于 V5.5.16 版本爬取
> 基础 URL：`https://www.zstack.io/help/product_manuals/cli_manual/{ver}/`（`{ver}` = `v5` 或 `v4`）

## 关键词路由表

根据事件关键词快速定位到具体章节页：

| 关键词/场景 | 章节页 | 标题 |
|-------------|--------|------|
| 系统架构、资源结构、异步设计 | `1.html` | 系统架构 |
| CLI 工具、zstack-cli、LogIn、LogOut | `2.html` | 命令行工具 |
| Query 查询语法、conditions、op、join | `3.html` | 查询 |
| **云主机**（Create/Destroy/Start/Stop/Reboot/Migrate/Clone/SSH密钥/密码/NUMA/CD-ROM/执行命令） | `4.1.html` | 资源中心 - 云资源池 |
| **云盘**（Create/Delete/Resize/Attach/Snapshot/QoS/Flatten） | `4.1.html` | 资源中心 - 云资源池 |
| **镜像**（Add/Delete/Template/BootMode/Hash） | `4.1.html` | 资源中心 - 云资源池 |
| 亲和组 | `4.1.html` | 资源中心 - 云资源池 |
| 云主机调度策略 | `4.1.html` | 资源中心 - 云资源池 |
| 区域(Zone)、集群(Cluster)、物理机(Host) | `4.2.html` | 资源中心 - 硬件资源 |
| GPU、PCI 透传、SR-IOV、USB | `4.2.html` | 资源中心 - 硬件资源 |
| 主存储（Local/NFS/Ceph/SharedBlock/Block） | `4.2.html` | 资源中心 - 硬件资源 |
| 镜像服务器（ImageStore/Ceph） | `4.2.html` | 资源中心 - 硬件资源 |
| SAN 存储（iSCSI/FC/NVMe） | `4.2.html` | 资源中心 - 硬件资源 |
| 物理网络、LLDP | `4.2.html` | 资源中心 - 硬件资源 |
| 二层网络（VLAN/VXLAN/NoVlan/HardwareVxlan） | `4.3.html` | 资源中心 - 网络资源 |
| SDN 控制器、NFV | `4.3.html` | 资源中心 - 网络资源 |
| 三层网络（L3/IpRange/IPv6/MTU） | `4.3.html` | 资源中心 - 网络资源 |
| VPC、VRouter、虚拟路由 | `4.3.html` | 资源中心 - 网络资源 |
| OSPF、组播路由、策略路由 | `4.3.html` | 资源中心 - 网络资源 |
| VPC 防火墙 | `4.4.html` | 资源中心 - 网络服务 |
| 安全组 | `4.4.html` | 资源中心 - 网络服务 |
| VIP、EIP、弹性 IP | `4.4.html` | 资源中心 - 网络服务 |
| 端口转发 | `4.4.html` | 资源中心 - 网络服务 |
| **负载均衡**（LB/Listener/ACL/ServerGroup/Certificate/SLB） | `4.4.html` | 资源中心 - 网络服务 |
| IPsec 隧道 | `4.4.html` | 资源中心 - 网络服务 |
| Netflow、端口镜像 | `4.4.html` | 资源中心 - 网络服务 |
| 共享带宽 | `4.4.html` | 资源中心 - 网络服务 |
| 资源编排、CloudFormation、资源栈 | `4.5.html` | 资源中心 - 资源编排 |
| 裸金属 | `4.6.html` | 资源中心 - 裸金属管理 |
| 弹性裸金属 | `4.7.html` | 资源中心 - 弹性裸金属管理 |
| vCenter、VMware | `4.8.html` | 资源中心 - VMware管理 |
| 监控（Metric/Event/Alarm/ZWatch） | `5.1.html` | 平台运维 - 云平台监控 |
| SNS 通知（邮件/钉钉/飞书/Teams/Webhook/短信） | `5.1.html` | 平台运维 - 云平台监控 |
| 灾备（VolumeBackup/VmBackup/DatabaseBackup/CDP） | `5.2.html` | 平台运维 - 灾备管理 |
| 自动化运维、脚本库 | `5.3.html` | 平台运维 - 自动化运维 |
| V2V 迁移 | `5.4.html` | 平台运维 - 迁移服务 |
| 标签（UserTag/SystemTag） | `5.5.html` | 平台运维 - 标签管理 |
| 租户管理（组织/用户/项目/角色/工单/SSO） | `6.1.html` | 运营管理 - 租户管理 |
| 计费 | `6.2.html` | 运营管理 - 计费管理 |
| 访问控制、控制台代理 | `6.3.html` | 运营管理 - 访问控制 |
| 用户管理（Account/Policy/Quota） | `7.1.html` | 设置 - 用户管理 |
| 日志服务器 | `7.2.html` | 设置 - 日志服务器 |
| 高级监控服务器 | `7.3.html` | 设置 - 高级监控服务器 |
| LDAP/OAuth/统一认证 | `7.4.html` | 设置 - AD/LDAP/OAuth |
| SNMP | `7.5.html` | 设置 - SNMP |
| 全局设置（GlobalConfig） | `7.6.html` | 设置 - 全局设置 |
| 资源高级设置 | `7.7.html` | 设置 - 资源高级设置 |
| 场景封装、一键配置模板 | `7.8.html` | 设置 - 场景封装 |
| 高可用策略（HA/NeverStop） | `7.9.html` | 设置 - 高可用策略 |
| 插件管理 | `7.10.html` | 设置 - 插件管理 |
| 时间管理、Chrony | `7.11.html` | 设置 - 时间管理 |
| 管理节点、版本信息 | `8.1.html` | 系统全局 - 管理节点 |
| 进度条、任务进度 | `8.2.html` | 系统全局 - 进度条 |
| 容量查询（CPU/Memory/Storage） | `8.3.html` | 系统全局 - 查询可用资源 |
| 垃圾回收（GC） | `8.4.html` | 系统全局 - 垃圾回收 |
| 许可证 | `8.5.html` | 系统全局 - 许可证 |
| 长时任务（LongJob/FlowChain） | `8.6.html` | 系统全局 - 长时任务 |
| 错误码（Elaborations） | `8.7.html` | 系统全局 - 系统错误码 |
| 搜索索引 | `8.8.html` | 系统全局 - 搜索 |
| CLI 场景实践 | `9.html` | CLI场景实践 |
| 术语 | `10.html` | 术语表 |

## 完整章节列表

| 章节页 | 标题 |
|--------|------|
| `1.html` | 系统架构 |
| `2.html` | 命令行工具 |
| `3.html` | 查询 |
| `4.1.html` | 资源中心 - 云资源池 |
| `4.2.html` | 资源中心 - 硬件资源 |
| `4.3.html` | 资源中心 - 网络资源 |
| `4.4.html` | 资源中心 - 网络服务 |
| `4.5.html` | 资源中心 - 资源编排 |
| `4.6.html` | 资源中心 - 裸金属管理 |
| `4.7.html` | 资源中心 - 弹性裸金属管理 |
| `4.8.html` | 资源中心 - VMware管理 |
| `5.1.html` | 平台运维 - 云平台监控 |
| `5.2.html` | 平台运维 - 灾备管理 |
| `5.3.html` | 平台运维 - 自动化运维 |
| `5.4.html` | 平台运维 - 迁移服务 |
| `5.5.html` | 平台运维 - 标签管理 |
| `6.1.html` | 运营管理 - 租户管理 |
| `6.2.html` | 运营管理 - 计费管理 |
| `6.3.html` | 运营管理 - 访问控制 |
| `7.1.html` | 设置 - 用户管理 |
| `7.2.html` | 设置 - 日志服务器 |
| `7.3.html` | 设置 - 高级监控服务器 |
| `7.4.html` | 设置 - AD/LDAP/OAuth |
| `7.5.html` | 设置 - SNMP |
| `7.6.html` | 设置 - 全局设置 |
| `7.7.html` | 设置 - 资源高级设置 |
| `7.8.html` | 设置 - 场景封装 |
| `7.9.html` | 设置 - 高可用策略 |
| `7.10.html` | 设置 - 插件管理 |
| `7.11.html` | 设置 - 时间管理 |
| `8.1.html` | 系统全局 - 管理节点 |
| `8.2.html` | 系统全局 - 进度条 |
| `8.3.html` | 系统全局 - 查询可用资源 |
| `8.4.html` | 系统全局 - 垃圾回收 |
| `8.5.html` | 系统全局 - 许可证 |
| `8.6.html` | 系统全局 - 长时任务 |
| `8.7.html` | 系统全局 - 系统错误码 |
| `8.8.html` | 系统全局 - 搜索 |
| `9.html` | CLI场景实践 |
| `10.html` | 术语表 |
