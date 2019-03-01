# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/7"
NODE_COUNT = 1

# DataBase credentials
DB_ROOTPASSWD = "R00t-P@Ssw0rd"
DB_NAME = "moodle_main"
DB_USER = "moodle_web"
DB_PASSWD = "M00dle-P@Ssw0rd"

NETWORK = "192.168.56."
DB_HOST_IP = "#{NETWORK}11"

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.define "serverDB" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "serverDB"
    subconfig.vm.network :private_network, ip: DB_HOST_IP
    config.vm.provision "shell", path: "scenarioDB.sh", :args => [DB_ROOTPASSWD, DB_NAME, DB_USER, DB_PASSWD, NETWORK]
  end
=begin
  (1..NODE_COUNT).each do |i|
    config.vm.define "serverWeb#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "serverWeb#{i}"
      subconfig.vm.network :private_network, ip: "#{NETWORK}#{20 + i}"
      config.vm.provision "shell", path: "scenarioWebsrv.sh", :args => [DBROOTPASSWD, DBNAME, DBUSER, DBPASSWD, DB_HOST_IP]
    end
  end
=end
end
