# Virtual Network with Subnet and NSG using.

Hashicorp Terraform is an Open source tool for provisioning and managing cloud infrastructure.This Terraform script creates a Virtual Network with Sub-Networks and Network Security Group associated to it. 
To deploy resources using this terraform template follow the steps mentioned below:
<br /><br />

<a href="https://shell.azure.com" target="_blank">
 <img name="launch-cloud-shell" src="https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/launchcloudshell.png" data-linktype="external">
</a>

<br />

- Click on the Launch Cloud Shell button,login with Azure credentials and select Bash shell there to open Azure CLI.
- Upload [`main.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vnet_Subnet_NSG/main.tf) to deploy resources on Azure using terraform. Values to the variable are asked at runtime on CLI ( upload [`variables.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vnet_Subnet_NSG/variables.tf) ). 
- [`Configure Terraform`](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure) if you are using Azure CLI on your local machine.
- Deploy your template using following commands:

    - ```terraform init ```
    - ```terraform plan ``` 
    - ```terraform apply```
