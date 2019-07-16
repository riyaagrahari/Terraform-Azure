resource "azurerm_resource_group" "deploy"{
    count                    = "${length(var.location)}"
    name                     = "${element(var.resource_group_name,count.index)}"
    location                 = "${element(var.location,count.index)}"
}

resource "azurerm_virtual_network" "deploy"{
    count                     = "${length(var.location)}"
    name                      = "${element(var.vnet_name,count.index)}"
    address_space             = ["${element(var.address_space,count.index)}"]
    location                  = "${element(var.location,count.index)}"
    resource_group_name       = "${element(var.resource_group_name,count.index)}"
    depends_on                = ["azurerm_resource_group.deploy","azurerm_network_security_group.deploy1","azurerm_network_security_group.deploy2","azurerm_network_security_group.deploy3"]
    subnet {
    name                      = "${element(var.subnet1_name,count.index)}"
    address_prefix            = "${element(var.subnet1-address,count.index)}"
    security_group            ="${element(azurerm_network_security_group.deploy1.*.id,count.index)}"
    }
    subnet {
    name                      = "${element(var.subnet2_name,count.index)}"
    address_prefix            = "${element(var.subnet2-address,count.index)}"
    security_group            ="${element(azurerm_network_security_group.deploy2.*.id,count.index)}"
    }
    subnet {
    name                      = "${element(var.subnet3_name,count.index)}"
    address_prefix            = "${element(var.subnet3-address,count.index)}"
    security_group            ="${element(azurerm_network_security_group.deploy3.*.id,count.index)}"
    }
    subnet {
    name                      = "${element(var.Management-JumpBox_Subnet_Name,count.index)}"
    address_prefix            = "${element(var.Management-JumpBox_Subnet_AddressPrefix,count.index)}"
    }
    subnet {
    //count                     = "${length(var.location)}"
    name                      = "AzureFirewallSubnet"
    address_prefix            = "${element(var.firewallSubnet-AddressPrefix-Vnet1,count.index)}"
    }
}

resource "azurerm_network_security_group" "deploy1"{
    count                     = "${length(var.location)}"
    name                       = "${element(var.NSG-name1,count.index)}"
    location                   = "${element(var.location,count.index)}"
    resource_group_name        = "${element(var.resource_group_name,count.index)}"
    depends_on                = ["azurerm_resource_group.deploy"]
    security_rule {
    name                       = "HTTPorHTTPS-request"
    protocol                   = "Tcp"
    source_address_prefix    = "*"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet1-address,count.index)}"
    destination_port_ranges    = ["80","443"]
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "SSHandRDP-to-WEB"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.Management-JumpBox_Subnet_AddressPrefix,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet1-address,count.index)}"
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefix    =  "${element(var.subnet2-address,count.index)}"
    source_port_range          = "8083"
    destination_address_prefix = "${element(var.subnet1-address,count.index)}"
    destination_port_range    = "8081"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "DenyOutBoundToDB"
    protocol                   = "Tcp"
    source_address_prefix    =  "${element(var.subnet1-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_range    = "*"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "Web-API-request"
    protocol                   = "Tcp"
    source_address_prefix    =  "${element(var.subnet1-address,count.index)}"
    source_port_range          = "8081"
    destination_address_prefix =  "${element(var.subnet2-address,count.index)}"
    destination_port_range    = "8083"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }

}
resource "azurerm_network_security_group" "deploy2"{
    count                    = "${length(var.location)}"
    name                       = "${element(var.NSG-name2,count.index)}"
    location                   = "${element(var.location,count.index)}"
    resource_group_name        = "${element(var.resource_group_name,count.index)}"
    depends_on                = ["azurerm_resource_group.deploy"]
    security_rule {
    name                       = "Web-request-API"
    protocol                   = "Tcp"
    source_address_prefix    =  "${element(var.subnet1-address,count.index)}"
    source_port_range          = "8081"
    destination_address_prefix = "${element(var.subnet2-address,count.index)}"
    destination_port_range    = "8083"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
security_rule {
    name                       = "SSHandRDP-to-API"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.Management-JumpBox_Subnet_AddressPrefix,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet2-address,count.index)}"
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "FTPfromDB-to-API"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet3-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix ="${element(var.subnet2-address,count.index)}"
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "API-MySQL-request"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet2-address,count.index)}"
    source_port_range          = "118"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
 security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet2-address,count.index)}"
    source_port_range          = "8083"
    destination_address_prefix = "${element(var.subnet1-address,count.index)}"
    destination_port_range    = "8081"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPtoDB"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet2-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Allow"  
  }
}
resource "azurerm_network_security_group" "deploy3"{
    count                    = "${length(var.location)}"
    name                       =  "${element(var.NSG-name3,count.index)}"
    location                   ="${element(var.location,count.index)}"
    resource_group_name        = "${element(var.resource_group_name, count.index)}"
    depends_on                = ["azurerm_resource_group.deploy"]
    security_rule {
    name                       = "API-DB-request"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet2-address,count.index)}"
    source_port_range          = "118"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
   security_rule {
    name                       = "DenyWeb-Database"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet1-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_range    = "*"
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "SSHandRDP-from-admin-to-db"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.Management-JumpBox_Subnet_AddressPrefix,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet3-address,count.index)}"
    destination_port_ranges    = ["22","3389"]
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromAPI-DB-Inbound"
    protocol                   = "Tcp"
    source_address_prefix    ="${element(var.subnet2-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix ="${element(var.subnet3-address,count.index)}"
    destination_port_range    = "21"
    priority                   =  130
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "MySQL-API--request"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet3-address,count.index)}"
    source_port_range          = "3306"
    destination_address_prefix = "${element(var.subnet2-address,count.index)}"
    destination_port_range    = "118"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromDB-API-Outbound"
    protocol                   = "Tcp"
    source_address_prefix   = "${element(var.subnet3-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix ="${element(var.subnet2-address,count.index)}"
    destination_port_range    = "21"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
   security_rule {
    name                       = "DenyConnectiontToWeb"
    protocol                   = "Tcp"
    source_address_prefix    = "${element(var.subnet3-address,count.index)}"
    source_port_range          = "*"
    destination_address_prefix = "${element(var.subnet1-address,count.index)}"
    destination_port_range    = "*"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Deny"  
  }
}


resource "azurerm_virtual_network_peering" "Peering1" {
    count                    = "${length(var.location)}"
    name                     = "Peering-to-${element(var.vnet_name, 1 - count.index)}"
    resource_group_name      = "${element(var.resource_group_name,count.index)}"
    virtual_network_name         = "${element(var.vnet_name,count.index)}"
    remote_virtual_network_id    = "${element(azurerm_virtual_network.deploy.*.id,1 - count.index)}"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit = false
    depends_on = ["azurerm_virtual_network.deploy"]
}
