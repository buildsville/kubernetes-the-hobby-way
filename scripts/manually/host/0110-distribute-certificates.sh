#!/bin/bash
### distribute cert files to use on each node ###

# This script assumes you have the vagrant-scp plugin installed

for instance in worker-0 worker-1 worker-2 controller-0 controller-1 controller-2; do
  vagrant scp ca.pem ${instance}:~/
  vagrant scp ca-key.pem ${instance}:~/
done

for instance in controller-0 controller-1 controller-2; do
  vagrant scp kubernetes-key.pem ${instance}:~/
  vagrant scp kubernetes.pem ${instance}:~/
  vagrant scp service-account-key.pem ${instance}:~/
  vagrant scp service-account.pem ${instance}:~/
  vagrant scp ${instance}-key.pem ${instance}:~/
  vagrant scp ${instance}.pem ${instance}:~/
  vagrant scp aggregator-key.pem ${instance}:~/
  vagrant scp aggregator.pem ${instance}:~/
  vagrant scp metrics-server-key.pem ${instance}:~/
  vagrant scp metrics-server.pem ${instance}:~/
done
