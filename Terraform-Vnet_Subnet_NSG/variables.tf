variable "vnet_name" {
    description = "Name of first Vnet"
    default     = "first-vnet"
}
variable "resource_group_name" {
    description = "Name of resource group"
    default     = "first-rg"
}
variable "location" {
    description = "Location for all resources to be deployed"
}
variable "address_space" {
    description = "Asddress space  of virtual network 1"
    default     = "10.0.0.0/16"
}
variable "subnet1_name" {
    description = "Name of subnet 1"
    default     = "subnet1"
}
variable "subnet1-address" {
    description = "Address prefix of subnet1"
    default     = "10.0.1.0/24"
}
variable "NSG-name1" {
    description = "Name of first NSG"
    default     = "NSG1"
}





