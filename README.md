# LSeries-NFS-Server
Template for Deploying an NFS Server with LSeries - nvme disks and Accelerated Networking.

You must specify an existing VNet/Subnet for it to attach to.
There will be no Public IP address for this server.

All of the nvme disks will be combined into one RAID 0 device which will then be exported via NFS as the /share/data directory. 


[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fgrandparoach%2FPremium-NFS-Server%2FLSeries%2Fazuredeploy.json)  



