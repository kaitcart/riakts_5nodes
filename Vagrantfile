Vagrant.configure("2") do |config|
  config.vm.box = "box-cutter/centos67"

  # Working around a potential stale ssh key bug. Or a stale ssh key
  # misconfiguration. Either way, this should allow us to make sure fresh keys
  # are generated on `up`.
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.synced_folder ".", "/vagrant", disabled:true
 #  config.vm.synced_folder ".ssh", "/root/.ssh", owner: "root", group: "root"

  config.vm.provision "all", type: "shell", path: "provision/provision_all.sh"
  
  config.vm.define "client" do |client|
    client.vm.hostname = "client.riak.local"
    client.vm.network "private_network", ip: "10.10.10.40"
  end

  (1..5).each do |index|
    last_octet = 40 + index
    
    config.vm.define "tsnode#{index}" do |node|
      node.vm.hostname = "tsnode#{index}.riak.local"
      node.vm.network "private_network", ip: "10.10.10.#{last_octet}"
      node.vm.provision "tsnode#{index}", type: "shell", path: "provision/provision_node.sh"
    
      if index > 1
        node.vm.provision "riak", type: "shell", inline: <<-CLUSTER_JOIN
        riak-admin cluster join riak@tsnode1.riak.local
        CLUSTER_JOIN
      
        if index == 5
          node.vm.provision "riak-plan-commit", type: "shell", inline: <<-CLUSTER_COMMIT
          sleep 5
        
          riak-admin cluster plan
          riak-admin cluster commit
          
          sleep 5
          
          CLUSTER_COMMIT
        end
      end
    end
  end
end
