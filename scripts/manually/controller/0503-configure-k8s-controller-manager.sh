#!/bin/bash
### create yaml file for kube-controller-manager pod ###

sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/

cat <<EOF | sudo tee /etc/kubernetes/manifests/kube-controller-manager.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kube-controller-manager
  namespace: kube-system
  labels:
    k8s-app: kube-controller-manager
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ''
spec:
  hostNetwork: true
  containers:
  - name: kube-controller-manager
    image: k8s.gcr.io/kube-controller-manager-amd64:v1.16.2
    command:
      - "/usr/local/bin/kube-controller-manager"
      - "--address=0.0.0.0"
      - "--cluster-cidr=10.200.0.0/16"
      - "--cluster-name=kubernetes"
      - "--cluster-signing-cert-file=/var/lib/kubernetes/ca.pem"
      - "--cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem"
      - "--kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig"
      - "--leader-elect=true"
      - "--root-ca-file=/var/lib/kubernetes/ca.pem"
      - "--service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem"
      - "--service-cluster-ip-range=10.32.0.0/24"
      - "--use-service-account-credentials=true"
      - "--allocate-node-cidrs=true"
      - "--node-cidr-mask-size=24"
      - "--controllers=*,bootstrapsigner,tokencleaner"
      - "--v=2"
    resources:
      requests:
        cpu: 100m
        memory: 100M
      limits:
        cpu: 250m
        memory: 512M
    livenessProbe:
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10252
      initialDelaySeconds: 15
      timeoutSeconds: 15
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
