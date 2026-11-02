# 学习日志

我只在“日志”里记录进度和产出物；Kiro 负责检查、更新状态、提出下一步的产出物要求。

## 当前要求（Kiro 维护）

**本周：M1 环境 + 基础，DDL 11-08（周日）**

| 任务 | 要交的产出物 | 状态 |
|---|---|---|
| W1-1 预约考试 | 考试时间 | ✅ 12-19 13:00 |
| W1-2 集群搭建 | `setup/install.sh`；metrics-server、ingress-nginx、默认 StorageClass | ✅ 11-02（K8s v1.28.15，以后有空用 kubeasz 重装） |
| W1-3 提速配置 | `setup/quick_config.sh`；`w1-basics/` 5 个模板；Pod 改写并部署；常用操作练习 | ✅ 11-02 |
| W1-4 架构笔记 | `w1-basics/notes.md`（含流程图） | ⬜ |
| W1-5 Pod 练习 | `w1-basics/` 下至少 5 个 YAML | ✅ 11-02（随 W1-3 一起验收） |
| W1-6 周测 | 我出题，你在日志里写得分和用时 | ⬜ |
| W1-7 系统检测 | 在日志写检测结果，以及 CKAD-CN 有没有 killer.sh | ⬜ |

## 里程碑

| 里程碑 | DDL | 状态 |
|---|---|---|
| M1 环境 + 基础 | 11-08 | 🟡 |
| M2 Design and Build | 11-15 | ⬜ |
| M3 Deployment | 11-22 | ⬜ |
| M4 Observability | 11-29 | ⬜ |
| M5 Config and Security（考期检查点） | 12-05 | ⬜ |
| M6 Networking + 模拟考 1 | 12-13 | ⬜ |
| M7 冲刺 + 考前检查 | 12-18 | ⬜ |
| 考试 | 12-19 13:00 | ⬜ |

## 日志

新的一天加在最上面，格式随意，写清楚做了什么、产出物在哪、卡在哪就行。

### 11-02

- W1-3
  - 别名和补全的配置写进 `setup/quick_config.sh`（bash 和 vim 合在一个文件里）；本机 zsh 也已配好
  - 用 `--dry-run=client -o yaml` 在 `w1-basics/` 下生成 5 个模板：pod、deployment、svc、cm、job
  - 改写 `pod.yaml`（labels、env、resources、command）并部署，Running
  - 按检查意见改了 `cm.yaml`（重新生成，去掉导出时带出的元数据）和 `job.yaml`（补上 `-- echo hello`）
  - 任务 3 已练：vim 粘贴和缩进、`--force --grace-period 0` 立即删除、建 `ckad` namespace 后切换再切回 default
- 心得：YAML 不用硬背，先用命令生成骨架，字段用 `k explain` 查，大段配置从文档复制
- 明天：W1-4 架构笔记

> **Kiro 复查（11-02 21:20）**：W1-3 ✅，W1-5 ✅。
>
> - `cm.yaml` 重新生成后已干净，`job.yaml` 有了 `command: [echo, hello]`，5 个 YAML 都通过了 `--dry-run=server`
> - `ckad` namespace 已建好，当前 context 已切回 `default`；`nginx` Pod 已删除（删除练习）
> - 环境变量的值保留 `env`，不影响验收
> - 还没提交：`setup/1` 在暂存区里，提交前先执行 `git rm --cached setup/1 && rm setup/1`

> **Kiro 检查（11-02 20:50）**：W1-3 🟡。
>
> 已通过：
> - `pod.yaml`：Pod `nginx` 在 it-k8s-test04 上 Running，0 次重启；labels `app=web,tier=frontend` 正确；requests 100m/64Mi、limits 200m/128Mi 正确，QoS 是 Burstable；command 生效，日志第一行是 `start`
> - 5 个 YAML 都通过了 `--dry-run=server`
>
> 要改：
> 1. **`cm.yaml` 里有 `creationTimestamp`、`resourceVersion`、`uid`**，说明它是从集群里已有的对象导出的，不是用 `--dry-run=client` 生成的。带着 `resourceVersion` 去 apply，对象被改过之后会报冲突。用 `k create cm app-config --from-literal=ENV=dev --dry-run=client -o yaml > cm.yaml` 重新生成
> 2. **`job.yaml` 缺了 `command`**：生成命令最后的 `-- echo hello` 没带上。busybox 没有命令会直接退出，Job 也能显示 Complete，但什么都没做
> 3. 环境变量的值写的是 `env`，任务要求是 `dev`（cm 和 pod 两处）
> 4. 考试里镜像直接写 `nginx`、`busybox`，不要带 `docker.m.daocloud.io/` 前缀。只有练习时才需要这个前缀
>
> 还差：任务 3（删除 / 切 namespace / explain / vim）的反馈；本条日志里你自己的进度记录；提交。提交前先 `git rm --cached setup/1 && rm setup/1`。

### 11-01

- W1-1 完成报名，考试时间 12-19 13:00

