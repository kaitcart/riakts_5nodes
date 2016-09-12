#!/bin/env bash

case $HOSTNAME in
	(node2.riak.local)
	(node3.riak.local)
	(node4.riak.local)
	(node5.riak.local) riak-admin cluster join node1.riak.local;;
	(*) ;;
esac
