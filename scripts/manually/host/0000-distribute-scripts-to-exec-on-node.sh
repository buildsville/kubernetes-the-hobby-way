#!/bin/bash
### distribute scripts to run on each node ###

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
