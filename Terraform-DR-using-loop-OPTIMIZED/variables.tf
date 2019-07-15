
variable "resource_group_name" {
    description = "Name of resource groups"
     default     = ["RG1","RG1-replica",]
}
variable "location" {
    description = "Location for all resources to be deployed"
    default = ["westus","eastus",]
}

variable "vnet_name" {
    description = "Name of Primary Vnet"
     default     = ["first-vnet","first-vnet-replica",]
}
variable "address_space" {
    description = "Address space  of virtual network 1"
     default     = ["10.0.0.0/16","20.0.0.0/16",]
}
variable "subnet1_name" {
    description = "Name of subnet 1"
     default     = ["subnet1","subnet1-replica",]
}
variable "subnet1-address" {
    description = "Address prefix of subnet1"
     default     = ["10.0.1.0/24","20.0.1.0/24",]
}
variable "subnet2_name" {
    description = "Name of subnet 2"
    default     = ["subnet2","subnet2-replica",]
}
variable "subnet2-address" {
    description = "Address prefix of subnet2"
    default     = ["10.0.2.0/24","20.0.2.0/24",]
}
variable "subnet3_name" {
    description = "Name of subnet 3"
    default     = ["subnet3","subnet3-replica",]
}
variable "subnet3-address" {
    description = "Address prefix of subnet3"
    default     = ["10.0.3.0/24","20.0.3.0/24",]
}
variable "Management-JumpBox_Subnet_Name" {
    description = "Name of Management-Jumpbox"
    default = ["admin-1","admin1-replica",]
}
variable "Management-JumpBox_Subnet_AddressPrefix" {
	description = "Address range for jumbox subnet of Vnet1"
    default = ["10.0.5.0/24","20.0.5.0/24",]
}
variable "firewallSubnet-AddressPrefix-Vnet1" {
	description= "Address range for firewall subnet of Vnet1"
    default = ["10.0.4.0/24","20.0.4.0/24"]
}
variable "NSG-name1" {
    description = "Name of first NSG"
    default     = ["NSG1","NSG1-replica"]
}
variable "NSG-name2" {
    description = "Name of second NSG"
    default     = ["NSG2","NSG2-replica"]
}
variable "NSG-name3" {
    description = "Name of third NSG"
    default     = ["NSG3","NSG3-replica"]
}
variable "enableDdosProtection" {
    description= "Allow Ddos Protection or not"
    default = false
}
variable "virtual-Network-Access" {
	description= "Allow access to the virtual networks."
    default = true
}
variable "forwarded-Traffic" {
	description= "Allow traffic forwarded by a network virtual appliance in a virtual network"
    default = false
}
variable "gateway-Transit" {
	description= "If there is a virtual network gateway assosciated with the vnet or not"
     default = false
}
variable "remoteGateways" {
	description= "To allow traffic from Virtual_Network1-name to Vnet2 through the gateway of Vnet2"
    default = false
}	




