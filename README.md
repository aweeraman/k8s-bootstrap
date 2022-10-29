# Bootstrapping Kubernetes on Debian

## Setup the nodes

Setup three Debian stable (Bullseye, at the time of writing) nodes.

## Set the hostnames on each node

```
# hostnamectl set-hostname k8s-master
# hostnamectl set-hostname k8s-node1
# hostnamectl set-hostname k8s-node2
```

## Update the /etc/hosts entries on each node

```
192.168.1.x k8s-master
192.168.1.x k8s-node1
192.168.1.x k8s-node2
```
## Disable swap on each node

```
sudo swapoff -a
```

Remove entries in /etc/fstab for any swap volumes.

## Open up network ports

This step may not be needed initially.

On existing systems, if ufw is enabled and running, the
following ports will need to be opened up on the master node:

```
# ufw allow 6443/tcp
# ufw allow 2379/tcp
# ufw allow 2380/tcp
# ufw allow 10250/tcp
# ufw allow 10251/tcp
# ufw allow 10252/tcp
# ufw allow 10255/tcp
# ufw reload
```

The following ports will need to be opened on the worker nodes:

```
# ufw allow 10250/tcp
# ufw allow 30000:32767/tcp
# ufw reload
```

## Install git and clone this repo

```
# apt update
# apt install git
# git clone https://github.com/aweeraman/k8s-bootstrap.git
```

## Load required kernel modules

```
cd k8s-bootstrap
./load-kernel-modules.sh
```
