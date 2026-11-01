# 学习日志

我只在“日志”里记录进度和产出物；Kiro 负责检查、更新状态、提出下一步的产出物要求。

## 当前要求（Kiro 维护）

**本周：M1 环境 + 基础，DDL 11-08（周日）**

| 任务 | 要交的产出物 | 状态 |
|---|---|---|
| W1-1 预约考试 | 考试时间 | ✅ 12-19 13:00 |
| W1-2 集群搭建 | 重装为 K8s v1.31.11 + Cilium v1.17.1 + Helm v3.19.2（阿里云 labring 镜像）；`setup/install.sh`（sealos 部署命令，密码不入库）；补齐 metrics-server、ingress-nginx、默认 StorageClass；`k top nodes` 有数据 | 🟡 三个组件已通过；版本不一致、install.sh 未提交 |
| W1-3 提速配置 | `setup/bashrc-ckad`、`setup/vimrc` | ⬜ |
| W1-4 架构笔记 | `w1-basics/notes.md`（含流程图） | ⬜ |
| W1-5 Pod 练习 | `w1-basics/` 下至少 5 个 YAML | ⬜ |
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
