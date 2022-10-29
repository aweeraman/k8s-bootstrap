#!/bin/sh

echo "Loading required kernel modules..."
tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
