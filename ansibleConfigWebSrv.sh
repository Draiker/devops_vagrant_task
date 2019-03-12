#!/bin/bash

WEBSRVIP=${1}
WEBSRVNAME=${2}
LBHOSTIP=${3}

sudo cat <<EOF | sudo tee -a /vagrant/templates/haproxy.cfg.j2
    server    ${WEBSRVNAME}   ${WEBSRVIP}:80    check
EOF

cat <<EOF | sudo tee -a /home/vagrant/host.txt
${WEBSRVNAME} ansible_host=${WEBSRVIP} ansible_user=vagrant ansible_ssh_private_key_file=/home/vagrant/.ssh/${WEBSRVIP}.pem
EOF

sudo chmod 600 /home/vagrant/.ssh/*.pem