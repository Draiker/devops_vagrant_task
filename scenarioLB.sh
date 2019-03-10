#!/usr/bin/bash

NODECOUNT=${1}
NETWORK=${2}
STARTIPNUM=${3}
LBHOSTIP=${4}

#sudo yum -y update

# Install Load Balancer
sudo yum -y install haproxy
sudo cp -f /vagrant/data/haproxy.cfg /etc/haproxy/haproxy.cfg

sudo sed -i "s/LBHOSTIP:80/$LBHOSTIP:80/" /etc/haproxy/haproxy.cfg

sudo cat <<EOF | sudo tee -a /etc/haproxy/haproxy.cfg
#---------------------------------------------------------------------
# round robin balancing between the various backends
#---------------------------------------------------------------------
backend app
    balance     roundrobin

EOF
for ((COUNTER=0; COUNTER<NODECOUNT; COUNTER+=1))
do
    LASTOCT=$((STARTIPNUM+COUNTER))
    IPWEBHOST="${NETWORK}${LASTOCT}"
    cat <<EOF | sudo tee -a /etc/haproxy/haproxy.cfg
    server    app$((COUNTER+1))   ${IPWEBHOST}:80    check
EOF
done

sudo systemctl start haproxy
sudo systemctl enable haproxy
