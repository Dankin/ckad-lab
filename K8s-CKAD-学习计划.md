# K8s 学习 + CKAD 备考计划（7 周，考试 12-19 13:00）

- 周期：2026-11-02（周一）至 2026-12-18（周五）
- 考试：**2026-12-19（周六）13:00 Asia/Shanghai**，CKAD-CN，简体中文，120 分钟，在线监考，确认号码 .132360202（11-01 已预约）
- 投入：每周 10~12 小时（工作日每天 1 小时 + 周末 4~6 小时）
- 起点：会用 Docker，会 `kubectl apply/get/edit/exec`，概念有印象但不牢
- 方法：每个任务都要产出能提交到 Git 的东西，按“验收标准”自查，过了才打勾

## 考期检查点

考期已经约好，下面两个检查点用来决定要不要改期：

| 时间 | 检查什么 | 怎么做 |
|---|---|---|
| **12-05（周六），W5 周测后** | 周测 ≥ 6/8，且 12-19 下午没有冲突 | 达标就保持不变；明显不达标就改期 1~2 周，后续计划顺延 |
| 12-13（周日），killer.sh 第 1 次复盘后 | 复盘后所有题能独立做对 | 保持不变；临时有事就改期 |

改期截止时间以考试门户说明为准，记在 `setup/exam-info.md`。

## 考试基本信息

- 形式：线上监考，约 2 小时，15~20 道实操题，66 分及格，含一次免费重考
- 考试中可查阅 kubernetes.io/docs（以及 Helm 文档），所以要练的是“会查 + 手快”，不是背 YAML
- 国际版考试券附带 2 次 killer.sh 模拟考（每次激活后 36 小时有效），安排在 12-12 和 12-16；CKAD-CN 是否同样附带见 W1-7
- 考纲权重：
  | 领域 | 权重 | 对应周 |
  |---|---|---|
  | Application Design and Build | 20% | 第 2 周 |
  | Application Deployment | 20% | 第 3 周 |
  | Application Observability and Maintenance | 15% | 第 4 周 |
  | Application Environment, Configuration and Security | 25% | 第 5 周 |
  | Services and Networking | 20% | 第 6 周 |
- 官网：https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/

## 总交付物：一个 Git 仓库 `ckad-lab`

```
ckad-lab/
├── README.md              # 进度表（就是本文末尾的打勾表）
├── setup/                 # 集群搭建脚本、kubectl 配置、考试信息
├── w1-basics/ … w6-network/   # 每周的 YAML + notes.md
├── drills/                # 计时练习题、周测成绩、killer.sh 记录
├── cheatsheet.md          # 自己整理的速查表（逐周追加）
└── mistakes.md            # 错题本：题目 / 错因 / 正确做法 / 文档链接
```

每周固定动作：
1. 周日做一次 **周测**：从本周内容里挑 5 道题，限时 30 分钟，成绩写进 `drills/scores.md`
2. 错的题全部写进 `mistakes.md`
3. 本周新学的命令补进 `cheatsheet.md`

---

## 第 1 周（11-02 ~ 11-08）：环境 + 重建基础

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W1-1 | 登录考试门户，读考前须知，确认改期规则并预约考试（11-01 已完成：12-19 13:00） | `setup/exam-info.md`：考试时间、确认号码、改期截止时间 | 知道最晚什么时候能改期 | 0.5h |
| W1-2 | 用 kind 或 minikube 搭一个 1 控制面 + 2 工作节点的集群，装 metrics-server 和 ingress-nginx | `setup/cluster.sh`、`setup/kind-config.yaml` | 在一台新环境执行脚本能一键重建；`kubectl get nodes` 3 个 Ready | 2h |
| W1-3 | 配置考场同款提速：`alias k=kubectl`、补全、`export do="--dry-run=client -o yaml"`、vim 缩进设置 | `setup/bashrc-ckad`、`setup/vimrc` | 能用 `k run nginx --image=nginx $do > pod.yaml` 一行生成模板 | 1h |
| W1-4 | 重读架构：apiserver / etcd / scheduler / controller-manager / kubelet 各干什么，一个 `kubectl apply` 发生了什么 | `w1-basics/notes.md`（含一张自己画的请求流程图） | 不看资料能口述 Pod 从提交到 Running 的全过程 | 2h |
| W1-5 | Pod、Namespace、Label/Selector、Annotation 练习；学会 `k explain pod.spec --recursive` | `w1-basics/*.yaml`（至少 5 个） | 不复制粘贴，3 分钟内写出带 label、env、command、资源限制的 Pod | 3h |
| W1-6 | 周测 | `drills/scores.md` 第一条记录 | 5 题 30 分钟内完成 ≥ 4 题 | 1h |
| W1-7 | 用预约页的“系统兼容性”链接做一次检测；确认 CKAD-CN 是否附带 killer.sh 模拟考、从哪里激活 | `setup/exam-info.md` 补充检测结果和 killer.sh 情况 | 检测通过；知道模拟考入口（没有的话第 6、7 周改用其他模拟题） | 0.5h |

