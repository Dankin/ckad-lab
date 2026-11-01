# ckad-lab

我的 Kubernetes 学习与 CKAD 备考仓库。目标是 2026-12-19 通过 CKAD，每个学习任务都在这里留下可运行的 YAML、脚本或笔记。

- [Plan.md](Plan.md)：目标、DDL、每周任务和验收标准
- [Progress.md](Progress.md)：任务进度和周测成绩

## 目录

```
setup/        集群搭建脚本、kubectl / vim 配置、考试信息
w1-basics/    第 1 周：基础
w2-build/     第 2 周：Application Design and Build
w3-deploy/    第 3 周：Application Deployment
w4-observe/   第 4 周：Observability and Maintenance
w5-config/    第 5 周：Configuration and Security
w6-network/   第 6 周：Services and Networking
drills/       周测、模拟考记录
cheatsheet.md 速查表
mistakes.md   错题本
```

## 环境

本地 [kind](https://kind.sigs.k8s.io/) 集群（1 控制面 + 2 工作节点），通过 `setup/cluster.sh` 一键创建。

## 参考

- [Kubernetes 官方文档](https://kubernetes.io/docs/)（考试中可查）
- [CKAD 官网](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)
- [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises)
