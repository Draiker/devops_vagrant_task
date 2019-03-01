#!/bin/bash

# Define Vars
DBROOTPASSWD=${1}
DBNAME=${2}
DBUSER=${3}
DBPASSWD=${4}
NETWORK=${5}

# Update system
sudo yum -y update

# Install EPEL package
sudo yum -y install epel-release
sudo yum -y install yum-utils

# Install MariaDB
if command -v mysql 2>/dev/null; then
    echo "Mariadb is already installed."
else
    sudo cp /vagrant/data/MariaDB-10.3.repo /etc/yum.repos.d/MariaDB.repo

    sudo yum -y install MariaDB-server MariaDB-client
    sudo systemctl start mariadb
    sudo systemctl enable mariadb

    # Secure config MariaDB
    sudo sed -i -e 's/#bind-address=0.0.0.0/bind-address=0.0.0.0/g' /etc/my.cnf.d/server.cnf
    sudo chmod -v u+x /vagrant/data/mariadb-secure.sh
    sudo bash /vagrant/data/mariadb-secure.sh "${DBROOTPASSWD}"

    sudo mysql -uroot -p${DBROOTPASSWD} -e "SET GLOBAL character_set_server = 'utf8mb4';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "SET GLOBAL innodb_file_format = 'BARRACUDA';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "SET GLOBAL innodb_large_prefix = 'ON';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "SET GLOBAL innodb_file_per_table = 'ON';"
fi

#Create DB Moodle
RESULT=`mysqlshow --user=${DBUSER} --password=${DBPASSWD} ${DBNAME} | grep -v Wildcard | grep -o ${DBNAME}`
if [ "${RESULT}" == "${DBNAME}" ]; then
    echo "DataBase user ${DBUSER} is already exist."
else
    sudo mysql -uroot -p${DBROOTPASSWD} -e "CREATE DATABASE ${DBNAME};"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASSWD}';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "CREATE USER '${DBUSER}'@'${NETWORK}%' IDENTIFIED BY '${DBPASSWD}';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'localhost';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'${NETWORK}%';"
    sudo mysql -uroot -p${DBROOTPASSWD} -e "FLUSH PRIVILEGES;"
fi

sudo systemctl restart mariadb

# Setup&Config Firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp 
sudo firewall-cmd --reload