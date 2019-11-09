#!/bin/bash
### create necessary directories and install binaries ###

sudo mkdir -p /etc/coredns/
sudo mkdir -p /etc/node-hosts-converter/
sudo touch /etc/node-hosts-converter/hosts
wget -q --show-progress \
  https://github.com/buildsville/node-hosts-converter/releases/download/v0.2/node-hosts-converter_v0.2_linux_amd64.tgz \
  https://github.com/coredns/coredns/releases/download/v1.6.5/coredns_1.6.5_linux_amd64.tgz \
  https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl
tar xvzf node-hosts-converter_v0.2_linux_amd64.tgz
tar xvzf coredns_1.6.5_linux_amd64.tgz
chmod +x kubectl
sudo mv kubectl node-hosts-converter coredns /usr/local/bin
sudo mv node-hosts-converter.kubeconfig /etc/node-hosts-converter/kubeconfig
