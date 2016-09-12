## Prerequisites

vagrant, virtualbox and git.

## Create a cluster
```
vagrant box add bento/centos-7.2
git clone https://github.com/kesslerm/crdt_tutorial.git
cd crdt_tutorial
git submodule init && git submodule update
vagrant up
```

## Log into cluster
```
vagrant ssh client
```

## Jump to other hosts
```
tmux-cssh -cs node1
# or for all riak nodes at once
tmux-cssh -cs riak
```

