#!/bin/bash
### create yaml file for etcd pod ###

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo mkdir -p /etc/kubernetes/manifests
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

INTERNAL_IP=$(ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

ETCD_NAME=$(hostname -s)

cat <<EOF | sudo tee /etc/kubernetes/manifests/etcd.yaml
apiVersion: v1
kind: Pod
metadata:
  name: etcd
  namespace: kube-system
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ''
spec:
  hostNetwork: true
  containers:
  - name: etcd
    image: "k8s.gcr.io/etcd-amd64:3.3.10"
    resources:
      requests:
        cpu: "0.1"
    command:
    - "/usr/local/bin/etcd"
    - "--name=${ETCD_NAME}"
    - "--cert-file=/etc/etcd/kubernetes.pem"
    - "--key-file=/etc/etcd/kubernetes-key.pem"
    - "--peer-cert-file=/etc/etcd/kubernetes.pem"
    - "--peer-key-file=/etc/etcd/kubernetes-key.pem"
    - "--trusted-ca-file=/etc/etcd/ca.pem"
    - "--peer-trusted-ca-file=/etc/etcd/ca.pem"
    - "--peer-client-cert-auth"
    - "--client-cert-auth"
    - "--initial-advertise-peer-urls=https://${INTERNAL_IP}:2380"
    - "--listen-peer-urls=https://${INTERNAL_IP}:2380"
    - "--listen-client-urls=https://${INTERNAL_IP}:2379,https://127.0.0.1:2379"
    - "--advertise-client-urls=https://${INTERNAL_IP}:2379"
    - "--initial-cluster-token=etcd-cluster-0"
    - "--initial-cluster=controller-0=https://10.240.0.10:2380,controller-1=https://10.240.0.11:2380,controller-2=https://10.240.0.12:2380"
    - "--initial-cluster-state=new"
    - "--data-dir=/var/lib/etcd"
    ports:
    - name: serverport
      containerPort: 2379
      hostPort: 2379
    - name: clientport
      containerPort: 2380
      hostPort: 2380
    volumeMounts:
    - name: varlibetcd
      mountPath: "/var/lib/etcd"
      readOnly: false
    - name: etcetcd
      mountPath: "/etc/etcd"
      readOnly: false
  volumes:
  - name: varlibetcd
    hostPath:
      path: "/var/lib/etcd"
  - name: etcetcd
    hostPath:
      path: "/etc/etcd"
EOF
