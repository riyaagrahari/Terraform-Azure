resource "azurerm_resource_group" "test" {
    name     = "RG-DR-DEPLOY"
    location = "West US"
  }
  
  resource "azurerm_template_deployment" "test" {
    name                = "template-01"
    resource_group_name = "${azurerm_resource_group.test.name}"
    template_body = "${file("./Master.json")}"

parameters = {
	"Location-of-Virtual_Network1"  			= "West US",
	"NSG1_name" 				    			= "NSG-1-web",
	"NSG2_name" 								= "NSG-1-api",
	"NSG3_name" 								= "NSG-1-db",
	"NSG1_name_replica" 						= "NSG-1-web-replica",
	"NSG2_name_replica" 						= "NSG-1-api-replica",
	"NSG3_name_replica" 						= "NSG-1-db-replica",
	"Virtual_Network1_name" 					= "Vnet-1",
	"Vnet1_address_Prefix"						= "10.0.0.0/16",
	"subnet1_name"								= "subnet-1",
	"subnet1_Address_Prefix" 					= "10.0.1.0/24",
	"subnet2_name"								= "subnet-2",
	"subnet2_Address_Prefix"						= "10.0.2.0/24",
	"subnet3_name"								= "subnet-3",	
	"subnet3_Address_Prefix"						= "10.0.3.0/24",	
	"firewallSubnet_AddressPrefix_Vnet1"		= "10.0.4.0/24",
	"Management_JumpBox_Subnet_Name"			= "admin",	
	"Management_JumpBox_Subnet_AddressPrefix"	= "10.0.5.0/24",	
	"Virtual_Network2_name"						= "Vnet-2",
	"Vnet2_address_Prefix"						= "20.0.0.0/16",
	"Location_of_Virtual_Network2"  			= "East US",	
	"subnet1_name_Vnet2"						= "subnet-1-replica",
	"subnet1_Address_Prefix_Vnet2"				= "20.0.1.0/24",
	"subnet2_name_Vnet2"						= "subnet-2-replica",
	"subnet2_Address_Prefix_Vnet2"				= "20.0.2.0/24",	
	"subnet3_name_Vnet2"						= "subnet-3-replica",	
	"subnet3_Address_Prefix_Vnet2"				= "20.0.3.0/24",
	"firewallSubnet_AddressPrefix_Vnet2" 		= "20.0.4.0/24",
	"Management_JumpBox_Subnet_Name_Vnet2"		= "admin-replica",	
	"Management_JumpBox_Subnet_AddressPrefix_Vnet2" = "20.0.5.0/24",
	//"enableDdosProtection" 						= false,
	//"virtual_Network_Access"					=true,
	//"forwarded_Traffic"							=null,
	//"gateway-Transit"							=null,
	//"remoteGateways"							=null,
	}
 deployment_mode = "Incremental"
  } 
