resource "azurerm_resource_group" "deploy"{
    name                     = "${var.resource_group_name}"
    location                 = "${var.location}"
}
resource "azurerm_resource_group" "deploy-replica"{
    name                     = "${var.resource_group_name-replica}"
    location                 = "${var.location-replica}"
}
resource "azurerm_virtual_network" "deploy"{
    name                      = "${var.vnet_name}"
    address_space             = ["${var.address_space}"]
    location                  = "${azurerm_resource_group.deploy.location}"
    resource_group_name       = "${azurerm_resource_group.deploy.name}"
    
    subnet {
    name                      = "${var.subnet1_name}"
    address_prefix            = "${var.subnet1-address}"
    security_group            ="${azurerm_network_security_group.deploy1.id}"
    }
    subnet {
    name                      = "${var.subnet2_name}"
    address_prefix            = "${var.subnet2-address}"
    security_group            ="${azurerm_network_security_group.deploy2.id}"
    }
    subnet {
    name                      = "${var.subnet3_name}"
    address_prefix            = "${var.subnet3-address}"
    security_group            ="${azurerm_network_security_group.deploy3.id}"
    }
    subnet {
    name                      = "${var.Management-JumpBox_Subnet_Name}"
    address_prefix            = "${var.Management-JumpBox_Subnet_AddressPrefix}"
    }
    subnet {
    name                      = "AzureFirewallSubnet"
    address_prefix            = "${var.firewallSubnet-AddressPrefix-Vnet1}"
    }
}

