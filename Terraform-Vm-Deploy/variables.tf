variable "vnet_name" {
    description = "Name of first Vnet"
    //default     = "first-vnet"
}
variable "resource_group_name" {
    description = "Name of resource group"
    //default     = "first-rg"
}
variable "location" {
    description = "Location for all resources to be deployed"
}
variable "address_space" {
    description = "Address space  of virtual network 1"
    //default     = "10.0.0.0/16"
}
variable "subnet1_name" {
    description = "Name of subnet 1"
    //default     = "subnet1"
}
variable "subnet1-address" {
    description = "Address prefix of subnet1"
    //default     = "10.0.1.0/24"
}
variable "NSG-name1" {
    description = "Name of first NSG"
    //default     = "NSG1"
}
variable "NIC-name1" {
    description = "Name of first NIC"
    //default     = "NIC1-Azure"
}
variable "Storage-name1" {
    description = "Name of first storage account"
    //default     = "storage072928"
}
variable "vm_name" {
    description = "Name of VM"
    //default     = "VM-1"
}
variable "user_name" {
    description = "Name of user"
    //default     = "AdminAzure"
}
variable "user_password" {
    description = "Password of user"
    //default     = "Pass!1234"
}




