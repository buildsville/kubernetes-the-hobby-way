#!/bin/bash
### distribute bootstrap token and scripts to run on each node ###

for instance in worker-0 worker-1 worker-2; do
  vagrant scp token-id.txt ${instance}:~/
  vagrant scp token-secret.txt ${instance}:~/
done

cd `dirname $0`

for instance in controller-0 controller-1 controller-2; do
	for file in `ls ../controller`; do
		vagrant scp ../controller/${file} ${instance}:~/;
	done
done

for instance in worker-0 worker-1 worker-2; do
	for file in `ls ../worker`; do
		vagrant scp ../worker/${file} ${instance}:~/;
	done
done

for file in `ls ../lb`; do
	vagrant scp ../lb/${file} lb-0:~/;
done
