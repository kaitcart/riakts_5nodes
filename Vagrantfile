Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.2"

  # Working around a potential stale ssh key bug. Or a stale ssh key
  # misconfiguration. Either way, this should allow us to make sure fresh keys
  # are generated on `up`.
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.synced_folder ".", "/vagrant", disabled:true
  config.vm.synced_folder ".yumcache", "/var/cache/yum",
    owner: "root", group: "root"
  #config.vm.synced_folder ".rootcache", "/root/.cache",
  #  owner: "root", group: "root"
  config.vm.synced_folder "data/applications", "/vagrant/applications",
    owner: "root", group: "root"
  config.vm.synced_folder ".downloads", "/home/vagrant/Downloads"
  config.vm.synced_folder ".sources", "/home/vagrant/sources"
  config.vm.synced_folder "labs", "/home/vagrant/labs"
  config.vm.synced_folder ".ssh", "/root/.ssh", owner: "root", group: "root"

  config.vm.provision "all", type: "shell", path: "provision/provision_all.sh"
  
  config.vm.define "client" do |client|
    client.vm.hostname = "client.riak.local"
    client.vm.network "private_network", ip: "10.10.10.10"
    client.vm.provision "client", type: "shell", path: "provision/provision_client.sh"
  end

  (1..5).each do |index|
    last_octet = 10 + index
    
    config.vm.define "node#{index}" do |node|
      node.vm.hostname = "node#{index}.riak.local"
      node.vm.network "private_network", ip: "10.10.10.#{last_octet}"
      node.vm.provision "node#{index}", type: "shell", path: "provision/provision_node.sh"
    
      if index > 1
        node.vm.provision "riak", type: "shell", inline: <<-CLUSTER_JOIN
        riak-admin cluster join riak@node1.riak.local
        CLUSTER_JOIN
      
        if index == 5
          node.vm.provision "riak-plan-commit", type: "shell", inline: <<-CLUSTER_COMMIT
          sleep 5
        
          riak-admin cluster plan
          riak-admin cluster commit
          
          sleep 5
          riak-admin bucket-type create standard
          riak-admin bucket-type activate standard
          
          riak-admin bucket-type create maps '{"props":{"datatype":"map"}}'
          riak-admin bucket-type activate maps
          riak-admin bucket-type create sets '{"props":{"datatype":"set"}}'
          riak-admin bucket-type activate sets
          riak-admin bucket-type create counters '{"props":{"datatype":"counter"}}'
          riak-admin bucket-type activate counters
          CLUSTER_COMMIT
        end
      end
    end
  end
end