resource "azurerm_virtual_network" "virtual_network" {
for_each = {for network in var.virtual_network_details:network.virtual_network_name=>network}
   name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [each.value.virtual_network_address_space]
}

resource "azurerm_subnet" "network_subnets" {
  for_each = {for subnet in var.subnet_details:subnet.subnet_name=>subnet}  
  name                 = "${each.key}subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = [each.value.subnet_address_prefix]
}

resource "azurerm_network_interface" "network_interfaces" {
  for_each = {for networkinterface in var.network_interface_details:networkinterface.network_interface_name=>networkinterface}
   name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network_subnets[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
    
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  for_each = {for subnet in var.subnet_details:subnet.subnet_name=>subnet}
  name                = "${each.key}_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  
  dynamic security_rule {
    for_each = toset(var.network_security_group_rules)
    content {
    name                       = "Allow-${security_rule.value.destination_port_range}"
    priority                   =  security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  }

  
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = {for subnet in var.subnet_details:subnet.subnet_name=>subnet}
  subnet_id                 = azurerm_subnet.network_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[each.key].id
}
