# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/7"
NETWORK = "192.168.56."
LB_HOST_IP = "#{NETWORK}10" # 192.168.56.10
DB_HOST_IP = "#{NETWORK}11" # 192.168.56.11
ANS_HOST_IP = "#{NETWORK}254" # 192.168.56.254
START_IP_NUM = 21 # 192.168.56.21-253
NODE_COUNT = 2

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  # Run all VMs
  config.vm.define "srvDB" do |subconfigdb|
    subconfigdb.vm.box = BOX_IMAGE
    subconfigdb.vm.hostname = "srvDB"
    subconfigdb.vm.network :private_network, ip: "#{DB_HOST_IP}"
  end
  
  (1..NODE_COUNT).each do |i|
    config.vm.define "srvWeb#{i}" do |subconfigweb|
      SRV_HOST_IP = "#{NETWORK}#{START_IP_NUM + i - 1}"
      subconfigweb.vm.box = BOX_IMAGE
      subconfigweb.vm.hostname = "srvWeb#{i}"
      subconfigweb.vm.network :private_network, ip: "#{SRV_HOST_IP}"
    end
  end
  
  config.vm.define "srvLB" do |subconfiglb|
    subconfiglb.vm.box = BOX_IMAGE
    subconfiglb.vm.hostname = "srvLB"
    subconfiglb.vm.network :private_network, ip: "#{LB_HOST_IP}"
  end

  config.vm.define "srvANS" do |subconfigans|
    subconfigans.vm.box = BOX_IMAGE
    subconfigans.vm.hostname = "srvANS"
    subconfigans.vm.network :private_network, ip: "#{ANS_HOST_IP}"
    subconfigans.vm.provision "shell", path: "ansibleInit.sh", :args => [DB_HOST_IP, LB_HOST_IP]
    subconfigans.vm.provision "file", source: ".vagrant/machines/srvDB/virtualbox/private_key", destination: "~/.ssh/#{DB_HOST_IP}.pem"
    subconfigans.vm.provision "file", source: ".vagrant/machines/srvLB/virtualbox/private_key", destination: "~/.ssh/#{LB_HOST_IP}.pem"
    (1..NODE_COUNT).each do |n|
      SRV_HOST_IP = "#{NETWORK}#{START_IP_NUM + n - 1}"
      SRV_HOST_NAME = "srvWeb#{n}"
      subconfigans.vm.provision "file", source: ".vagrant/machines/#{SRV_HOST_NAME}/virtualbox/private_key", destination: "~/.ssh/#{SRV_HOST_IP}.pem"
      subconfigans.vm.provision "shell", path: "ansibleConfigWebSrv.sh", :args => [SRV_HOST_IP, SRV_HOST_NAME, LB_HOST_IP]
    end
    #subconfigans.vm.provision "shell", path: "ansibleRun.sh"
  end
end
