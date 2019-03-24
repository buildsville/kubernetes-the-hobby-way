#!/bin/bash
### distribute kubeconfig files to use on each node ###
# This script assumes you have the vagrant-scp plugin installed

for instance in controller-0 controller-1 controller-2; do
  vagrant scp ${instance}.kubeconfig ${instance}:~/
  vagrant scp admin.kubeconfig ${instance}:~/
  vagrant scp kube-controller-manager.kubeconfig ${instance}:~/
  vagrant scp kube-scheduler.kubeconfig ${instance}:~/
done

vagrant scp node-hosts-converter.kubeconfig lb-0:~/
