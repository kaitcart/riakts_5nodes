#!/usr/bin/env bash

echo "Installing Riak"

curl -LO http://s3.amazonaws.com/downloads.basho.com/riak_ts/1.4/1.4.0/rhel/6/riak-ts-1.4.0-1.el6.x86_64.rpm

yum -q -y install riak-ts-1.4.0-1.el6.x86_64.rpm

echo "Configuring Riak on node $(hostname)"
echo "nodename = riak@$(hostname)" >> /etc/riak/riak.conf
echo "listener.http.internal = 0.0.0.0:8098" >> /etc/riak/riak.conf
echo "listener.protobuf.internal = 0.0.0.0:8087" >> /etc/riak/riak.conf
echo "erlang.distribution.net_ticktime=5" >> /etc/riak/riak.conf # for DEMO purposes only! 

echo "Increasing File Limits"
echo '
# Added by Vagrant Provisioning Script
# ulimit settings for Riak
riak soft nofile 65536
riak hard nofile 65536

'  >> /etc/security/limits.d/90-riak.conf

chkconfig riak on
service riak start
riak-admin wait-for-service riak_kv &> /dev/null