## 第 2 周（11-09 ~ 11-15）：Application Design and Build（20%）

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W2-1 | 写 Dockerfile 构建镜像，打 tag，`docker save` 导出为 tar；推到 kind 集群里运行 | `w2-build/app/Dockerfile`、`build.sh` | 集群里的 Pod 跑的是自己构建的镜像 | 2h |
| W2-2 | 多容器 Pod：init container、sidecar（日志收集）、共享 emptyDir | `w2-build/multi-container.yaml` | sidecar 能读到主容器写的日志文件 | 2h |
| W2-3 | Job / CronJob：completions、parallelism、backoffLimit、activeDeadlineSeconds | `w2-build/job.yaml`、`cronjob.yaml` | 能解释每个字段，并手动从 CronJob 触发一次 Job（`k create job --from=cronjob/...`） | 2h |
| W2-4 | 存储：emptyDir、hostPath、PV/PVC/StorageClass，Pod 挂载 PVC | `w2-build/storage/*.yaml` + notes | Pod 删除重建后 PVC 中的数据还在 | 2.5h |
| W2-5 | 周测 + 错题整理 | `scores.md`、`mistakes.md` | ≥ 4/5 | 1.5h |

## 第 3 周（11-16 ~ 11-22）：Application Deployment（20%）

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W3-1 | Deployment 滚动更新：maxSurge/maxUnavailable、`rollout status/history/undo`，用 annotation `kubernetes.io/change-cause` 记录变更原因 | `w3-deploy/deploy.yaml` + 操作记录 | 能回滚到指定 revision | 2h |
| W3-2 | 蓝绿发布：两个 Deployment + 改 Service selector 切流量 | `w3-deploy/blue-green/` | curl 能看到流量从 v1 切到 v2 | 1.5h |
| W3-3 | 金丝雀发布：靠副本数比例做 20% 流量 | `w3-deploy/canary/` | 连续请求 50 次，v2 占比约 20% | 1.5h |
| W3-4 | Helm：repo add / search / install / upgrade / rollback / uninstall，`--set` 和 values 文件 | `w3-deploy/helm/notes.md` | 安装一个 chart，改一个 value 升级，再回滚 | 2h |
| W3-5 | Kustomize：base + overlays（dev/prod），`k apply -k` | `w3-deploy/kustomize/` | dev 和 prod 的副本数、镜像 tag 不同 | 1.5h |
| W3-6 | 周测 | 同上 | ≥ 4/5 | 1.5h |

## 第 4 周（11-23 ~ 11-29）：Observability and Maintenance（15%）

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W4-1 | 探针：liveness / readiness / startup，http / tcp / exec 三种 | `w4-observe/probes.yaml` | 故意让 readiness 失败，能说明 Pod 为什么不在 Endpoints 里 | 2h |
| W4-2 | 排障套路：`describe`、`get events --sort-by`、`logs -p`、`logs -c`、`k debug`、`k top` | `w4-observe/debug-runbook.md` | 一页排障流程：Pending / CrashLoopBackOff / ImagePullBackOff / 服务不通，各自查什么 | 2h |
| W4-3 | 故障练习：自己造 6 个坏掉的 YAML（错镜像、错端口、错 selector、资源不足、探针错、命令错），隔一天再修 | `w4-observe/broken/` + `fixed/` | 6 个都能在 5 分钟内定位并修好 | 3h |
| W4-4 | API 废弃与版本：`k api-resources`、`k api-versions`，旧 apiVersion 的迁移；CRD 的发现和使用 | notes | 能把一个废弃版本的 YAML 改成当前可用版本 | 1.5h |
| W4-5 | 周测 | 同上 | ≥ 4/5 | 1.5h |

