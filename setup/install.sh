# https://sealos.run/docs/advanced/k8s/getting-started/install-cli

# 获取版本列表，选择最新的非rc版本
curl --silent "https://api.github.com/repos/labring/sealos/releases" | jq -r '.[].tag_name'
VERSION=v5.1.1

# 配置github加速
export PROXY_PREFIX=https://ghfast.top

# 下载二进制文件+自动安装
curl -sfL ${PROXY_PREFIX}/https://raw.githubusercontent.com/labring/sealos/main/scripts/install.sh | PROXY_PREFIX=${PROXY_PREFIX} sh -s ${VERSION} labring/sealos

SSH_PASSWORD="xxx"
# 集群初始化
sealos run docker.m.daocloud.iolabring/kubernetes:v1.28.15 \
  docker.m.daocloud.iolabring/helm:v3.9.4 \
  docker.m.daocloud.iolabring/cilium:v1.13.4 \
  --masters 172.31.52.240,172.31.52.241,172.31.52.242 \
  --nodes 172.31.52.243,172.31.52.244,172.31.52.245 -p "$SSH_PASSWORD"

# 安装metric server，用于监控用量
sealos run docker.m.daocloud.io/labring/metrics-server:v0.7.1

# 验证
kubectl top node

# 安装ingress-nginx
sealos run docker.m.daocloud.io/labring/ingress-nginx:v1.12.1

# 本地磁盘安装pv,目前未挂pvc
sealos run docker.m.daocloud.io/labring/local-path-provisioner:v0.0.28

# 获取kubeconfig
cat /etc/kubernetes/admin.conf
