#!/bin/bash
### approve serving csr ###

kubectl get csr -o json | jq -r '.items[] | select(.status == {}) | .metadata.name' | xargs kubectl certificate approve
