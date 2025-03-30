# 📌 Azure Resource Group Configuration
variable "location" {
  description = "Azure region where the AKS cluster will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure resource group where the AKS cluster will be deployed."
  type        = string
}

# 📌 AKS Cluster Configuration
variable "cluster_name" {
  description = "The name of the Azure Kubernetes Service (AKS) cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
  default     = null
}

# 📌 AKS Identity Configuration
variable "identity_type" {
  description = "Type of identity for the AKS cluster (SystemAssigned or UserAssigned)."
  type        = string
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "Allowed values for identity_type are 'SystemAssigned' or 'UserAssigned'."
  }
}

variable "identity_ids" {
  description = "User Assigned Identity IDs if using UserAssigned identity type."
  type        = list(string)
  default     = []
}

# 📌 AKS Networking Configuration
variable "vnet_subnet_id" {
  description = "The subnet ID where AKS nodes will be deployed."
  type        = string
}

# 📌 AKS Node Pool Configuration
variable "node_pools" {
  description = "Map of AKS node pools."
  type = map(object({
    name                          = string
    vm_size                       = string
    min_count                     = number
    max_count                     = number
    node_count                    = number
    vnet_subnet_id                = string
    enable_auto_scaling           = bool
    orchestrator_version          = string
    mode                          = string
    os_disk_size_gb               = number
    os_type                       = string
    os_sku                        = string
    priority                      = string
    eviction_policy               = string
    node_labels                   = map(string)
    node_taints                   = list(string)
    max_pods                      = number
    zones                         = list(string)
    scale_down_mode               = string
    workload_runtime              = string
    create_before_destroy         = bool
  }))
  default = {}
}

# 📌 Log Analytics Configuration
variable "log_analytics_workspace_enabled" {
  description = "Enable or disable Log Analytics Workspace integration."
  type        = bool
  default     = true
}

variable "log_analytics_workspace" {
  description = "Existing Log Analytics Workspace object if available."
  type = object({
    id       = string
    name     = string
    location = string
  })
  default = null
}

# 📌 ACR Integration (Azure Container Registry)
variable "attached_acr_id_map" {
  description = "Map of Azure Container Registry (ACR) IDs to attach to AKS."
  type        = map(string)
  default     = {}
}

# 📌 Role Assignments
variable "create_role_assignment_network_contributor" {
  description = "Whether to assign the Network Contributor role to the cluster identity."
  type        = bool
  default     = false
}

variable "network_contributor_role_assigned_subnet_ids" {
  description = "List of subnet IDs for which the Network Contributor role should be assigned."
  type        = map(string)
  default     = {}
}

# 📌 Auto-scaler Configuration
variable "auto_scaler_profile_scan_interval" {
  description = "Interval at which the autoscaler scans for nodes that can be removed."
  type        = string
  default     = "10s"
}

variable "auto_scaler_profile_scale_down_delay_after_delete" {
  description = "Time delay before a node is removed after deletion."
  type        = string
  default     = null
}

# 📌 Private DNS Zone Configuration
variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone used for private cluster mode."
  type        = string
  default     = null
}

# 📌 Application Gateway for Ingress
variable "brown_field_application_gateway_for_ingress" {
  description = "Existing Application Gateway for AKS Ingress (if available)."
  type = object({
    id        = string
    subnet_id = string
  })
  default = null
}

variable "green_field_application_gateway_for_ingress" {
  description = "Whether to deploy a new Application Gateway for AKS Ingress."
  type        = bool
  default     = false
}

# 📌 Automatic Channel Upgrade
variable "automatic_channel_upgrade" {
  description = "The automatic upgrade channel for the cluster (patch, rapid, stable, node-image)."
  type        = string
  default     = null
}

# 📌 Client Credentials for Service Principal Authentication
variable "client_id" {
  description = "Client ID for Azure Service Principal authentication."
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Client Secret for Azure Service Principal authentication."
  type        = string
  default     = ""
}
