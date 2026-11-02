cat >> ~/.bashrc <<EOF
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
export do="--dry-run=client -o yaml"
EOF
source ~/.bashrc

cat >> ~/.vimrc <<EOF
set expandtab tabstop=2 shiftwidth=2
EOF

