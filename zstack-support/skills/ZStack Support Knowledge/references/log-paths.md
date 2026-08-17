# ZStack 日志路径基准

本文件用于约束事件分析中的日志路径建议。不得凭通用 Linux 习惯编造路径；只有本文件列出的确定路径可以直接给出。未列出的组件必须先用只读命令定位。

## 已确认常用路径

| 对象 | 日志 | 路径 | 说明 |
|------|------|------|------|
| 管理节点 | 管理服务主日志 | `/usr/local/zstack/apache-tomcat/logs/management-server.log` | Java 管理服务日志。分析 API、FlowChain、CloudBus、RESTFacadeImpl、KVMHost 等管理面调用时优先查看 |
| 管理节点 | 管理服务滚动日志 | `/usr/local/zstack/apache-tomcat/logs/management-server.log*` | 包含滚动归档；按时间窗口筛选 |
| 计算节点 | KVM agent 主日志 | `/var/log/zstack/zstack-kvmagent.log` | Python kvmagent 日志。分析 `http://<host-ip>:7070/...`、VM start、libvirt、qemu-img、ha_plugin 等主机侧执行失败时优先查看 |
| 计算节点 | KVM agent 滚动日志 | `/var/log/zstack/zstack-kvmagent.log*` | 包含滚动归档；按 taskUuid、apiUuid、VM uuid、host uuid、时间窗口筛选 |

## 禁止直接使用的幻觉路径

以下路径不要在建议中直接写成事实路径：

```text
/var/log/zstack/management-server.log
/var/log/zstack/kvmagent.log
/var/log/zstack/management-server.log*
/var/log/zstack/kvmagent.log*
```

如果用户现场确实出现了这些路径，只能表述为“用户现场提供的路径”，不能作为插件默认路径。

## 找不到日志时的只读定位命令

当版本、部署方式或组件不确定时，先让用户执行只读定位，不要猜路径：

```bash
find /usr/local/zstack /var/log/zstack -maxdepth 6 -type f \
  \( -name '*management-server*.log*' -o -name '*kvmagent*.log*' -o -name '*zstack*.log*' \) \
  2>/dev/null | sort
```

按服务定位：

```bash
systemctl status zstack-server --no-pager
systemctl status zstack-kvmagent --no-pager
```

如果服务名因版本不同不存在，不要据此判断组件不存在；改用 `systemctl list-units '*zstack*' --no-pager` 做只读枚举。

## 日志收集建议模板

管理节点：

```bash
grep -n "<apiUuid-or-taskUuid-or-error-keyword>" /usr/local/zstack/apache-tomcat/logs/management-server.log*
```

计算节点：

```bash
grep -n "<taskUuid-or-vmUuid-or-error-keyword>" /var/log/zstack/zstack-kvmagent.log*
```

如 `grep` 提示二进制匹配或日志含特殊字符，使用：

```bash
grep -a -n "<keyword>" <log-file>
```

## 使用规则

- 事件分析中给日志路径时，先判断对象是管理节点还是计算节点。
- 管理面 API、FlowChain、CloudBus、RESTFacadeImpl、KVMHost 警告：优先管理节点 `management-server.log*`。
- 主机侧 Python 异常、libvirt/qemu 命令、`/vm/start`、`/vm/vmsync`、`ha_plugin`：优先计算节点 `zstack-kvmagent.log*`。
- 未确认组件路径时，只给定位命令，不给硬编码路径。
- 所有日志命令默认只读；不得建议删除、截断、移动日志文件，除非用户明确授权维护操作。
