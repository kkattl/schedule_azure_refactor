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

  vm_hostname         = "${var.prefix}-proxy"
  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_subnet_id      = module.network.vnet_subnets[0]
  public_ip_dns       = "${var.prefix}-proxy"
  admin_username      = var.admin_username
  admin_ssh_public_key = var.ssh_public_key

  vm_size = var.proxy_vm_size
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.ubuntu_sku
    version   = "latest"
  }

  nsg_ids = [module.nsg_public.network_security_group_id]
}


module "vm_backend" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  vm_hostname         = "${var.prefix}-backend"
  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_subnet_id      = module.network.vnet_subnets[1]
  public_ip_dns       = null
  admin_username      = var.admin_username
  admin_ssh_public_key = var.ssh_public_key
  vm_size             = "Standard_B1s"
  source_image_reference = local.image
  nsg_ids             = [module.nsg_private.network_security_group_id]
}


module "vm_frontend" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  vm_hostname         = "${var.prefix}-frontend"
  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_subnet_id      = module.network.vnet_subnets[1]
  public_ip_dns       = null
  admin_username      = var.admin_username
  admin_ssh_public_key = var.ssh_public_key
  vm_size             = "Standard_B1s"
  source_image_reference = local.image
  nsg_ids             = [module.nsg_private.network_security_group_id]
}


module "vm_bastion" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "~> 2.3.0"

  vm_hostname         = "${var.prefix}-bastion-vm"
  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_subnet_id      = module.network.vnet_subnets[2]
  public_ip_dns       = null
  admin_username      = var.admin_username
  admin_ssh_public_key = var.ssh_public_key
  vm_size             = "Standard_B1ms"
  source_image_reference = local.image
  nsg_ids             = [module.nsg_private.network_security_group_id]
}
