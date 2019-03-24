#!/bin/bash
### create controller kubelet service and config file ###

sudo mv ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo mv ca.pem /var/lib/kubernetes/

INTERNAL_IP=$(ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
kubeReserved:
  cpu: "100m"
  memory: "100Mi"
kubeReservedCgroup: "/runtime.slice"
systemReserved:
  cpu: "100m"
  memory: "100Mi"
systemReservedCgroup: "/system.slice"
kubeletCgroups: "/runtime.slice"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/cpuset/system.slice
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/hugetlb/system.slice
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/cpuset/runtime.slice
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/hugetlb/runtime.slice
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --allow-privileged=true \\
  --pod-manifest-path=/etc/kubernetes/manifests \\
  --node-labels=node.kubernetes.io/role=master,node-role.kubernetes.io/master= \\
  --register-with-taints=node.kubernetes.io/role=master:NoSchedule \\
  --node-ip=${INTERNAL_IP} \\
  --cgroup-root="/" \\
  --system-cgroups="/system.slice" \\
  --runtime-cgroups="/runtime.slice" \\
  --enforce-node-allocatable="pods" \\
  --v=2
Restart=on-failure
RestartSec=5
Slice=/runtime.slice

[Install]
WantedBy=multi-user.target
EOF
