resource "azurerm_resource_group" "deploy"{
    name                     = "${var.resource_group_name}"
    location                 = "${var.location}"
}
resource "azurerm_virtual_network" "deploy"{
    name                      = "${var.vnet_name}"
    address_space             = ["${var.address_space}"]
    location                  = "${azurerm_resource_group.deploy.location}"
    resource_group_name       = "${azurerm_resource_group.deploy.name}"
}
resource "azurerm_subnet" "deploy"{
    name                      = "${var.subnet1_name}"
    resource_group_name       = "${azurerm_resource_group.deploy.name}"
    virtual_network_name      = "${azurerm_virtual_network.deploy.name}"
    address_prefix            = "${var.subnet1-address}"
    network_security_group_id = "${azurerm_network_security_group.deploy.id}"
}
resource "azurerm_network_security_group" "deploy"{
    name                       = "${var.NSG-name1}"
    location                   = "${azurerm_resource_group.deploy.location}"
    resource_group_name        = "${azurerm_resource_group.deploy.name}"
    security_rule {
    name                       = "Rule1"
    priority                  =  100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
}

resource "azurerm_subnet_network_security_group_association" "deploy" {
    subnet_id                   = "${azurerm_subnet.deploy.id}"
    network_security_group_id   = "${azurerm_network_security_group.deploy.id}" 
}