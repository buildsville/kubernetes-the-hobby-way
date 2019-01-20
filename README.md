Kubrenetes the HOBBY way
=====

I studied Kubernetes with https://github.com/kelseyhightower/kubernetes-the-hard-way on Vagrant.  
Referred to https://github.com/kenfdev/kubernetes-the-hard-way-vagrant to run on Vagrant.  
There are some changes from these original.

#### What changed from the original hard way

- Control components run as Kubernetes Pods.
  - using kubelet's flag `--pod-manifest-path`
- Use calico.
- Use tls-bootstraping with bootstrap-token.
- Enable --allocate-node-cidr in kube-controller-manager
- Prefix number of scripts is not related to the head chapter number.
  - Became impossible to match while changing.

#### How to use this repository

- 1\. Preparing Vagrant's execution environment.
  - require scp plugin.
- 2\. Clone this repository.
- 3\. `vagrant up`
- 4\. Execute scripts in `scripts/manually` directory in the order of prefix numbers.
  - scripts of `controller` directory must be execute in controller-node (with `vagrant ssh`) and these of `worker` directory in worker-node too.
