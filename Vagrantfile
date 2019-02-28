# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "192.168.56.100"
  config.vm.hostname = "LAMP-Moodle"
  #config.vm.network "private_network", type: "dhcp"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
=begin 
    config.vm.provider :vmware_esxi do |esxi|

      esxi.esxi_hostname = "10.6.0.11"
      esxi.esxi_hostport = 22
      esxi.esxi_username = "root"
      esxi.esxi_password = "prompt:"
      esxi.esxi_virtual_network = "VM Network"
      esxi.esxi_disk_store = "Storage"

      esxi.guest_name = "Vagrant_VM"
      #esxi.guest_username = "sysadmin"
      esxi.guest_memsize = "2048"
      esxi.guest_numvcpus = "1"

      #esxi.guest_snapshot_includememory = "true"
      #esxi.guest_snapshot_quiesced = "true"

      esxi.guest_virtualhw_version = "14"

    end
=end
  config.vm.provision "shell", path: "scenario.sh"

end
