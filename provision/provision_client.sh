#!/usr/bin/env bash

echo "Installing Dev Packages..."
yum -q -y install git gcc

echo "Installing Erlang Client"

if [ ! -d /home/vagrant/sources/riak-erlang-client ]; then
	git clone -b 2.4.2 https://github.com/basho/riak-erlang-client.git /home/vagrant/sources/riak-erlang-client &> /dev/null
fi

cd ./sources/riak-erlang-client
make &> /dev/null
echo "alias erl_client='erl -pa $PWD/ebin $PWD/deps/*/ebin'" >> /home/vagrant/.bashrc
cd

echo "Installing Python Client"
yum -q -y install libffi-devel openssl-devel python-devel python-pip
pip install riak &> /dev/null


echo "Client setup complete."
