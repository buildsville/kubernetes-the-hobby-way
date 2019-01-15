#!/bin/bash
### distribute token file to worker node ###

for instance in worker-0 worker-1 worker-2; do
  vagrant scp token-id.txt ${instance}:~/
  vagrant scp token-secret.txt ${instance}:~/
done