resource "azurerm_virtual_network" "deploy-replica"{
    name                      = "${var.vnet_name-replica}"
    address_space             = ["${var.address_space-replica}"]
    location                  = "${azurerm_resource_group.deploy-replica.location}"
    resource_group_name       = "${azurerm_resource_group.deploy-replica.name}"
    
    subnet {
    name                      = "${var.subnet1_name-replica}"
    address_prefix            = "${var.subnet1-address-replica}"
    security_group            ="${azurerm_network_security_group.deploy4.id}"
    }
    subnet {
    name                      = "${var.subnet2_name-replica}"
    address_prefix            = "${var.subnet2-address-replica}"
    security_group            ="${azurerm_network_security_group.deploy5.id}"
    }
    subnet {
    name                      = "${var.subnet3_name-replica}"
    address_prefix            = "${var.subnet3-address-replica}"
    security_group            ="${azurerm_network_security_group.deploy6.id}"
    }
    subnet {
    name                      = "${var.Management-JumpBox_Subnet_Name-Replica}"
    address_prefix            = "${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"
    }
    subnet {
    name                      = "AzureFirewallSubnet"
    address_prefix            = "${var.firewallSubnet-AddressPrefix-Replica}"
    }
}
resource "azurerm_network_security_group" "deploy1"{
    name                       = "${var.NSG-name1}"
    location                   = "${azurerm_resource_group.deploy.location}"
    resource_group_name        = "${azurerm_resource_group.deploy.name}"
    security_rule {
    name                       = "HTTPorHTTPS-request"
    protocol                   = "Tcp"
    source_address_prefix    = "*"
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_ranges    = ["80","443"]
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "SSHandRDP-to-WEB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "8083"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "8081"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "DenyOutBoundToDB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "*"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "Web-API-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "8081"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "8083"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }

}
resource "azurerm_network_security_group" "deploy2"{
    name                       = "${var.NSG-name2}"
    location                   = "${azurerm_resource_group.deploy.location}"
    resource_group_name        = "${azurerm_resource_group.deploy.name}"
    security_rule {
    name                       = "Web-request-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "8081"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "8083"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
security_rule {
    name                       = "SSHandRDP-to-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "FTPfromDB-to-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "API-MySQL-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "118"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
 security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "8083"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "8081"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPtoDB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Allow"  
  }
}
resource "azurerm_network_security_group" "deploy3"{
    name                       = "${var.NSG-name2}"
    location                   = "${azurerm_resource_group.deploy.location}"
    resource_group_name        = "${azurerm_resource_group.deploy.name}"
    security_rule {
    name                       = "API-DB-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "118"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
   security_rule {
    name                       = "DenyWeb-Database"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "*"
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "SSHandRDP-from-admin-to-db"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromAPI-DB-Inbound"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "21"
    priority                   =  130
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "MySQL-API--request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "3306"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "118"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromDB-API-Outbound"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "21"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
   security_rule {
    name                       = "DenyConnectiontToWeb"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "*"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Deny"  
  }
}


// For replica Vnet
resource "azurerm_network_security_group" "deploy4"{
    name                       = "${var.NSG-name1-replica}"
    location                   = "${azurerm_resource_group.deploy-replica.location}"
    resource_group_name        = "${azurerm_resource_group.deploy-replica.name}"
    security_rule {
    name                       = "HTTPorHTTPS-request"
    protocol                   = "Tcp"
    source_address_prefix    = "*"
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_ranges    = ["80","443"]
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "SSHandRDP-to-WEB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "8083"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "8081"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "DenyOutBoundToDB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "*"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "Web-API-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "8081"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "8083"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }

}
resource "azurerm_network_security_group" "deploy5"{
    name                       = "${var.NSG-name2-replica}"
    location                   = "${azurerm_resource_group.deploy-replica.location}"
    resource_group_name        = "${azurerm_resource_group.deploy-replica.name}"
    security_rule {
    name                       = "Web-request-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "8081"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "8083"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
security_rule {
    name                       = "SSHandRDP-to-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "FTPfromDB-to-API"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "API-MySQL-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "118"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
 security_rule {
    name                       = "API-Web-response"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "8083"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "8081"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPtoDB"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "21"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Allow"  
  }
}
resource "azurerm_network_security_group" "deploy6"{
    name                       = "${var.NSG-name3-replica}"
    location                   = "${azurerm_resource_group.deploy-replica.location}"
    resource_group_name        = "${azurerm_resource_group.deploy-replica.name}"
    security_rule {
    name                       = "API-DB-request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "118"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "3306"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"  
  }
   security_rule {
    name                       = "DenyWeb-Database"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "*"
    priority                   =  110
    direction                  = "Inbound"
    access                     = "Deny"  
  }
  security_rule {
    name                       = "SSHandRDP-from-admin-to-db"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.Management-JumpBox_Subnet_AddressPrefix}","${var.Management-JumpBox_Subnet_AddressPrefix-Replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_ranges    = ["22","3389"]
    priority                   =  120
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromAPI-DB-Inbound"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    destination_port_range    = "21"
    priority                   =  130
    direction                  = "Inbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "MySQL-API--request"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "3306"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "118"
    priority                   =  100
    direction                  = "Outbound"
    access                     = "Allow"  
  }
    security_rule {
    name                       = "FTPfromDB-API-Outbound"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet2-address}","${var.subnet2-address-replica}"]
    destination_port_range    = "21"
    priority                   =  110
    direction                  = "Outbound"
    access                     = "Allow"  
  }
  security_rule {
    name                       = "DenyConnectiontToWeb"
    protocol                   = "Tcp"
    source_address_prefixes    = ["${var.subnet3-address}","${var.subnet3-address-replica}"]
    source_port_range          = "*"
    destination_address_prefixes = ["${var.subnet1-address}","${var.subnet1-address-replica}"]
    destination_port_range    = "*"
    priority                   =  120
    direction                  = "Outbound"
    access                     = "Deny"  
  }
}
resource "azurerm_virtual_network_peering" "Peering1" {
    name = "Peering1to2"
    resource_group_name       = "${azurerm_resource_group.deploy.name}"
    virtual_network_name         = "${var.vnet_name}"
    remote_virtual_network_id    = "${azurerm_virtual_network.deploy-replica.id}"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit = false
}
resource "azurerm_virtual_network_peering" "Peering2" {
    name = "Peering2to1"
    resource_group_name       = "${azurerm_resource_group.deploy-replica.name}"
    virtual_network_name         = "${var.vnet_name-replica}"
    remote_virtual_network_id    = "${azurerm_virtual_network.deploy.id}"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit = false
}

