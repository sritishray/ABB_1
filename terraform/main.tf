terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# Existing Resource Group
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# Existing Virtual Network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Existing Subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Calling AKS Module
module "aks" {
  source              = "../modules/aks"   
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  vnet_subnet_id      = data.azurerm_subnet.existing_subnet.id
  identity_type       = var.identity_type
  identity_ids        = var.identity_ids
}

# Calling Log Analytics Module
module "monitoring" {
  source                          = "../modules/monitoring"  #
  resource_group_name             = data.azurerm_resource_group.existing_rg.name
  log_analytics_workspace_enabled = var.log_analytics_workspace_enabled
}

# Calling Role Assignment Module
module "role_assignments" {
  source              = "../modules/role_assignments"  
  attached_acr_id_map = var.attached_acr_id_map
}

# Calling User Pool Module
module "user_pool" {
  source              = "../modules/user_pool"  
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
}
