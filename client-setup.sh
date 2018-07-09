#!/bin/bash

install_pkgs()
{
    yum -y install epel-release
}


systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

install_pkgs

exit 0
