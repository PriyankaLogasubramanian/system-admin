#!/bin/bash

# generate passwordless SSH
runuser -u loga -- ssh-keygen -q -t rsa -f /users/loga/.ssh/id_rsa -N ''
runuser -u loga -- cat /users/lngo/.ssh/id_rsa.pub >> /users/loga/.ssh/authorized_keys

# setup NFS for key sharing
apt update
apt install -y nfs-kernel-server
mkdir /var/nfs/keys -p
cp /users/loga/.ssh/id_rsa* /var/nfs/keys
chown nobody:nogroup /var/nfs/keys
echo "/var/nfs/keys 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
systemctl restart nfs-kernel-server

# setup ansible
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible
cp /local/repository/hosts /etc/ansible/

# configure to disable strict hostkey checking
echo "[defaults]" | sudo tee -a /etc/ansible/ansible.cfg
echo "host_key_checking = False" | sudo tee -a /etc/ansible/ansible.cfg

# setup lamp
runuser -u loga -- bash /local/repository/setup_ansible.sh
