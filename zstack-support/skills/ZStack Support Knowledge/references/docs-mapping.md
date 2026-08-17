# ZStack 官网文档目录映射

当分析过程中需要查阅产品文档时，根据事件关键词匹配以下 URL，使用 WebFetch 工具实时抓取对应页面内容。

## 目录

1. [版本说明](#版本说明)
2. [URL 路由规则](#url-路由规则)
3. [完整文档 URL 清单](#完整文档-url-清单)
4. [正文页 URL 模式](#正文页-url-模式)
5. [索引优先级](#索引优先级)
6. [使用方法](#使用方法)
7. [注意事项](#注意事项)

**基础 URL**：`https://www.zstack.io`

## 版本说明

ZStack 官网文档提供两个大版本，URL 结构一致，仅版本号不同：

| 版本 | URL 中的版本标识 | 适用场景 |
|------|------------------|----------|
| **V5（当前主力）** | `/v5` 或 `/v5/` | ZStack Cloud 5.x 系列（最新 5.5.16） |
| **V4（LTS 版本）** | `/v4` 或 `/v4/` | ZStack Cloud 4.x 系列（最新 4.8.10） |

**版本选择规则**：
- 如果事件/工单中明确了客户版本号，优先使用对应版本文档
- 如果问题涉及操作步骤、兼容性、限制或客户版本结论而版本未明确，先询问最小版本信息；不得用 V5 文档替代客户版本结论
- 如果只做产品概览，可并列 V4/V5，或暂用最新文档了解方向，但必须标注“客户版本待确认，不能据此下版本边界结论”
- V4 和 V5 的文档路径结构相同，只需将 URL 中的 `v5` 替换为 `v4` 即可

## URL 路由规则

根据事件涉及的关键词选择文档类别（路径中 `{ver}` 代表版本号，取值为 `v4` 或 `v5`）：

| 关键词/场景 | 文档类别 | 优先 URL（将 `{ver}` 替换为 `v4` 或 `v5`） |
|-------------|----------|---------------------------------------------|
| 安装、部署、环境搭建 | 快速入门 | `/help/tutorials/quick_install_guide/{ver}/` |
| 升级、版本升级 | 升级教程 | `/help/tutorials/upgrade_guide/{ver}/` |
| 存储、Ceph、主存储、备份存储、Shared Block | 用户手册（存储章节） | `/help/product_manuals/user_guide/{ver}/` |
| 网络、VPC、扁平网络、VLAN、安全组 | 用户手册（网络章节） | `/help/product_manuals/user_guide/{ver}/` |
| SDN、软件定义网络 | SDN 教程 | `/help/tutorials/sdn_tutorial/{ver}/` |
| 云主机、VM、镜像、快照、模板 | 用户手册（计算章节） | `/help/product_manuals/user_guide/{ver}/` |
| 模板封装、ISO、CentOS、Windows、Ubuntu、Kylin、Rocky | 模板封装教程 | `/help/tutorials/centos7_template_tutorial/{ver}/` `/help/tutorials/windows_2008r2_template_tutorial/{ver}/` |
| zstackctl、CLI 命令、API 调用 | CLI 手册 / CTL 手册 | `/help/product_manuals/cli_manual/{ver}/` `/help/product_manuals/ctl_manual/{ver}/` |
| 运维、监控、告警、日志、ZWatch、SNMP | 运维手册 | `/help/product_manuals/maintenance_manual/{ver}/` |
| ZWatch 监控报警 | ZWatch 教程 | `/help/tutorials/zwatch_tutorial/{ver}/` |
| SNMP 对接 | SNMP 教程 | `/help/tutorials/snmp_tutorial/{ver}/` |
| 高可用、HA、故障恢复 | 用户手册（HA 章节） | `/help/product_manuals/user_guide/{ver}/` |
| 管理节点高可用 | 多管理节点 HA | `/help/tutorials/double_mn_ha_solution/{ver}/` |
| 系统恢复、故障恢复 | 系统恢复教程 | `/help/tutorials/system_recovery_tutorial/{ver}/` |
| GPU、vGPU、裸金属、PCI 透传、USB 透传、SR-IOV | 透传/虚拟化教程 | `/help/tutorials/vgpu_passthrough_tutorial/{ver}/` `/help/tutorials/baremetal_deploy_tutorial/{ver}/` |
| NUMA、性能优化、SPICE | 性能/虚拟化 | `/help/tutorials/numa_configuration_tutorial/{ver}/` `/help/tutorials/spice_intro/{ver}/` |
| 计费、账户、权限、多租户 | 账户 / 计费教程 | `/help/tutorials/account_intro/{ver}/` `/help/tutorials/billing_intro/{ver}/` |
| 安全、认证、审计、加密、HTTPS | 安全白皮书 | `/help/product_manuals/security_white_paper/{ver}/` |
| HTTPS 配置 | HTTPS 教程 | `/help/tutorials/https_tutorial/{ver}/` |
| 常见报错、已知问题、FAQ | 常见问题 | `/help/FAQ/{ver}/` |
| 版本功能、新特性、版本差异 | 版本特性 / 发布历史 | `/help/release_notes/{ver}/` `/help/product_manuals/release_history/{ver}` |
| 开发、SDK、插件开发、API 参考 | 开发手册 | `/help/dev_manual/dev_guide/{ver}/` |
| 资源编排、CloudFormation | 资源编排教程 | `/help/tutorials/cloud_formation_tutorial/{ver}/` |
| 灾备、备份、恢复 | 灾备教程 | `/help/tutorials/dr_module_tutorial/{ver}/` |
| vCenter、混合云、VMware、V2V 迁移 | vCenter / 混合云教程 | `/help/tutorials/vcenter_guide/{ver}/` `/help/tutorials/hybrid_cloud_tutorial/{ver}/` |
| 弹性伸缩、调度策略、QoS | 伸缩 / 调度 / QoS | `/help/tutorials/auto_scaling_tutorial/{ver}/` `/help/tutorials/vm_scheduling_policy/{ver}/` `/help/tutorials/qos_tutorial/{ver}/` |
| 企业管理、多组织 | 企业管理教程 | `/help/tutorials/co_module_tutorial/{ver}/` |
| 日志服务器 | 日志服务器教程 | `/help/product_manuals/log_server_tutorial/{ver}/` |
| 非 root 用户 | 非 root 用户指南 | `/help/tutorials/non_root_user_guide/{ver}/` |
| 主机网络配置 | 主机网络教程 | `/help/tutorials/host_network_cfg_tutorial/{ver}/` |
| Logo 定制、UI 自定义 | Logo 定制教程 | `/help/tutorials/logo_custom_guide/{ver}/` |
| 云平台运维 SOP | 运维 SOP | `/help/tutorials/cloud_platform_sop/{ver}/` |
| 应用市场 | 应用市场教程 | `/help/tutorials/application_market_tutorial/{ver}/` |
| ZSphere（轻量版） | ZSphere 文档 | `/help/zstack_zsphere/product_manuals/` |
| ZStack Cube 旗舰版（超融合） | Cube 旗舰版文档 | `/help/zstack_cube/product_manuals/` |
| ZStack Cube 虚拟化版 / HCI | Cube HCI 文档 | `/help/zstack_cube_hci/product_manuals/` |
| ZStack Cube 双引擎版 | Cube 双引擎文档 | `/help/zstack_cube_dual_engine/product_manuals/` |
| ZStack Edge | Edge 文档 | `/help/zstack_edge/product_manuals/` |
| ZStack CMP（多云管理） | CMP 文档 | `/help/zstack_cmp/product_manuals/` |
| ZStack Zaku | Zaku 文档 | `/help/zstack_zaku/product_manuals/` |

## 完整文档 URL 清单

### ZStack Cloud V5

**手册类**：
- 产品手册总入口：`/help/product_manuals/v5/`
- 用户手册：`/help/product_manuals/user_guide/v5/`
- 技术白皮书：`/help/product_manuals/white_paper/v5/`
- 安全白皮书：`/help/product_manuals/security_white_paper/v5/`
- 运维手册：`/help/product_manuals/maintenance_manual/v5/`
- CTL 命令手册：`/help/product_manuals/ctl_manual/v5/`
- CLI 命令手册：`/help/product_manuals/cli_manual/v5/`
- 日志服务器教程：`/help/product_manuals/log_server_tutorial/v5/`
- SR-IOV VF 教程：`/help/product_manuals/sr_iov_vf_tutorial/v5/`
- 发布历史：`/help/product_manuals/release_history/v5`

**开发手册（含章节级映射）**：
- 开发手册入口：`/help/dev_manual/v5/`
- 开发指南：`/help/dev_manual/dev_guide/v5/`

开发指南章节索引（API 检索时优先使用具体章节页）：
| 章节页 | 内容 | 涉及的 API / 关键词 |
|--------|------|---------------------|
| `1.html` | API 使用规范 | HTTP方法、传参方式、返回码、查询API(ZQL)、Webhook |
| `2.html` | SDK 使用规范 | Java SDK、Python SDK 使用示例 |
| `3.html` | AK 调用 API | CreateAccessKey、认证鉴权 |
| `4.1.html` | **云主机（VM）API** | CreateVmInstance、**DestroyVmInstance**、StartVmInstance、StopVmInstance、RebootVmInstance、MigrateVm、CloneVmInstance、ChangeVmPassword、AttachIsoToVmInstance、GetVmCapabilities、UpdateVmInstance、ExecuteGuestVmCommand |
| `4.3.html` | 网络资源（SDN 设备） | SDN、网络服务设备相关 API |
| `4.4.html` | 网络服务 | GetNetworkServiceTypes、QueryNetworkServiceProvider |
| `5.1.html` | 监控（ZWatch） | GetMetricData、PutMetricData、GetAllMetricMetadata、事件/报警器 API |
| `6.1.html` | 运营管理 | 运营相关 API |
| `7.1.html` | 用户管理 | CreateAccount、DeleteAccount、QueryAccount 等 44 个 API |
| `7.2.html` | 日志服务器 | 日志服务器增删改查 API |
| `8.1.html` | 系统全局 | 系统级配置、全局参数 API |
| `8.4.html` | 许可证 | GetLicenseInfo、DeleteLicense、UpdateLicense、PushLicenseAddOnsUsage |

**其他手册章节索引**（查阅产品操作、CLI 命令、运维操作时，先到对应索引文件定位具体章节页再抓取）：
- 用户手册章节索引：[chapter-index-user-guide.md](chapter-index-user-guide.md) — 47 个章节页，覆盖云主机/存储/网络/安全/监控/灾备/运维/运营等全部产品功能
- CLI 命令手册章节索引：[chapter-index-cli-manual.md](chapter-index-cli-manual.md) — 36+ 个章节页，覆盖数百个 CLI API 命令的分组和关键词
- 运维手册章节索引：[chapter-index-maintenance-manual.md](chapter-index-maintenance-manual.md) — 19 个章节页，覆盖安装/网络/管理节点运维/日志分析/故障排查等

**实践教程**：

总入口：
- 教程总入口：`/help/tutorials/v5/`
- 私有云教程：`/help/tutorials/private_cloud/v5/`
- 扩展组件：`/help/tutorials/addons/v5/`
- 其他扩展：`/help/tutorials/other_addons/v5/`
- 授权相关：`/help/tutorials/authorization/v5/`

基础教程：
- 快速安装入门：`/help/tutorials/quick_install_guide/v5/`
- 升级教程：`/help/tutorials/upgrade_guide/v5/`
- 主机网络配置：`/help/tutorials/host_network_cfg_tutorial/v5/`
- 非 root 用户指南：`/help/tutorials/non_root_user_guide/v5/`

模板封装教程：
- CentOS6 模板：`/help/tutorials/centos6_template_tutorial/v5/`
- CentOS7 模板：`/help/tutorials/centos7_template_tutorial/v5/`
- CentOS8 模板：`/help/tutorials/centos8_template_tutorial/v5/`
- Rocky8 模板：`/help/tutorials/rocky8_template_tutorial/v5/`
- Ubuntu 模板：`/help/tutorials/ubuntu_template_tutorial/v5/`
- Kylin 模板：`/help/tutorials/kylin_template_tutorial/v5/`
- Windows XP 模板：`/help/tutorials/windows_xp_template_tutorial/v5/`
- Windows 2003R2 模板：`/help/tutorials/windows_2003r2_template_tutorial/v5/`
- Windows 2008R2 模板：`/help/tutorials/windows_2008r2_template_tutorial/v5/`

存储与网络教程：
- Shared Block-FC 部署：`/help/tutorials/shared_block_fc_deploy_tutorial/v5/`
- Shared Block-iSCSI 部署：`/help/tutorials/shared_block_iscsi_deploy_tutorial/v5/`
- VPC 专有网络：`/help/tutorials/vpc_tutorial/v5/`
- 扁平网络：`/help/tutorials/flat_tutorial/v5/`
- SDN 网络：`/help/tutorials/sdn_tutorial/v5/`

运维与平台能力教程：
- 资源编排：`/help/tutorials/cloud_formation_tutorial/v5/`
- 监控报警 ZWatch：`/help/tutorials/zwatch_tutorial/v5/`
- SNMP 对接：`/help/tutorials/snmp_tutorial/v5/`
- 系统恢复：`/help/tutorials/system_recovery_tutorial/v5/`
- 云平台运维 SOP：`/help/tutorials/cloud_platform_sop/v5/`
- Logo 定制：`/help/tutorials/logo_custom_guide/v5/`
- HTTPS 配置：`/help/tutorials/https_tutorial/v5/`

账户/计费/租户：
- 账户管理：`/help/tutorials/account_intro/v5/`
- 计费功能：`/help/tutorials/billing_intro/v5/`
- 企业管理：`/help/tutorials/co_module_tutorial/v5/`

透传/虚拟化/性能：
- GPU 透传：`/help/tutorials/vgpu_passthrough_tutorial/v5/`
- vGPU 虚拟化：`/help/tutorials/gpu_passthrough_tutorial/v5/`
- USB 透传：`/help/tutorials/usb_passthrough_tutorial/v5/`
- 块设备透传：`/help/tutorials/block_passthrough_tutorial/v5/`
- NUMA 配置：`/help/tutorials/numa_configuration_tutorial/v5/`
- SPICE 协议：`/help/tutorials/spice_intro/v5/`

高级功能：
- 弹性伸缩：`/help/tutorials/auto_scaling_tutorial/v5/`
- 云主机高可用：`/help/tutorials/vm_ha_guide/v5/`
- 磁盘快照：`/help/tutorials/volume_snapshot_tutorial/v5/`
- QoS 使用：`/help/tutorials/qos_tutorial/v5/`
- 调度策略：`/help/tutorials/vm_scheduling_policy/v5/`
- 应用市场：`/help/tutorials/application_market_tutorial/v5/`

迁移/灾备/混合云/vCenter：
- vCenter 管理：`/help/tutorials/vcenter_guide/v5/`
- V2V 迁移服务：`/help/tutorials/v2v_migration_tutorial/v5/`
- 混合云：`/help/tutorials/hybrid_cloud_tutorial/v5/`
- 灾备服务：`/help/tutorials/dr_module_tutorial/v5/`

裸金属：
- 裸金属管理：`/help/tutorials/baremetal_deploy_tutorial/v5/`
- 弹性裸金属：`/help/tutorials/elastic_baremetal_deploy_tutorial/v5/`

**FAQ**：
- 常见问题入口：`/help/FAQ/v5/`
- ZStack FAQ：`/help/FAQ/zstack_faq/v5/`

**版本信息**：
- 版本特性：`/help/release_notes/v5/`

### ZStack Cloud V4（4.8 LTS）

**手册类**：
- 产品手册总入口：`/help/product_manuals/v4/`
- 用户手册：`/help/product_manuals/user_guide/v4/`
- 技术白皮书：`/help/product_manuals/white_paper/v4/`
- 安全白皮书：`/help/product_manuals/security_white_paper/v4/`
- 运维手册：`/help/product_manuals/maintenance_manual/v4/`
- CTL 命令手册：`/help/product_manuals/ctl_manual/v4/`
- CLI 命令手册：`/help/product_manuals/cli_manual/v4/`

**开发手册**：
- 开发指南：`/help/dev_manual/dev_guide/v4/`

**实践教程**：
- 快速安装入门：`/help/tutorials/quick_install_guide/v4/`
- 升级教程：`/help/tutorials/upgrade_guide/v4/`
- CentOS7 模板：`/help/tutorials/centos7_template_tutorial/v4/`
- Windows 2008R2 模板：`/help/tutorials/windows_2008r2_template_tutorial/v4/`
- Shared Block-FC 部署：`/help/tutorials/shared_block_fc_deploy_tutorial/v4/`
- Shared Block-iSCSI 部署：`/help/tutorials/shared_block_iscsi_deploy_tutorial/v4/`
- 扁平网络：`/help/tutorials/flat_tutorial/v4/`
- VPC 专有网络：`/help/tutorials/vpc_tutorial/v4/`
- 监控报警 ZWatch：`/help/tutorials/zwatch_tutorial/v4/`
- 账户管理：`/help/tutorials/account_intro/v4/`
- 计费功能：`/help/tutorials/billing_intro/v4/`
- 云主机高可用：`/help/tutorials/vm_ha_guide/v4/`
- 磁盘快照：`/help/tutorials/volume_snapshot_tutorial/v4/`
- 多管理节点高可用：`/help/tutorials/double_mn_ha_solution/v4/`
- 企业管理：`/help/tutorials/co_module_tutorial/v4/`
- QoS 使用：`/help/tutorials/qos_tutorial/v4/`
- 调度策略：`/help/tutorials/vm_scheduling_policy/v4/`
- 弹性伸缩：`/help/tutorials/auto_scaling_tutorial/v4/`
- vCenter 管理：`/help/tutorials/vcenter_guide/v4/`
- V2V 迁移服务：`/help/tutorials/v2v_migration_tutorial/v4/`
- 混合云：`/help/tutorials/hybrid_cloud_tutorial/v4/`
- 灾备服务：`/help/tutorials/dr_module_tutorial/v4/`
- 裸金属管理：`/help/tutorials/baremetal_deploy_tutorial/v4/`
- 弹性裸金属：`/help/tutorials/elastic_baremetal_deploy_tutorial/v4/`
- GPU 透传：`/help/tutorials/vgpu_passthrough_tutorial/v4/`
- vGPU 虚拟化：`/help/tutorials/gpu_passthrough_tutorial/v4/`
- 资源编排：`/help/tutorials/cloud_formation_tutorial/v4/`

**FAQ**：
- 常见问题：`/help/FAQ/v4/`

**版本信息**：
- 版本特性：`/help/release_notes/v4/`

### ZSphere

- 产品手册：`/help/zstack_zsphere/product_manuals/`
- 开发手册：`/help/zstack_zsphere/dev_manual/`
- 实践教程：`/help/zstack_zsphere/tutorials/`
- 用户手册：`/help/zstack_zsphere/user_guide/`
- 用户手册 v5.0.0：`/help/zstack_zsphere/user_guide/v5.0.0/`
- 安装手册 v5.0.0：`/help/zstack_zsphere/installation/v5.0.0/`
- 白皮书：`/help/zstack_zsphere/white_paper/`

### ZStack CMP（多云管理）

- 产品手册：`/help/zstack_cmp/product_manuals/`
- 用户指南：`/help/zstack_cmp/user_guide/`

### ZStack Cube 旗舰版（超融合）

- 产品手册：`/help/zstack_cube/product_manuals/`
- 实践教程：`/help/zstack_cube/tutorials/`

### ZStack Cube 虚拟化版 / HCI

- 产品手册：`/help/zstack_cube_hci/product_manuals/`
- 实践教程：`/help/zstack_cube_hci/tutorials/`

### ZStack Cube 双引擎版

- 产品手册：`/help/zstack_cube_dual_engine/product_manuals/`
- 产品手册（备用路径）：`/help/ZStack_Cube_Dual-Engine/product_manuals/`
- 实践教程：`/help/ZStack_Cube_Dual-Engine/tutorials/`

### ZStack Edge

- 产品手册：`/help/zstack_edge/product_manuals/`
- 实践教程：`/help/zstack_edge/tutorials/`
- 用户手册：`/help/zstack_edge/user_guide/`

### ZStack Zaku

- 产品手册：`/help/zstack_zaku/product_manuals/`

### PDF / 文档包

- HTML 文档包列表接口：`/account/api/get-html-help-recommend-books`
- 当前推荐版本：ZStack Cloud 5.5.16 文档包（59 PDF，301.3M）、ZStack Cloud 4.8.10 文档包（58 PDF，212.7M）
- PDF 单文档访问：`/pdf/?id=<docId>&hash=<hash>`

## 正文页 URL 模式

当需要深入到具体章节时，正文页遵循以下模式：

```
/help/**/<n>.html
/help/**/<n>.<m>.html
/help/**/<n>.<m>.<k>.html
/help/**/v4/<n>[.<m>].html
/help/**/v5/<n>[.<m>].html
/help/**/v5.0.0/<n>[.<m>].html
```

例如：`/help/product_manuals/user_guide/v5/3.html`、`/help/tutorials/quick_install_guide/v5/2.html`

## 索引优先级

| 优先级 | 范围 | 说明 |
|--------|------|------|
| P0 | `/help/product_manuals/**/v5/**`、`/help/dev_manual/**/v5/**`、`/help/tutorials/**/v5/**`、`/help/FAQ/**/v5/**` | ZStack Cloud V5 核心文档 |
| P1 | `/help/zstack_zsphere/**`、`/help/zstack_cube/**`、`/help/zstack_cube_hci/**`、`/help/zstack_cube_dual_engine/**`、`/help/zstack_cmp/**`、`/help/zstack_zaku/**`、`/help/zstack_edge/**` | 子产品文档 |
| P2 | `/help/**/v4/**`、`/help/history/` | V4 文档和历史 |
| P3 | `/pdf/?id=*&hash=*` | PDF 文档包 |

## 使用方法

1. 分析过程中遇到产品机制/配置/操作类问题时，先按 [查证路由规则](evidence-routing.md) 删除客户 UUID、IP、账号、项目名、主机名等标识，再根据静态关键词匹配上表中的文档 URL
2. 根据客户版本选择 V4 或 V5（路径中的 `v4` 或 `v5`）；涉及操作、兼容或限制且版本未知时先询问版本，仅做概览时才可并列版本或暂看最新文档，并明确不能据此下客户版本结论
3. **检索层级策略**（由精到粗，优先走精确路径）：
   - **第一优先**：查 API / SDK 相关问题时，先查"开发指南章节索引"表，找到具体章节页 URL（如 VM API → `4.1.html`），直接抓取该章节页
   - **第二优先**：查操作/配置/机制类问题时，查"实践教程"或"手册类"的具体教程 URL，直接抓取
   - **兜底**：上述都没有匹配时，才抓取手册索引页，再根据页面内链接跳转到子页面（最多 2-3 次）
4. 使用 WebFetch 工具抓取 `https://www.zstack.io{路径}` 获取页面内容
5. 将抓取到的文档内容作为"手册参考"证据，记录到分析报告的"手册参考"部分
6. 来源类型标注为“官网文档”，证据成熟度按实际断言与交叉验证程度独立评定；证据边界写“官方文档参考，非当前客户环境证据”

**WebFetch 局限性说明**：
- WebFetch 只能逐页抓取，无法一次性获取整本手册。因此章节级映射表是关键——有映射就能直达具体页面，没有映射就只能从索引页开始摸索
- 如果章节映射表中某个章节返回 404 或内容不对，标注 `文档获取失败` 并跳过，不阻塞分析
- 开发手册的章节结构可能随版本更新变化，映射表需要定期维护

## 注意事项

- WebFetch 抓取为实时操作，页面内容可能更新
- V4 部分页面可能从 HTTPS 301 跳转到 HTTP，WebFetch 会自动跟随跳转，属正常现象
- 如果页面返回 403/404，尝试去掉版本号后缀或换用上级目录
- 优先抓取与事件最相关的 1-2 个页面，不要全量抓取
- V4 和 V5 文档结构相同但内容可能有差异，分析中应注明所引用的文档版本
- 子产品（ZSphere/Cube/CMP/Zaku/Edge）文档不按 v4/v5 区分，按自身版本号组织
