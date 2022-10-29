#!/bin/sh

kubectl create deployment nginx-app --image=nginx --replicas 2
kubectl expose deployment nginx-app --name=nginx-web-svc --type NodePort --port 80 --target-port 80
kubectl describe svc nginx-web-svc
