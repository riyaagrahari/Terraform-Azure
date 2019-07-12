# Deploy a Linux Virtual Machine with Public ip, storage account and Vnet with Terraform.

Hashicorp Terraform is an Open source tool for provisioning and managing cloud infrastructure. 
To deploy resources using this terraform template follow the steps mentioned below:

<br />

<a href="https://shell.azure.com" target="_blank">
 <img name="launch-cloud-shell" src="https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/launchcloudshell.png" data-linktype="external">
</a>

<br />
<br/>

- Click on the Launch Cloud Shell button,login with Azure credentials and select Bash shell there to open Azure CLI.
- Upload [`vm.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vm-Deploy/vm.tf) to deploy resources on Azure using terraform. Values to the variable are asked at runtime on CLI.( upload [`variables.tf`](https://github.com/riyaagrahari/Terraform-Azure/blob/master/Terraform-Vm-Deploy/variables.tf) ) 
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