## 第 5 周（11-30 ~ 12-06）：Environment, Configuration and Security（25%，最重）

这一周内容最多，建议投入 12 小时以上。周测提前到 **12-05（周六）**，做完就是考期检查点。

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W5-1 | ConfigMap / Secret：from-literal、from-file、env、envFrom、volume 挂载 | `w5-config/cm-secret/` | 四种注入方式各写一个，能说明 volume 挂载会热更新、env 不会 | 2.5h |
| W5-2 | 资源管理：requests/limits、LimitRange、ResourceQuota | `w5-config/resources/` | 在有 Quota 的命名空间里创建超额 Pod，能看懂报错并修正 | 2h |
| W5-3 | SecurityContext：runAsUser、runAsNonRoot、fsGroup、readOnlyRootFilesystem、capabilities | `w5-config/security-context.yaml` | `k exec` 进去用 `id`、写文件验证每个设置生效 | 2h |
| W5-4 | ServiceAccount + RBAC：Role / RoleBinding / ClusterRole，`k auth can-i --as` | `w5-config/rbac/` | 给一个 SA 只读 Pod 权限，用 `can-i` 证明能 list 不能 delete | 2.5h |
| W5-5 | CRD 与 Operator 概念、Admission Controller 概念（了解级） | notes | 能说清楚两者在请求链路中的位置 | 1h |
| W5-6 | 周测（8 题 45 分钟，覆盖第 1~5 周） | 同上 | ≥ 6/8 | 2h |
| **W5-7** | **考期检查点**：按“考期检查点”的规则决定是否改期 | `setup/exam-info.md` 记下结论 | 确认保持 12-19；或已改期并写明新日期 | 0.5h |

## 第 6 周（12-07 ~ 12-13）：Services and Networking（20%）+ 模拟考 1

工作日学网络，周末做第 1 次 killer.sh。

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W6-1 | Service：ClusterIP / NodePort / Headless，`k expose`，DNS 名称格式 | `w6-network/svc/` | 在另一个命名空间用 `svc.ns.svc.cluster.local` 访问成功 | 2h |
| W6-2 | Ingress：按 host 和 path 路由到两个 Service，pathType 区别 | `w6-network/ingress.yaml` | curl 不同 path 返回不同应用 | 2h |
| W6-3 | NetworkPolicy：默认拒绝、按 podSelector / namespaceSelector 放行、egress 放行 DNS | `w6-network/netpol/` | kind 默认 CNI 不支持 NetworkPolicy，需先换 Calico；用 curl 证明策略生效 | 3h |
| W6-4 | killer.sh 模拟考第 1 次（12-12 周六），严格计时 2 小时 | `drills/killer-1.md`：分数、每题耗时、错题 | 记录完整；killer.sh 比真题难，低于 60% 不用慌 | 2h |
| W6-5 | 复盘 killer.sh 第 1 次（12-13 周日，36 小时窗口内），所有题重做到全对 | `mistakes.md` 追加 | 所有题重做通过 | 3h |

## 第 7 周（12-14 ~ 12-18）：冲刺，周末考试

| ID | 任务 | 交付物 | 验收标准 | 预计 |
|---|---|---|---|---|
| W7-1 | 错题二刷（12-14、12-15）：`mistakes.md` 里的题全部重做，薄弱领域加做限时题 | `mistakes.md` 标注二刷结果、`drills/scores.md` | 二刷全对，平均每题 ≤ 6 分钟 | 2h |
| W7-2 | killer.sh 模拟考第 2 次（12-16 周三晚） | `drills/killer-2.md` | 得分比第 1 次高，且 ≥ 70% | 2h |
| W7-3 | 复盘 killer.sh 第 2 次（12-17 周四，36 小时窗口内） | `mistakes.md` 追加 | 错题全部重做通过 | 1.5h |
| W7-4 | 考场演练：只用 kubernetes.io 文档完成 5 道题，练熟 `k config use-context`（每道题都要先切 context） | `cheatsheet.md` 最终版 + 常用文档页书签列表 | 知道每类资源的示例 YAML 在文档哪一页 | 1h |
| W7-5 | 考前检查（12-18 周五）：PSI 系统检测、证件、摄像头、网络、桌面清空 | 检查清单打勾 | 考前一天完成 | 0.5h |

