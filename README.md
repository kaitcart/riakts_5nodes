## Prerequisites

vagrant, virtualbox and git.

## Contents

This repo includes: 

* A Vagrantfile for creating a 5 node Riak cluster and a client server that can be used to install other software that interacts with the cluster. All with a base OS of CentOS 7. 

* Provisioning scripts that: install Riak TS 1.4, update the ulimit, setup networking between the nodes, and a few other tasks. 

## Create a cluster
```
vagrant box add box-cutter/centos67
git clone https://github.com/kaitcarter/riakts_5nodes.git
cd riakts_5nodes
vagrant up
```

## Log into a node
```
vagrant ssh nodekv1
```

