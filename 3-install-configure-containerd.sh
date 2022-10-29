#!/bin/sh

echo "Installing containerd..."
apt update
apt install -y containerd

echo "Configuring containerd and setting the cgroup driver to systemd..."
containerd config default | tee /etc/containerd/config.toml

patch /etc/containerd/config.toml --ignore-whitespace <<EOF
--- /tmp/config.toml.default    2022-10-29 23:05:14.903922789 +0530
+++ /tmp/config.toml.updated    2022-10-29 23:06:02.419736222 +0530
@@ -94,6 +94,7 @@
           privileged_without_host_devices = false
           base_runtime_spec = ""
           [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
+            SystemdCgroup = true
     [plugins."io.containerd.grpc.v1.cri".cni]
       bin_dir = "/opt/cni/bin"
       conf_dir = "/etc/cni/net.d"
EOF

echo "Restarting and enabling containerd..."
systemctl restart containerd
systemctl enable containerd
