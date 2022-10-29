#!/bin/sh

echo "Installing containerd..."
apt update
apt install -y containerd

echo "Configuring containerd and setting the cgroup driver to systemd..."
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
