#!/bin/bash
### create yaml file for kube-apiserver pod ###

sudo mkdir -p /var/lib/kubernetes/
sudo mkdir -p /etc/kubernetes/config/

sudo cp ca.pem /var/lib/kubernetes/
sudo mv ca-key.pem kubernetes-key.pem kubernetes.pem \
  service-account-key.pem service-account.pem \
  aggregator-key.pem aggregator.pem \
  metrics-server-key.pem metrics-server.pem \
  encryption-config.yaml /var/lib/kubernetes/

INTERNAL_IP=$(ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

cat <<EOF | sudo tee /etc/kubernetes/manifests/kube-apiserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
  labels:
    k8s-app: kube-apiserver
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ''
spec:
  hostNetwork: true
  containers:
  - name: kube-apiserver
    image: k8s.gcr.io/kube-apiserver-amd64:v1.13.2
    command:
      - "/usr/local/bin/kube-apiserver"
      - "--advertise-address=${INTERNAL_IP}"
      - "--allow-privileged=true"
      - "--apiserver-count=3"
      - "--audit-log-maxage=30"
      - "--audit-log-maxbackup=3"
      - "--audit-log-maxsize=100"
      - "--audit-log-path=/var/log/audit.log"
      - "--authorization-mode=Node,RBAC"
      - "--bind-address=0.0.0.0"
      - "--client-ca-file=/var/lib/kubernetes/ca.pem"
      - "--enable-admission-plugins=Initializers,NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota"
      - "--enable-swagger-ui=true"
      - "--etcd-cafile=/var/lib/kubernetes/ca.pem"
      - "--etcd-certfile=/var/lib/kubernetes/kubernetes.pem"
      - "--etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem"
      - "--etcd-servers=https://10.240.0.10:2379,https://10.240.0.11:2379,https://10.240.0.12:2379"
      - "--event-ttl=1h"
      - "--experimental-encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml"
      - "--kubelet-certificate-authority=/var/lib/kubernetes/ca.pem"
      - "--kubelet-client-certificate=/var/lib/kubernetes/kubernetes.pem"
      - "--kubelet-client-key=/var/lib/kubernetes/kubernetes-key.pem"
      - "--kubelet-https=true"
      - "--runtime-config=api/all"
      - "--service-account-key-file=/var/lib/kubernetes/service-account.pem"
      - "--service-cluster-ip-range=10.32.0.0/24"
      - "--service-node-port-range=30000-32767"
      - "--tls-cert-file=/var/lib/kubernetes/kubernetes.pem"
      - "--tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem"
      - "--enable-bootstrap-token-auth=true"
      - "--requestheader-client-ca-file=/var/lib/kubernetes/ca.pem"
      - "--requestheader-allowed-names=aggregator"
      - "--requestheader-extra-headers-prefix=X-Remote-Extra-"
      - "--requestheader-group-headers=X-Remote-Group"
      - "--requestheader-username-headers=X-Remote-User"
      - "--enable-aggregator-routing=false"
      - "--proxy-client-cert-file=/var/lib/kubernetes/aggregator.pem"
      - "--proxy-client-key-file=/var/lib/kubernetes/aggregator-key.pem"
      - "--v=2"
    ports:
    - containerPort: 6443
      hostPort: 6443
      name: https
    - containerPort: 8080
      hostPort: 8080
      name: local
    volumeMounts:
    - mountPath: /var/lib/kubernetes
      name: varlibkubernetes
    - mountPath: /var/log
      name: varlog
  volumes:
  - hostPath:
      path: /var/lib/kubernetes
    name: varlibkubernetes
  - hostPath:
      path: /var/log
    name: varlog
EOF
