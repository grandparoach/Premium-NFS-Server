#!/bin/bash

set -x

# Shares
NFS_DATA=/share/data
mkdir -p $NFS_DATA


install_pkgs()
{
    yum -y install epel-release
    yum -y install nfs-utils nfs-utils-lib rpcbind  
}




mount_nfs()
{

    echo "$NFS_DATA    *(rw,async)" >> /etc/exports
    systemctl enable rpcbind || echo "Already enabled"
    systemctl enable nfs-server || echo "Already enabled"
    systemctl start rpcbind || echo "Already enabled"
    systemctl start nfs-server || echo "Already enabled"
    
    exportfs
	exportfs -a
	exportfs 
}

systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

install_pkgs
mount_nfs

exit 0
