#!/bin/bash
### create necessary directories and install binaries ###

sudo mkdir -p /etc/coredns/
sudo mkdir -p /etc/node-hosts-converter/
sudo touch /etc/node-hosts-converter/hosts
wget -q --show-progress \
  https://github.com/buildsville/node-hosts-converter/releases/download/v0.1/node-hosts-converter_v0.1_linux_amd64.tgz \
  https://github.com/coredns/coredns/releases/download/v1.3.1/coredns_1.3.1_linux_amd64.tgz \
  https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubectl
tar xvzf node-hosts-converter_v0.1_linux_amd64.tgz
tar xvzf coredns_1.3.1_linux_amd64.tgz
chmod +x kubectl
sudo mv kubectl node-hosts-converter coredns /usr/local/bin
sudo mv node-hosts-converter.kubeconfig /etc/node-hosts-converter/kubeconfig
