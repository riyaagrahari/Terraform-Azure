# Terraform template to create Virtual Network, Subnet and assign NSG rules to it.
To deploy the terraform template follow the steps mentioned below:
<br />
<a href="https://shell.azure.com" target="_blank">
 <img name="launch-cloud-shell" src="https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/launchcloudshell.png" data-linktype="external">
</a>
</br>

Terraform can be used for deploying ARM templates. 
- Click on the Launch Cloud Shell button,login with Azure credentials and select Bash shell there to open Azure CLI.
- Upload Master.tf to deploy resources on Azure using terraform. At the end of this file, there is a parameter section, you can change the values to your desired parameter values. 
- Upload Master.json ARM template so that Terraform can perform operation using it. 
- Configure Terraform [`configuring Terraform`](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure) if you are using Azure CLI on your local machine.
- Deploy your template using following commands:

    - ```terraform init ```
    - ```terraform plan ``` 
    - ```terraform apply```
