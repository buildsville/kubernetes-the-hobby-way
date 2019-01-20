#!/bin/bash

wget "https://github.com/coreos/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz"
tar -xvf etcd-v3.3.10-linux-amd64.tar.gz
sudo mv etcd-v3.3.10-linux-amd64/etcdctl /usr/local/bin/
rm etcd-v3.3.10-linux-amd64.tar.gz
rm -rf etcd-v3.3.10-linux-amd64
