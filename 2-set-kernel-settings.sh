#!/bin/sh

echo "Tuning required sysctl controls..."
tee /etc/sysctl.d/99-k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net/bridge/bridge-nf-call-arptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
