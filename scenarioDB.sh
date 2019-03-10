#!/bin/bash

# Define Vars
DBNAME=${1}
DBUSER=${2}
DBPASSWD=${3}
NODECOUNT=${4}
NETWORK=${5}
STARTIPNUM=${6}

# Update system
#sudo yum -y update

# Install EPEL package
sudo yum -y install epel-release yum-utils

# Install PostgresSQL
if command -V postgres 2>/dev/null; then
    echo "PostresSQL is already installed."
else
    sudo yum -y install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
    sudo yum -y install postgresql11 postgresql11-server
    sudo /usr/pgsql-11/bin/postgresql-11-setup initdb

    sudo systemctl start postgresql-11
    sudo systemctl enable postgresql-11

    # Secure config MariaDB
    sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/11/data/postgresql.conf
    sudo sed -i -e "s/#port = 5432/port = 5432/g" /var/lib/pgsql/11/data/postgresql.conf
    for ((COUNTER=0; COUNTER<NODECOUNT; COUNTER+=1))
    do
        LASTOCT=$((STARTIPNUM+COUNTER))
        IPWEBHOST="${NETWORK}${LASTOCT}"
        cat <<EOF | sudo tee -a /var/lib/pgsql/11/data/pg_hba.conf
host    ${DBNAME}    ${DBUSER}    ${IPWEBHOST}/32    password
EOF
    done
    
    cat <<EOF | sudo tee -a /var/lib/pgsql/11/data/pg_hba.conf
host    all    all    0.0.0.0/0    reject
EOF
    
    sudo -u postgres psql -c "CREATE USER ${DBUSER} WITH ENCRYPTED PASSWORD '${DBPASSWD}';"
    sudo -u postgres psql -c "CREATE DATABASE ${DBNAME} WITH OWNER ${DBUSER};"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${DBNAME} to ${DBUSER};"

    sudo systemctl restart postgresql-11
    
fi

sudo systemctl restart mariadb

# Setup&Config Firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-port=5432/tcp 
sudo firewall-cmd --reload