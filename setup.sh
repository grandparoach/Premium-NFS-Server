#!/bin/bash

set -x

# Shares
NFS_DATA=/share/data
mkdir -p $NFS_DATA
chmod 777 $NFS_DATA



# Installs all required packages.
#
install_pkgs()
{
    apt install -y nfs-server 
}


setup_raid()
{
	#Verify attached data disks
	ls -l /dev | grep nvme

	DISKS=($(ls /dev/nvme*n1))
    echo "Disks are ${DISKS[@]}"

    declare -i DISKCOUNT
    DISKCOUNT=($(ls -1 /dev/nvme*n1 | wc -l))
    echo "Disk count is $DISKCOUNT"
	
	#Create RAID md device
	mdadm -C /dev/md0 -l raid0 -n "$DISKCOUNT" "${DISKS[@]}"

    #Create File System
    mkfs -t xfs /dev/md0
    echo "/dev/md0 $NFS_DATA xfs rw,noatime,attr2,inode64,nobarrier,sunit=1024,swidth=4096,nofail 0 2" >> /etc/fstab

    mount -a
    
}

mount_nfs()
{
    #increase the NFS threads to 80
    sed -i 's/RPCNFSDCOUNT=8/RPCNFSDCOUNT=80/' /etc/init.d/nfs-kernel-server
    sed -i 's/RPCNFSDCOUNT=8/RPCNFSDCOUNT=80/' /etc/default/nfs-kernel-server

    echo "$NFS_DATA    *(rw,async,no_root_squash)" >> /etc/exports
    systemctl enable rpcbind || echo "Already enabled"
    systemctl enable nfs-server || echo "Already enabled"
    systemctl start rpcbind || echo "Already enabled"
    systemctl start nfs-server || echo "Already enabled"
    
    exportfs
	exportfs -a
	exportfs 
}

#systemctl stop firewalld
#systemctl disable firewalld

# Disable SELinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

install_pkgs
setup_raid
mount_nfs

exit 0
