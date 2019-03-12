#!/bin/bash
ansible-playbook /vagrant/playbooks/srv_db.yml -i /home/vagrant/host.txt
ansible-playbook /vagrant/playbooks/srv_redis.yml -i /home/vagrant/host.txt
ansible-playbook /vagrant/playbooks/srv_web.yml -i /home/vagrant/host.txt
ansible-playbook /vagrant/playbooks/srv_lb.yml -i /home/vagrant/host.txt