#!/bin/bash

set -x

MASTER_NAME=$1
echo $MASTER_NAME

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
	showmount -e ${MASTER_NAME}
	mount -t nfs ${MASTER_NAME}:${NFS_DATA} ${NFS_DATA}
	
	echo "${MASTER_NAME}:${NFS_DATA} ${NFS_DATA} nfs defaults,nofail  0 0" >> /etc/fstab
}


systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

install_pkgs
mount_nfs

exit 0