## 考试（12-19 周六 13:00）

- 上午不再刷题，只看 `cheatsheet.md`；按考试邮件要求的时间提前签到，留出验证身份和检查房间的时间
- 题目是中文，但命令、YAML 字段和官方文档都是英文，平时继续用英文文档练习

- 先扫一遍所有题，先做分值高且熟悉的，卡住超过 8 分钟就标记跳过
- 每道题开头先复制执行题目给的 `kubectl config use-context` 命令
- 没过不用急：用免费重考，按成绩报告里的弱项再练 1~2 周

## 考后可选：综合项目

原来第 7 周的综合项目因时间压缩挪到考后，用来巩固，也可以当作品：

| ID | 任务 | 交付物 | 验收标准 |
|---|---|---|---|
| P-1 | 前端 + 后端 API + Redis 三层应用，用到 Deployment、Service、Ingress、ConfigMap、Secret、PVC、探针、资源限制、SecurityContext、NetworkPolicy（只允许前端→后端→Redis）、Kustomize 两套环境 | `capstone/` + `capstone/README.md`（架构图 + 部署步骤） | 新集群上按 README 一次部署成功；删一个 Pod 能自愈；跨层访问被 NetworkPolicy 拦住 |

---

## 学习资料

| 用途 | 资料 |
|---|---|
| 主文档（考试可查） | https://kubernetes.io/docs/ ，重点看 Tasks 和 Concepts |
| 练习题 | https://github.com/dgkanatsios/CKAD-exercises |
| 模拟考 | killer.sh（考试券附带 2 次） |
| 回顾原理 | 《深入剖析 Kubernetes》对应章节，只在当周遇到不懂的再翻，不要从头读 |

## 进度表（复制到 `ckad-lab/README.md`）

- [x] W1-1 确认考试券有效期和改期规则
- [ ] W1-2 集群一键搭建脚本
- [ ] W1-3 kubectl / vim 提速配置
- [ ] W1-4 架构笔记 + 流程图
- [ ] W1-5 Pod / Label 练习
- [ ] W1-6 周测
- [ ] W1-7 系统检测 + 确认 killer.sh 入口
- [ ] W2-1 构建并导出镜像
- [ ] W2-2 多容器 Pod
- [ ] W2-3 Job / CronJob
- [ ] W2-4 存储
- [ ] W2-5 周测
- [ ] W3-1 滚动更新与回滚
- [ ] W3-2 蓝绿发布
- [ ] W3-3 金丝雀发布
- [ ] W3-4 Helm
- [ ] W3-5 Kustomize
- [ ] W3-6 周测
- [ ] W4-1 探针
- [ ] W4-2 排障手册
- [ ] W4-3 6 个故障练习
- [ ] W4-4 API 版本与 CRD
- [ ] W4-5 周测
- [ ] W5-1 ConfigMap / Secret
- [ ] W5-2 资源配额
- [ ] W5-3 SecurityContext
- [ ] W5-4 ServiceAccount + RBAC
- [ ] W5-5 CRD / Admission 概念
- [ ] W5-6 周测（12-05）
- [ ] W5-7 考期检查点（12-05）
- [ ] W6-1 Service + DNS
- [ ] W6-2 Ingress
- [ ] W6-3 NetworkPolicy
- [ ] W6-4 killer.sh 第 1 次（12-12）
- [ ] W6-5 killer.sh 第 1 次复盘（12-13）
- [ ] W7-1 错题二刷
- [ ] W7-2 killer.sh 第 2 次（12-16）
- [ ] W7-3 killer.sh 第 2 次复盘（12-17）
- [ ] W7-4 考场演练
- [ ] W7-5 考前检查（12-18）
- [ ] 12-19 13:00 考试 · 通过 CKAD 🎉
- [ ] P-1 综合项目（考后可选）
