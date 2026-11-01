# CKAD 备考计划

## 目标

- 2026-12-19（周六）13:00 考 CKAD-CN，一次通过（66 分及格）
- 每个任务都在本仓库留下交付物，达到验收标准才算完成

## DDL

| 日期 | 节点 |
|---|---|
| 11-08 | 第 1 周：环境 + 基础 |
| 11-15 | 第 2 周：Design and Build |
| 11-22 | 第 3 周：Deployment |
| 11-29 | 第 4 周：Observability and Maintenance |
| **12-05** | 第 5 周：Configuration and Security；**考期检查点**：周测 < 6/8 就改期 1~2 周 |
| 12-12 | 第 1 次模拟考 |
| 12-13 | 第 6 周：Services and Networking；模拟考复盘 |
| 12-16 | 第 2 次模拟考 |
| 12-18 | 考前检查 |
| **12-19 13:00** | **考试** |

每周日：做 5 道限时 30 分钟的周测，成绩记入 `drills/scores.md`；错题记入 `mistakes.md`；新命令补进 `cheatsheet.md`。

## 计划

### 第 1 周（11-02 ~ 11-08）：环境 + 基础

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W1-1 | 预约考试，确认改期规则 | `setup/exam-info.md` | 已约考，知道改期截止时间 |
| W1-2 | sealos 搭 3 master + 3 node 集群，装 metrics-server、ingress-nginx、默认 StorageClass | `setup/install.sh` | 按脚本可重建；6 个节点 Ready；`k top nodes` 有数据 |
| W1-3 | kubectl / vim 提速配置（alias、补全、`$do`） | `setup/bashrc-ckad`、`setup/vimrc` | 一行命令生成 Pod 模板 |
| W1-4 | 重温架构：各组件职责，`kubectl apply` 的完整链路 | `w1-basics/notes.md`（含流程图） | 能口述 Pod 从提交到 Running 的过程 |
| W1-5 | Pod、Namespace、Label/Selector、`k explain` 练习 | `w1-basics/*.yaml`（≥ 5 个） | 3 分钟内手写带 label、env、command、资源限制的 Pod |
| W1-6 | 周测 | `drills/scores.md` | ≥ 4/5 |
| W1-7 | PSI 系统检测；确认 CKAD-CN 是否附带 killer.sh | `setup/exam-info.md` | 检测通过；知道模拟考入口 |

### 第 2 周（11-09 ~ 11-15）：Application Design and Build（20%）

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W2-1 | Dockerfile 构建镜像，导出并导入节点 containerd 运行 | `w2-build/app/` | Pod 跑的是自己构建的镜像 |
| W2-2 | 多容器 Pod：init container、sidecar、共享 emptyDir | `w2-build/multi-container.yaml` | sidecar 能读到主容器的日志 |
| W2-3 | Job / CronJob | `w2-build/job.yaml`、`cronjob.yaml` | 能从 CronJob 手动触发 Job |
| W2-4 | 存储：emptyDir、hostPath、PV/PVC/StorageClass | `w2-build/storage/` | Pod 重建后 PVC 数据还在 |
| W2-5 | 周测 | `drills/scores.md` | ≥ 4/5 |

### 第 3 周（11-16 ~ 11-22）：Application Deployment（20%）

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W3-1 | 滚动更新与回滚 | `w3-deploy/deploy.yaml` | 能回滚到指定 revision |
| W3-2 | 蓝绿发布 | `w3-deploy/blue-green/` | 改 selector 后流量从 v1 切到 v2 |
| W3-3 | 金丝雀发布 | `w3-deploy/canary/` | 50 次请求中 v2 约占 20% |
| W3-4 | Helm：install / upgrade / rollback | `w3-deploy/helm/notes.md` | 完成一次安装、升级、回滚 |
| W3-5 | Kustomize：base + dev/prod overlays | `w3-deploy/kustomize/` | 两套环境副本数、镜像 tag 不同 |
| W3-6 | 周测 | `drills/scores.md` | ≥ 4/5 |

### 第 4 周（11-23 ~ 11-29）：Observability and Maintenance（15%）

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W4-1 | liveness / readiness / startup 探针 | `w4-observe/probes.yaml` | 能解释 readiness 失败时 Pod 为什么不在 Endpoints 里 |
| W4-2 | 排障手册 | `w4-observe/debug-runbook.md` | 覆盖 Pending、CrashLoopBackOff、ImagePullBackOff、服务不通 |
| W4-3 | 6 个故障练习 | `w4-observe/broken/`、`fixed/` | 每个 5 分钟内修好 |
| W4-4 | API 版本迁移、CRD 使用 | `w4-observe/notes.md` | 能把废弃版本的 YAML 改成可用版本 |
| W4-5 | 周测 | `drills/scores.md` | ≥ 4/5 |

### 第 5 周（11-30 ~ 12-06）：Configuration and Security（25%，最重）

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W5-1 | ConfigMap / Secret 的四种注入方式 | `w5-config/cm-secret/` | 能说明 volume 会热更新、env 不会 |
| W5-2 | requests/limits、LimitRange、ResourceQuota | `w5-config/resources/` | 能看懂并修正超额报错 |
| W5-3 | SecurityContext | `w5-config/security-context.yaml` | 进容器验证每项设置生效 |
| W5-4 | ServiceAccount + RBAC | `w5-config/rbac/` | `k auth can-i` 证明能 list、不能 delete |
| W5-5 | CRD、Operator、Admission Controller 概念 | `w5-config/notes.md` | 能说出它们在请求链路中的位置 |
| W5-6 | 周测（**12-05**，8 题 45 分钟） | `drills/scores.md` | ≥ 6/8 |
| W5-7 | 考期检查点（**12-05**） | `setup/exam-info.md` | 确认保持 12-19，或已改期 |

### 第 6 周（12-07 ~ 12-13）：Services and Networking（20%）+ 模拟考 1

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W6-1 | Service 类型与 DNS | `w6-network/svc/` | 跨命名空间用 FQDN 访问成功 |
| W6-2 | Ingress 按 host / path 路由 | `w6-network/ingress.yaml` | 不同 path 返回不同应用 |
| W6-3 | NetworkPolicy（集群用 Cilium，已支持） | `w6-network/netpol/` | curl 证明策略生效 |
| W6-4 | 模拟考 1（**12-12**），计时 2 小时 | `drills/killer-1.md` | 记录分数、耗时、错题 |
| W6-5 | 模拟考 1 复盘（**12-13**） | `mistakes.md` | 所有题重做通过 |

### 第 7 周（12-14 ~ 12-18）：冲刺

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| W7-1 | 错题二刷（12-14 ~ 12-15） | `mistakes.md`、`drills/scores.md` | 全对，平均每题 ≤ 6 分钟 |
| W7-2 | 模拟考 2（**12-16**） | `drills/killer-2.md` | 高于第 1 次，且 ≥ 70% |
| W7-3 | 模拟考 2 复盘（12-17） | `mistakes.md` | 错题重做通过 |
| W7-4 | 只用官方文档做 5 道题 | `cheatsheet.md` 最终版 | 知道常用 YAML 示例在文档哪一页 |
| W7-5 | 考前检查（**12-18**）：系统、证件、摄像头、桌面 | `setup/exam-info.md` | 全部通过 |

### 考后（可选）

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| P-1 | 三层应用综合项目（前端 + API + Redis） | `capstone/` | 按 README 一次部署成功，NetworkPolicy 隔离生效 |
