resource "azurerm_resource_group" "test" {
    name     = "RG-01"
    location = "West US"
  }
  
  resource "azurerm_template_deployment" "test" {
    name                = "template-01"
    resource_group_name = "${azurerm_resource_group.test.name}"
    template_body = "${file("./Master.json")}"

parameters = {
	"Location-of-Virtual_Network1"  			= "West US",
	"NSG1-name" 				    			= "NSG-1-web",
	"NSG2-name" 								= "NSG-1-api",
	"NSG3-name" 								= "NSG-1-db",
	"NSG1-name-replica" 						= "NSG-1-web-replica",
	"NSG2-name-replica" 						= "NSG-1-api-replica",
	"NSG3-name-replica" 						= "NSG-1-db-replica",
	"Virtual_Network1-name" 					= "Vnet-1",
	"Vnet1addressPrefix"						= "10.0.0.0/16",
	"subnet1-name"								= "subnet-1",
	"subnet1-AddressPrefix" 					= "10.0.1.0/24",
	"subnet2-name"								= "subnet-2",
	"subnet2-AddressPrefix"						= "10.0.2.0/24",
	"subnet3-name"								= "subnet-3",	
	"subnet3-AddressPrefix"						= "10.0.3.0/24",	
	"firewallSubnet-AddressPrefix-Vnet1"		= "10.0.4.0/24",
	"Management-JumpBox_Subnet_Name"			= "admin",	
	"Management-JumpBox_Subnet_AddressPrefix"	= "10.0.5.0/24",	
	"Virtual_Network2-name"						= "Vnet-2",
	"Vnet2addressPrefix"						= "20.0.0.0/16",
	"Location-of-Virtual_Network2"  			= "East US",	
	"subnet1-Name-Vnet2"						= "subnet-1-replica",
	"subnet1-AddressPrefix-Vnet2"				= "20.0.1.0/24",
	"subnet2-Name-Vnet2"						= "subnet-2-replica",
	"subnet2-AddressPrefix-Vnet2"				= "20.0.2.0/24",	
	"subnet3-Name-Vnet2"						= "subnet-3-replica",	
	"subnet3-AddressPrefix-Vnet2"				= "20.0.3.0/24",
	"firewallSubnet-AddressPrefix-Vnet2" 		= "20.0.4.0/24",
	"Management-JumpBox_Subnet_Name-Vnet2"		= "admin-replica",	
	"Management-JumpBox_Subnet_AddressPrefix-Vnet2" = "20.0.5.0/24",
	//"enableDdosProtection" 						= false,
	//"virtual-Network-Access"					=true,
	//"forwarded-Traffic"							=null,
	//"gateway-Transit"							=null,
	//"remoteGateways"							=null,
	}
 deployment_mode = "Incremental"
  } 