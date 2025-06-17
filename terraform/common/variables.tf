#####################
# Base
#####################
variable "prefix"              { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }

#####################
# Network
#####################
variable "vnet_address_space"  { type = list(string) }
variable "vnet_use_for_each" {
  type    = bool
  default = true      
}

variable "cidr_public"  { type = string }
variable "cidr_private" { type = string }
variable "cidr_bastion" { type = string }
variable "cidr_db"      { type = string }
variable "cidr_redis"   { type = string }

#####################
# VM
#####################
variable "admin_username" { type = string }
variable "ssh_public_key" {
  type      = string
  sensitive = true
}
variable "ubuntu_sku"    { type = string }
variable "proxy_vm_size" { type = string }
variable "app_vm_size"   { type = string }
variable "bastion_vm_size" { type = string }

#####################
# Ports
#####################
variable "proxy_allowed_ports" {
  type    = list(number)
  default = [80, 443]
}
variable "app_port" { type = number }
