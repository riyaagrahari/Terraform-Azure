# Business Continuity and Disaster Recovery using Terraform

This terraform script creates Web-API-Database three-tier architecture with specific network traffic security rules as Web is untrusted network, open to outside world, API is semi-trusted network as it communicates with both Web and Database and Database is fully-trusted network with no connection to Web.

Web-API-Database is a 3 tier architecture which decouples to presentation, business or application and database layers induvidually. The business layer exposes its API to applications as well as for the remote presentation layer. Remote presentation layer uses REST API. There is a internal database API for communications between application layer and database layer. REST API’s input is processed by the application layer to perform CRUD operations on the database.
<br />

<p align="center">
<img src="./Diagrams/WEB-API-DB.jpeg" height="450" width="300">
<br />
    <b> Figure 1.1: Three Tier Architecture </b>  
</p>

<br /><br />
This Terraform template creates a Virtual Network with 3 subnets (Webserver, API, Database). Further, Network Security Group are created for each and Inbound, Outbound rules are added to their respective NSG.
For default values , you may refer to [`variables.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform_Disaster_Recovery/variables.tf) file.

Below is the Architectural Diagram for the primary VNet and subnets which are created and network security rules are applied to subnets using NSG.


![Azure](https://user-images.githubusercontent.com/24872414/61046464-d4de4a00-a3fa-11e9-8851-e9e19adfc128.jpg)
<br />
<p align="center">
    <b> Figure 1.2: Detailed Architectural Diagram for Primary VNet.</b>
</p>
Replica of the primary vnet with its subnets and NSGs are created at some secondary location which comes up as recovery solution in case of a disaster. Communication between these Vnets is established using global peering.


Rules of NSG for Database Subnet are appended opening custom ports on both Vnet, allowing database synchronization from between primary and secondary Databases.

So if Disaster occures, recovery can be made by backed up data from secondary to primary Database.<br />

Below is the architectural diagram for disaster recovery solution developed where a replica secondary vnet is created and peering is established between them

<p align="center">
<img src="./Diagrams/Architecture-DisasterRecovery.jpg">
<br />
    <b> Figure 1.3: Azure Architectural Diagram for Disaster Recovery Solution- Primary and Secondary Vnet. </b>
</p>
<br /><br />


## Installation and Usage
To deploy resources using terraform template follow the steps mentioned below:

<br />

<a href="https://shell.azure.com" target="_blank">
 <img name="launch-cloud-shell" src="https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/launchcloudshell.png" data-linktype="external">
</a>

<br />
<br/>

- Click on the Launch Cloud Shell button,login with Azure credentials and select Bash shell there to open Azure CLI.
- Upload [`vm.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vm-Deploy/vm.tf) to deploy resources on Azure using terraform.
- Upload [`variables.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vm-Deploy/variables.tf) . Default values are already present in this file. If you want to give your own values, you can change the values as per your requirement.  
- [`Configure Terraform`](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure) if you are using Azure CLI on your local machine.
- Use following Commands on Azure CLI for getting your subscription_id, client_id, client_secret,tenant_id to add in this template.
```bash
az account set --subscription="${SUBSCRIPTION_ID}"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```
```bash
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=your_subscription_id
export ARM_CLIENT_ID=your_appId
export ARM_CLIENT_SECRET=your_password
export ARM_TENANT_ID=your_tenant_id
export ARM_ENVIRONMENT=public
```
- Deploy your template using following commands:

    - ```terraform init ```
    - ```terraform plan ``` 
    - ```terraform apply```
## Update existing NSG Rule
In case of disaster, rules of NSG for Database Subnet are appended opening custom ports on both Vnet, allowing database synchronization from secondary to primary region.

This can be done by loading the [`powershell.ps1`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform_Disaster_Recovery/powershell.ps1) on the Azure powershell.

Change the values of Resource Group and NSG for database primary and secondary Subnet as per your existing resources , Upload the powershell script, ```cd``` to get into your home directory then run the powershell script.

So if Disaster occures, recovery can be made by backed up data from secondary to primary Database.
    
## License
This project is licensed under the  License - see the [`LICENSE.md`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/LICENSE) file for details
## Author
[`Riya Agrahari`](https://github.com/riyaagrahari/)<br />

