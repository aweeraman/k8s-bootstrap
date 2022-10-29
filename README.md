# Bootstrapping Kubernetes on Debian

## Setup the master node

Setup a master node by installing Debian stable with a minimal
configuration, either on bare metal or on a hypervisor.


## Set the hostname of the node

```
# hostnamectl set-hostname k8s-master
```

## Update the /etc/hosts entry for the master node

```
192.168.1.x k8s-master
```
## Disable swap on each node

```
sudo swapoff -a
```

Remove entries in /etc/fstab for any swap volumes.

## Install git and clone this repo

```
# apt update
# apt install git
# git clone https://github.com/aweeraman/k8s-bootstrap.git
```

## Load required kernel modules

```
cd k8s-bootstrap
./1-load-kernel-modules.sh
```

## Set required kernel settings

```
./2-set-kernel-settings.sh
```

## Install and configure containerd

```
./3-install-configure-containerd.sh
```

## Install Kubelet, Kubectl and Kubeadm from the Kubernetes Apt Repo

```
./4-install-kube-tools.sh
```

## Setup the worker nodes

At this point, if you've been using a virtualization technology,
you can take a snapshot of the master node and clone it twice to
create the new worker nodes with the same base configuration.

After clone, start them up and set their hostnames and /etc/hosts
entries to communicate with each of the nodes:

```
192.168.1.x k8s-master
192.168.1.x k8s-node1
192.168.1.x k8s-node2
```

## Initialize the master node with kubeadm

Initialize the master node by passing the hostname of the master
node to the script below. In the example, the hostname of the master
is "k8s-master":

```
5-initialize-master-node.sh
```

This sets up the master node and prints the instructions to connect
and join worker nodes to the cluster.

To start using your cluster, you need to run the following as a regular user:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Alternatively, if you are the root user, you can run:

```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

To see the cluster-info, nodes and pods running:

```
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

## Join the worker nodes to the cluster

The previous command displays the join instructions which needs to be
run on all the worker nodes to join them to cluster. Copy and paste them
onto the two worker nodes connect them to the cluster.

After joining the nodes, you should see the following:

```
$ kubectl get nodes
NAME         STATUS     ROLES           AGE   VERSION
k8s-master   NotReady   control-plane   10m   v1.25.3
k8s-node1    NotReady   <none>          54s   v1.25.3
k8s-node2    NotReady   <none>          2s    v1.25.3
```

The nodes are still in NotReady status until the Pod Network Addons
are installed.

To retrieve this join command later:

```
# kubeadm token create --print-join-command
```

To join a new control plane node, create a new certificate on the master
node:

```
# kubeadm init phase upload-certs --upload-certs
```

Retrieve the join command as shown earlier and append "--control-plane
--certificate-key KEY-FROM-PREVIOUS-STEP"

## Install the Calico Pod Networking Addon

Run the following on the master node:

```
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
```

You should see the following state in a short while:

```
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-59697b644f-7fsln   1/1     Running   0          97s
kube-system   calico-node-6ptsh                          1/1     Running   0          97s
kube-system   calico-node-7x5j8                          1/1     Running   0          97s
kube-system   calico-node-qlnf6                          1/1     Running   0          97s
kube-system   coredns-565d847f94-79jlw                   1/1     Running   0          25m
kube-system   coredns-565d847f94-fqwn4                   1/1     Running   0          25m
kube-system   etcd-k8s-master                            1/1     Running   0          25m
kube-system   kube-apiserver-k8s-master                  1/1     Running   0          25m
kube-system   kube-controller-manager-k8s-master         1/1     Running   0          25m
kube-system   kube-proxy-4n9b7                           1/1     Running   0          14m
kube-system   kube-proxy-k4rzv                           1/1     Running   0          25m
kube-system   kube-proxy-lz2dd                           1/1     Running   0          15m
kube-system   kube-scheduler-k8s-master                  1/1     Running   0          25m
```

The nodes will now show as Ready:

```
~/ninsei/k8s/k8s-bootstrap [main] $ kubectl get nodes
NAME         STATUS   ROLES           AGE   VERSION
k8s-master   Ready    control-plane   26m   v1.25.3
k8s-node1    Ready    <none>          16m   v1.25.3
k8s-node2    Ready    <none>          15m   v1.25.3
```

## Open up network ports with ufw

When using ufw, the following ports will need to be opened up on the
master node:

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

## Reference

[How to Install Kubernetes Cluster on Debian 11 with Kubeadm](https://www.linuxtechi.com/install-kubernetes-cluster-on-debian/) by Pradeep Kumar
