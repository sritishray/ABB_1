#  Azure Resource Group Configuration
location               = "Central India"
resource_group_name    = "aks-rg"

#  AKS Cluster Configuration
cluster_name           = "my-aks-cluster"
kubernetes_version     = "1.28.0"

#  AKS Identity Configuration
identity_type          = "SystemAssigned"
identity_ids           = []

#  AKS Networking Configuration
vnet_subnet_id         = "/subscriptions/855d587d-e8e0-4770-8b81-de2c3f9328ea/resourceGroups/aks-rg/providers/Microsoft.Network/virtualNetworks/aks-vnet/subnets/default"

#  AKS Node Pool Configuration
node_pools = {
  default = {
    name                  = "agentpool"
    vm_size               = "Standard_D2s_v3"
    min_count             = 1
    max_count             = 2
    node_count            = 1
    vnet_subnet_id        = "/subscriptions/855d587d-e8e0-4770-8b81-de2c3f9328ea/resourceGroups/aks-rg/providers/Microsoft.Network/virtualNetworks/aks-vnet/subnets/default"
    enable_auto_scaling   = true
    orchestrator_version  = "1.28.0"
    mode                  = "System"
    os_disk_size_gb       = 10
    os_type               = "Linux"
    os_sku                = "Ubuntu"
    priority              = "Regular"
    eviction_policy       = "Delete"
    node_labels           = { "role" = "worker" }
    node_taints           = []
    max_pods              = 2
    zones                 = ["1", "2", "3"]
    scale_down_mode       = "Delete"
    workload_runtime      = "OCIContainer"
    create_before_destroy = true
  }
}

#  Log Analytics Configuration
log_analytics_workspace_enabled = true
log_analytics_workspace = {
  id       = "/subscriptions/xxxxx/resourceGroups/my-rg/providers/Microsoft.OperationalInsights/workspaces/my-loganalytics"
  name     = "my-loganalytics"
  location = "eastus"
}

#  ACR Integration (Azure Container Registry)
attached_acr_id_map = {
  acr1 = "/subscriptions/xxxxx/resourceGroups/my-rg/providers/Microsoft.ContainerRegistry/registries/myacr"
}

#  Role Assignments
create_role_assignment_network_contributor = false
network_contributor_role_assigned_subnet_ids = {}

#  Auto-scaler Configuration
auto_scaler_profile_scan_interval = "10s"
auto_scaler_profile_scale_down_delay_after_delete = "10m"

#  Private DNS Zone Configuration
private_dns_zone_id = null

#  Application Gateway for Ingress
brown_field_application_gateway_for_ingress = {
  id        = "/subscriptions/xxxxx/resourceGroups/my-rg/providers/Microsoft.Network/applicationGateways/my-appgw"
  subnet_id = "/subscriptions/xxxxx/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-appgw-subnet"
}
green_field_application_gateway_for_ingress = false

#  Automatic Channel Upgrade
automatic_channel_upgrade = "patch"

#  Client Credentials for Service Principal Authentication (if needed)
client_id     = ""
client_secret = ""
