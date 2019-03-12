#!/bin/bash

DBHOSTIP=${1}
LBHOSTIP=${2}

#Install ansible
sudo yum -y install epel-release
sudo yum -y install ansible
sudo sed -i -e 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg
rm -f /home/vagrant/host.txt
cat <<EOF | sudo tee -a /home/vagrant/host.txt
[DBservers]
srvDB ansible_host=${DBHOSTIP} ansible_user=vagrant ansible_ssh_private_key_file=/home/vagrant/.ssh/${DBHOSTIP}.pem

[LBservers]
srvLB ansible_host=${LBHOSTIP} ansible_user=vagrant ansible_ssh_private_key_file=/home/vagrant/.ssh/${LBHOSTIP}.pem 

[srvWEB]
EOF

sudo sed -i "s/LBHOSTIP:80/${LBHOSTIP}:80/" /vagrant/playbooks/templates/haproxy.cfg.j2
