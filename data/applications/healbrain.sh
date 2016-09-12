#! /usr/bin/env bash

case $HOSTNAME in
	node[1-2].riak.local)
		iptables -D INPUT -s node3.riak.local -j REJECT
		iptables -D OUTPUT -d node3.riak.local -j REJECT
		iptables -D INPUT -s node4.riak.local -j REJECT
		iptables -D OUTPUT -d node4.riak.local -j REJECT
		iptables -D INPUT -s node5.riak.local -j REJECT
		iptables -D OUTPUT -d node5.riak.local -j REJECT
		;;
	node[3-5].riak.local)
		iptables -D INPUT -s node1.riak.local -j REJECT
		iptables -D OUTPUT -d node1.riak.local -j REJECT
		iptables -D INPUT -s node2.riak.local -j REJECT
		iptables -D OUTPUT -d node2.riak.local -j REJECT
		;;
	*)
		;;
esac