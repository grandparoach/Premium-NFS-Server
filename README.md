# Premium-NFS-Server
Template for Deploying an NFS Server with Premium Storage and Accelerated Networking.
This template will attach up to 16 drives and create a RAID 0 stripe, then export it for sharing via NFS

You must specify an existing VNet/Subnet for it to attach to.
You can specify with an input parameter whther you want a Public IP address assigned to the machine.

The DataDiskSize and nbDataDisks parameters refer to the NFS Server.  ndDataDisks of DataDiskSize will be attached to the NFS Server, then they will be formatted and combined into a single RAID 0 volume which will then be exported as the /share/data directory. 


[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fgrandparoach%2FPremium-NFS-Server%2Fmaster%2Fazuredeploy.json)  



