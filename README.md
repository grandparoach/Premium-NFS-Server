# Premium-NFS-Server
Template for Deploying an NFS Server with Premium Storage and Accelerated Networking.

You must specify an existing VNet/Subnet for it to attach to.
This will also assign a PublicIP address to the server.

The DataDiskSize and nbDataDisks parameters refer to the NFS Server.  ndDataDisks of DataDiskSize will be attached to the NFS Server, then they will be formatted and combined into a single RAID 0 volume which will then be exported as the /share/data directory. 


[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fgrandparoach%2FPremium-NFS-Server%2FnoPubIP%2Fazuredeploy.json)  



