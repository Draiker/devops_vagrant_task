#!/bin/bash

# Define Vars
DBROOTPASS="P@$$w0rd"
MAINDB="moodle"
USERDB="moodleUS"
PASSWDDB="moodlePAS"

# Update system
sudo yum -y update

# Install EPEL package
sudo yum -y install epel-release
sudo yum -y install yum-utils

# Install Apache
if command -v httpd 2>/dev/null; then
    echo "Apache is already installed."
else
    sudo yum -y install httpd

    # Remove the pre-set Apache welcome page
    sudo sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf

    # Prevent Apache from listing web directory files to visitors:
    sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf

    sudo systemctl start httpd
    sudo systemctl enable httpd
fi

# Install PHP 7.0
if command -v php 2>/dev/null; then
    echo "PHP is already installed."
else
    sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum-config-manager --disable remi-php54
    sudo yum-config-manager --enable remi-php73
    sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-ldap php-zip php-fileinfo php-xml php-intl php-mbstring php-xmlrpc php-soap php-fpm php-mysqlnd php-devel php-pear php-bcmath php-json
fi

# Download&Unpack Moodle
curl https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz -o moodle-latest-36.tgz -s
sudo tar -xzf moodle-latest-36.tgz -C /var/www/html/

# Install App
sudo php /var/www/html/moodle/admin/cli/install.php --chmod=2770 \
 --lang=uk \
 --dbtype=mariadb \
 --wwwroot=http://192.168.56.100/moodle \
 --dataroot=/var/moodledata \
 --dbname=$MAINDB \
 --dbuser=$USERDB \
 --dbpass=$PASSWDDB \
 --dbport=3306 \
 --fullname=Moodle \
 --shortname=moodle \
 --summary=Moodle \
 --adminpass=Admin1 \
 --non-interactive \
 --agree-license
sudo chmod o+r /var/www/html/moodle/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata
sudo chown -R apache:apache /var/moodledata
sudo chown -R apache:apache /var/www/
sudo systemctl restart httpd

# Setup&Config Firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload