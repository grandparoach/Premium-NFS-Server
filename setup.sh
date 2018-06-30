#!/bin/bash

set -x

ADMIN_USER=$1

# Shares
NFS_DATA=/share/data
mkdir -p $NFS_DATA


BLACKLIST="/dev/sda|/dev/sdb"

scan_for_new_disks() {
    # Looks for unpartitioned disks
    declare -a RET
    DEVS=($(ls -1 /dev/sd*|egrep -v "${BLACKLIST}"|egrep -v "[0-9]$"))
    for DEV in "${DEVS[@]}";
    do
        # Check each device if there is a "1" partition.  If not,
        # "assume" it is not partitioned.
        if [ ! -b ${DEV}1 ];
        then
            RET+="${DEV} "
        fi
    done
    echo "${RET}"
}

get_disk_count() {
    DISKCOUNT=0
    for DISK in "${DISKS[@]}";
    do 
        DISKCOUNT+=1
    done;
    echo "$DISKCOUNT"
}


# Installs all required packages.
#
install_pkgs()
{
    yum -y install epel-release
    yum -y install nfs-utils nfs-utils-lib rpcbind mdadm 
}


setup_raid()
{
	#Verify attached data disks
	ls -l /dev | grep sd
	
	DISKS=($(scan_for_new_disks))
    echo "Disks are ${DISKS[@]}"
    declare -i DISKCOUNT
    DISKCOUNT=$(get_disk_count) 
    echo "Disk count is $DISKCOUNT"
	
	#Create RAID md device
	mdadm -C /dev/md0 -l raid0 -n "$DISKCOUNT" "${DISKS[@]}"

    #Create File System
    mkfs -t ext4 /dev/md0
    echo "/dev/md0 $NFS_DATA xfs rw,noatime,attr2,inode64,nobarrier,sunit=1024,swidth=4096,nofail 0 2" >> /etc/fstab
}

mount_nfs()
{
    chown $ADMIN_USER:1000 $NFS_DATA
    chmod 777 $NFS_DATA
    
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
setup_raid
mount_nfs

exit 0
