#!/bin/bash
### create yaml file for kube-scheduler pod ###

sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/

cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

cat <<EOF | sudo tee /etc/kubernetes/manifests/kube-scheduler.service
apiVersion: v1
kind: Pod
metadata:
  name: kube-scheduler
  namespace: kube-system
  labels:
    k8s-app: kube-scheduler
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ''
spec:
  hostNetwork: true
  containers:
  - name: kube-scheduler
    image: k8s.gcr.io/kube-scheduler-amd64:v1.13.2
    command:
      - "/usr/local/bin/kube-scheduler"
      - "--config=/etc/kubernetes/config/kube-scheduler.yaml"
      - "--v=2"
    resources:
      requests:
        cpu: 100m
    livenessProbe:
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10251
      initialDelaySeconds: 15
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /var/lib/kubernetes
      name: varlibkubernetes
    - mountPath: /etc/kubernetes/config
      name: etckubernetesconfig
    - mountPath: /var/log
      name: varlog
  volumes:
  - hostPath:
      path: /var/lib/kubernetes
    name: varlibkubernetes
  - hostPath:
      path: /etc/kubernetes/config
    name: etckubernetesconfig
  - hostPath:
      path: /var/log
    name: varlog
EOF
