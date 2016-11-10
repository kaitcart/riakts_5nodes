## Prerequisites

vagrant, virtualbox and git.

## Contents

This repo includes: 

* A Vagrantfile for creating a 5 node Riak cluster with a client server that can be used to install other software that interacts with the cluster.

* Provisioning scripts that: install riak, update the ulimit, setup networking between the nodes, and a few other tasks. 

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

