# ckad-lab

我的 Kubernetes 学习与 CKAD 备考仓库。目标是 2026-12-19 通过 CKAD，每个学习任务都在这里留下可运行的 YAML、脚本或笔记。

- [Plan.md](Plan.md)：目标、DDL、每周任务和验收标准
- [Log.md](Log.md)：每日进度、当前产出物要求、里程碑状态

## 目录

```
setup/        集群搭建脚本、kubectl / vim 配置
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

[sealos](https://sealos.run/) 部署的 6 节点集群（3 master + 3 node，Cilium），部署命令见 `setup/install.sh`。

## 参考

- [Kubernetes 官方文档](https://kubernetes.io/docs/)（考试中可查）
- [CKAD 官网](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)
- [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises)
