#!/bin/sh

MASTER_NODE=$1

if [ "$MASTER_NODE" = "" ]; then
	echo "Please specify the node hostname"
	exit 1
fi

kubeadm init --control-plane-endpoint=$MASTER_NODE
