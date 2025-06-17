module "network" {
  source  = "Azure/vnet/azurerm"
  version = "~> 4.1.0"

  resource_group_name = var.resource_group_name
  vnet_location = var.location
  use_for_each  = true
  vnet_name           = "${var.prefix}-vnet"
  address_space       = var.vnet_address_space

  subnet_names = [
    "public-subnet",
    "private-app-subnet",
    "AzureBastionSubnet",   
    "db-subnet",
    "redis-subnet"
  ]

  subnet_prefixes = [
    var.cidr_public,
    var.cidr_private,
    var.cidr_bastion,
    var.cidr_db,
    var.cidr_redis
  ]
}
