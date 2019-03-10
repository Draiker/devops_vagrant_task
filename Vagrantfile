# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/7"
NODE_COUNT = 2
START_IP_NUM = 20
NETWORK = "192.168.56."
DB_HOST_IP = "#{NETWORK}11"

# DataBase credentials
DB_ROOTPASSWD = "R00t-P@Ssw0rd"
DB_NAME = "moodle_main"
DB_USER = "moodle_web"
DB_PASSWD = "M00dle-P@Ssw0rd"

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.define "serverDB" do |subconfigdb|
    subconfigdb.vm.box = BOX_IMAGE
    subconfigdb.vm.hostname = "serverDB"
    subconfigdb.vm.network :private_network, ip: DB_HOST_IP
    subconfigdb.vm.provision "shell", path: "scenarioDB.sh", :args => [DB_NAME, DB_USER, DB_PASSWD, NODE_COUNT, NETWORK, START_IP_NUM]
  end
=begin
  (1..NODE_COUNT).each do |i|
    config.vm.define "serverWeb#{i}" do |subconfigweb|
      SRV_HOST_IP = "#{NETWORK}#{START_IP_NUM + i}"
      subconfigweb.vm.box = BOX_IMAGE
      subconfigweb.vm.hostname = "serverWeb#{i}"
      subconfigweb.vm.network :private_network, ip: "#{SRV_HOST_IP}"
      subconfigweb.vm.provision "shell", path: "scenarioWebsrv.sh", :args => [SRV_HOST_IP, DB_NAME, DB_USER, DB_PASSWD, DB_HOST_IP]
    end
  end
=end
end
