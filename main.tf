

module "resource-group" {
    source = "./modules/general/resourcegroup"
    resource_group_name = var.resource_group_name
    location = var.location
}   

module "network" {
   source="./modules/networking/vnet"
   resource_group_name = var.resource_group_name
   location = var.location
   network_security_group_rules = var.network_security_group_rules
   subnet_details = local.subnet_details
   virtual_network_details = local.virtual_network_details
   network_interface_details = local.network_interface_details
   depends_on = [ module.resource-group ]
}


module "virtual-machines" {    
    source="./modules/compute/virtualMachines"
    resource_group_name=var.resource_group_name
    location=var.location
    virtual_machine_details = local.virtual_machine_details
    network_interface_details = local.network_interface_details
    storage_account_name = module.storage-account.storage_account_name
    container_name = "scripts"
    depends_on = [ module.network,module.storage-account ]
}

module "storage-account" {
    source = "./modules/storage/azurestorage"
    resource_group_name = var.resource_group_name
    location = var.location
    storage_account_details = var.storage_account_details
    container_names = var.container_names
    blobs = var.blobs
    depends_on = [ module.resource-group ]
}

module "application-gateway"{
  source = "./modules/networking/applicationgateway"
  resource_group_name= var.resource_group_name
  location=var.location  
  application_gateway_details=var.application_gateway_details
  network_interface_details=local.network_interface_details
  application_pool_details = var.application_pool_details
  depends_on = [ module.virtual-machines ]
}
/*module "resource-group" {
    source = "./modules/general/resourcegroup"
    resource_group_name = var.resource_group_name
    location = var.resource_group_location
}*/


module "webapp-deployment" {
    source = "./modules/web"
#    resource_group_name = module.resource_group_name
    resource_group_name = var.resource_group_name
    location = var.location
    webapp_environment=var.webapp_environment
}


/*resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "vm-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id           = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# Add an output for the Bastion host
output "bastion_host_name" {
  value = azurerm_bastion_host.bastion.name
}*/