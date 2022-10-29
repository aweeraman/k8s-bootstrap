#!/bin/sh

echo "Installing dependent utilities..."
apt-get install -y curl gnupg2

echo "Setting up Kubernetes Apt repository..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Installing Kube tools..."
apt update
apt install -y kubelet kubeadm kubectl
