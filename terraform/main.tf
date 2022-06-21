provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "mystorage198570"
    container_name       = "blob198570"
    key                  = "terraform.tfstate"
    access_key           = "n+DZutLZ0e8AyktJyHgEMTjBW6axQ+FI+Y7LLAOXtxD/ri2O5sZ3jCi1xKQJrr1wKS9UwjUXTpud+AStYCGDRg=="
  }
}
# module "resource_group" {
#   source               = "./modules/resource_group"
#   resource_group       = "${var.resource_group}"
#   location             = "${var.location}"
# }
module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  # resource_group       = "${module.resource_group.resource_group_name}"
  resource_group       = var.resource_group
  address_prefix_test  = "${var.address_prefix_test}"
  address_prefixes_test = "${var.address_prefixes_test}"
}

module "nsg-test" {
  source           = "./modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  # resource_group       = "${module.resource_group.resource_group_name}"
  resource_group       = var.resource_group
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "./modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  # resource_group       = "${module.resource_group.resource_group_name}"
  resource_group       = var.resource_group
}
module "publicip" {
  source           = "./modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  # resource_group       = "${module.resource_group.resource_group_name}"
  resource_group       = var.resource_group
}

module "vmlinux" {
  source           = "./modules/vm"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "VMLinux"
  # resource_group       = "${module.resource_group.resource_group_name}"
  resource_group       = var.resource_group
  admin_username   = "admin1ryanhart"
  subnet_id        = "${module.network.subnet_id_test}"
  public_ip_address = "${module.publicip.public_ip_address_id}"
}