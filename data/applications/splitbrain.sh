#! /usr/bin/env bash

case $HOSTNAME in
	node[1-2].riak.local)
		iptables -A INPUT -s node3.riak.local -j REJECT
		iptables -A OUTPUT -d node3.riak.local -j REJECT
		iptables -A INPUT -s node4.riak.local -j REJECT
		iptables -A OUTPUT -d node4.riak.local -j REJECT
		iptables -A INPUT -s node5.riak.local -j REJECT
		iptables -A OUTPUT -d node5.riak.local -j REJECT
		;;
	node[3-5].riak.local)
		iptables -A INPUT -s node1.riak.local -j REJECT
		iptables -A OUTPUT -d node1.riak.local -j REJECT
		iptables -A INPUT -s node2.riak.local -j REJECT
		iptables -A OUTPUT -d node2.riak.local -j REJECT
		;;
	*)
		;;
esac
