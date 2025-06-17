locals {
  image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "20_04-lts"
    version   = "latest"
  }
}


module "vm_proxy" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  name                = "${var.prefix}-proxy"
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id          = module.network.vnet_subnets[0] 
  allocate_public_ip = true
  admin_username     = var.admin_username
  ssh_public_key     = var.ssh_public_key

  vm_size = var.proxy_vm_size
  image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.ubuntu_sku
    version   = "latest"
  }

  nsg_id = module.nsg_public.network_security_group_id
}


module "vm_backend" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  name                = "${var.prefix}-backend"
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id           = module.network.vnet_subnets[1] 
  allocate_public_ip  = false
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  vm_size             = "Standard_B1s"
  image               = local.image
  nsg_id              = module.nsg_private.network_security_group_id
}


module "vm_frontend" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  name                = "${var.prefix}-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id           = module.network.vnet_subnets[1]  
  allocate_public_ip  = false
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  vm_size             = "Standard_B1s"
  image               = local.image
  nsg_id              = module.nsg_private.network_security_group_id
}


module "vm_bastion" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  name                = "${var.prefix}-bastion-vm"
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id           = module.network.vnet_subnets[2]  
  allocate_public_ip  = false   
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  vm_size             = "Standard_B1ms"
  image               = local.image
  nsg_id              = module.nsg_private.network_security_group_id
}
