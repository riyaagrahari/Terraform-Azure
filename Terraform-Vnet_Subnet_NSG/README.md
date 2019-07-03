# Terraform template to create Virtual Network, Subnet and assign NSG rules to it.

Hashicorp Terraform is an Open source tool for provisioning and managing cloud infrastructure. 
To deploy resources using this terraform template follow the steps mentioned below:
<br /><br />

<a href="https://shell.azure.com" target="_blank">
 <img name="launch-cloud-shell" src="https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/launchcloudshell.png" data-linktype="external">
</a>

<br />

- Click on the Launch Cloud Shell button,login with Azure credentials and select Bash shell there to open Azure CLI.
- Upload main.tf to deploy resources on Azure using terraform. Values to the variable are asked at runtime on CLI. 
- [`Configure Terraform`](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure) if you are using Azure CLI on your local machine.
- Deploy your template using following commands:

    - ```terraform init ```
    - ```terraform plan ``` 
    - ```terraform apply```