- W1-2 

  - 使用sealos搭建6节点k8s集群，k8s版本选择1.28.15，选择cilium作为网络插件、安装helm
  - 同时了解到目前生产级可以用kubeasz来进行部署，kubeadm主要考虑到设计外网镜像站访问，部署会比较麻烦先不折腾
  - 已配置本地kubeconfig，可以直接本地kubectl复核结果

  | IP            | 类型   |
  | ------------- | ------ |
  | 172.31.52.240 | master |
  | 172.31.52.241 | master |
  | 172.31.52.242 | master |
  | 172.31.52.243 | node   |
  | 172.31.52.244 | node   |
  | 172.31.52.245 | node   |

  ```shell
  # 部署文档：https://sealos.run/docs/advanced/k8s/getting-started/install-cli
  
  # 获取版本列表，选择最新的非rc版本
  curl --silent "https://api.github.com/repos/labring/sealos/releases" | jq -r '.[].tag_name'
  VERSION=v5.1.1
  
  # 配置github加速
  export PROXY_PREFIX=https://ghfast.top
  
  # 下载二进制文件+自动安装
  curl -sfL ${PROXY_PREFIX}/https://raw.githubusercontent.com/labring/sealos/main/scripts/install.sh | PROXY_PREFIX=${PROXY_PREFIX} sh -s ${VERSION} labring/sealos
  
  # 集群初始化
  sealos run docker.m.daocloud.io/labring/kubernetes:v1.31.11 \
    docker.m.daocloud.io/labring/helm:v3.19.2 \
    docker.m.daocloud.io/labring/cilium:v1.17.1 \
    --masters 172.31.52.240,172.31.52.241,172.31.52.242 \
    --nodes 172.31.52.243,172.31.52.244,172.31.52.245 -p "$SSH_PASSWORD"
  ```

  ![image-20261101222247269](/Users/bilibili/Library/Application Support/typora-user-images/image-20261101222247269.png)

- 明天：W1-3

> **Kiro 检查（11-01 22:30）**：W1-1 ✅；W1-2 🟡，集群本身通过，验收项还差 4 个。
>
> 已核实（本机 kubectl 直连）：6 个节点全部 Ready，v1.28.15，containerd 1.7.27；3 套 etcd / apiserver / controller-manager / scheduler、cilium、coredns、kube-proxy 全部 Running，0 重启。
>
> 待补：
> 1. **metrics-server**：`k top nodes` 报 `Metrics API not available`
> 2. **Ingress Controller**：没有 IngressClass，W6-2 要用
> 3. **默认 StorageClass**：没有，W2-4 的 PVC 会一直 Pending。可装 local-path-provisioner
> 4. **`setup/install.sh`**：部署命令要放进仓库，不只写在日志里
>
> 日志问题：
> - 命令里定义的是 `version=v5.1.1`，用的是 `${VERSION}`，大小写不同，变量为空，实际装的是最新版 sealos。写进 install.sh 时改成同一个名字
> - 截图是本机 Typora 路径，GitHub 上看不到。改成粘贴文本输出，或把图片放进仓库 `assets/`
>
> 版本建议：**1.28 已停止维护，建议趁集群刚建好重装成 1.3x**（先查 sealos 镜像仓库有哪些 kubernetes 版本）。理由：考试环境用的是较新版本（以官网为准）；原生 sidecar（initContainers 里写 `restartPolicy: Always`）在 1.28 默认不可用，W2-2 会用到；本机 kubectl 是 1.36，和 1.28 相差超过支持的 ±1 个小版本。
>
> 计划调整：用 sealos 集群代替 kind。Cilium 支持 NetworkPolicy，W6-3 不用再换 Calico。
>
> 提醒：Log.md、README 改动和 Progress.md 的删除还没提交。

> **Kiro 复查（11-02 00:15）**：W1-2 仍是 🟡，三个组件已通过，还差 2 项。
>
> 已通过：
> - metrics-server v0.7.1：`k top nodes` 6 个节点都有数据
> - ingress-nginx v1.12.1：IngressClass `nginx` 已就绪；Service 是 LoadBalancer，EXTERNAL-IP 为 `<pending>`（没有 LB），练习时用 NodePort 访问：http 31096，https 31259
> - local-path：`local-path (default)`，`WaitForFirstConsumer`
>
> 未通过：
> 1. **集群版本是 v1.28.15，不是日志里写的 v1.31.11**。节点 AGE 约 20 分钟，看起来是 reset 之后又装回了 1.28。日志命令要和实际装的版本一致：要么重装 1.31.11，要么把日志改成 1.28.15，并写明原因（比如 Cilium 1.17 报错）
> 2. **`setup/install.sh` 还没进仓库**，仓库里只有 Log/Plan/README，而且这几个文件都还没提交
>
> kubectl 变慢：已修复。本机 kubeconfig 的 server 是 `apiserver.cluster.local`。macOS 会把 `.local` 域名先交给 mDNS（Bonjour）解析，每次都要等约 5 秒超时，才回落到 /etc/hosts。已把 server 改成 `https://172.31.52.240:6443`，证书 SAN 里有这个 IP。改完后 `kubectl get nodes` 从 5.1 秒降到 0.08 秒。原文件备份在 `~/.kube/config.bak-20261102`。代价是 240 宕机时本机连不上，需要手动换成 241 或 242。
>
> 另外：本机 `/usr/local/bin/kubectl` 是 Docker Desktop 自带的 v1.36.1，PATH 里排在 Homebrew v1.36.4 后面，不影响使用。

> **Kiro 复查（11-02 00:30）**：W1-2 ✅。按你的决定保持 v1.28.15，以 `setup/install.sh` 为准。日志里 W1-2 的命令（v1.31.11）没有实际执行过，以 install.sh 为准。
>
> install.sh 改了 3 处：
> - 前三个镜像地址缺了 `/`（`docker.m.daocloud.iolabring`），已补上
> - 密码不再写在脚本里，改成执行前先 `export SSH_PASSWORD=...`，没设置就直接报错退出
> - 加了 `#!/usr/bin/env bash`
>
> 1.28 的影响：W2-2 的原生 sidecar（initContainers 里写 `restartPolicy: Always`）在 1.28 是 alpha，默认关闭，到时候改用普通的 sidecar 容器写法。
>
> 明天：W1-3 提速配置，交 `setup/bashrc-ckad` 和 `setup/vimrc`。
