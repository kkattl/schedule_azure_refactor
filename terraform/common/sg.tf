module "nsg_public" {
  source  = "Azure/network-security-group/azurerm"
  version = "~> 4.0"

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.prefix}-public-nsg"

  custom_rules = [
    for idx, port in var.proxy_allowed_ports : {
      name                       = "Allow-${port}"
      priority                   = 100 + idx
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      destination_port_range     = port
    }
  ]
}
