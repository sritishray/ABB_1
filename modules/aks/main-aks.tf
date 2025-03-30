
resource "azurerm_kubernetes_cluster" "main" {
  location                            = var.location
  name                                = "${local.cluster_name}${var.cluster_name_random_suffix ? substr(md5(uuid()), 0, 4) : ""}"
  resource_group_name                 = var.resource_group_name
  azure_policy_enabled                = var.azure_policy_enabled
  cost_analysis_enabled               = var.cost_analysis_enabled
  disk_encryption_set_id              = var.disk_encryption_set_id
  dns_prefix                          = var.prefix
  dns_prefix_private_cluster          = var.dns_prefix_private_cluster
  image_cleaner_enabled               = var.image_cleaner_enabled
  image_cleaner_interval_hours        = var.image_cleaner_interval_hours
  kubernetes_version                  = var.kubernetes_version
  local_account_disabled              = var.local_account_disabled
  node_resource_group                 = var.node_resource_group
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  open_service_mesh_enabled           = var.open_service_mesh_enabled
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = var.private_dns_zone_id
  role_based_access_control_enabled   = var.role_based_access_control_enabled
  run_command_enabled                 = var.run_command_enabled
  sku_tier                            = var.sku_tier
  support_plan                        = var.support_plan

  workload_identity_enabled = var.workload_identity_enabled

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]

    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      fips_enabled                 = var.default_node_pool_fips_enabled
      max_count                    = null
      max_pods                     = var.agents_max_pods
      min_count                    = null
      node_count                   = var.agents_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      proximity_placement_group_id = var.agents_proximity_placement_group_id
      scale_down_mode              = var.scale_down_mode
      snapshot_id                  = var.snapshot_id
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones

    }
  }
  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []

    content {
      name                         = var.agents_pool_name
      vm_size                      = var.agents_size
      enable_auto_scaling          = var.enable_auto_scaling
      enable_host_encryption       = var.enable_host_encryption
      enable_node_public_ip        = var.enable_node_public_ip
      fips_enabled                 = var.default_node_pool_fips_enabled
      max_count                    = var.agents_max_count
      max_pods                     = var.agents_max_pods
      min_count                    = var.agents_min_count
      node_labels                  = var.agents_labels
      node_taints                  = var.agents_taints
      only_critical_addons_enabled = var.only_critical_addons_enabled
      orchestrator_version         = var.orchestrator_version
      os_disk_size_gb              = var.os_disk_size_gb
      os_disk_type                 = var.os_disk_type
      os_sku                       = var.os_sku
      pod_subnet_id                = var.pod_subnet_id
      proximity_placement_group_id = var.agents_proximity_placement_group_id
      scale_down_mode              = var.scale_down_mode
      snapshot_id                  = var.snapshot_id
      tags                         = merge(var.tags, var.agents_tags)
      temporary_name_for_rotation  = var.temporary_name_for_rotation
      type                         = var.agents_type
      ultra_ssd_enabled            = var.ultra_ssd_enabled
      vnet_subnet_id               = var.vnet_subnet_id
      zones                        = var.agents_availability_zones

      }
    }
  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender_enabled ? ["microsoft_defender"] : []

    content {
      log_analytics_workspace_id = local.log_analytics_workspace.id
    }
  }
  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics != null ? ["monitor_metrics"] : []

    content {
      annotations_allowed = var.monitor_metrics.annotations_allowed
      labels_allowed      = var.monitor_metrics.labels_allowed
    }
  }
  network_profile {
    network_plugin      = var.network_plugin
    dns_service_ip      = var.net_profile_dns_service_ip
    ebpf_data_plane     = var.ebpf_data_plane
    ip_versions         = var.network_ip_versions
    load_balancer_sku   = var.load_balancer_sku
    network_data_plane  = var.network_data_plane
    network_mode        = var.network_mode
    network_plugin_mode = var.network_plugin_mode
    network_policy      = var.network_policy
    outbound_type       = var.net_profile_outbound_type
    pod_cidr            = var.net_profile_pod_cidr
    pod_cidrs           = var.net_profile_pod_cidrs
    service_cidr        = var.net_profile_service_cidr
    service_cidrs       = var.net_profile_service_cidrs

    dynamic "load_balancer_profile" {
      for_each = var.load_balancer_profile_enabled && var.load_balancer_sku == "standard" ? [
        "load_balancer_profile"
      ] : []

      content {
        idle_timeout_in_minutes     = var.load_balancer_profile_idle_timeout_in_minutes
        managed_outbound_ip_count   = var.load_balancer_profile_managed_outbound_ip_count
        managed_outbound_ipv6_count = var.load_balancer_profile_managed_outbound_ipv6_count
        outbound_ip_address_ids     = var.load_balancer_profile_outbound_ip_address_ids
        outbound_ip_prefix_ids      = var.load_balancer_profile_outbound_ip_prefix_ids
        outbound_ports_allocated    = var.load_balancer_profile_outbound_ports_allocated
      }
    }
    dynamic "nat_gateway_profile" {
      for_each = var.nat_gateway_profile == null ? [] : [var.nat_gateway_profile]

      content {
        idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
        managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
      }
    }
  dynamic "oms_agent" {
    for_each = (var.log_analytics_workspace_enabled && var.oms_agent_enabled) ? ["oms_agent"] : []

    content {
      log_analytics_workspace_id      = local.log_analytics_workspace.id
      msi_auth_for_monitoring_enabled = var.msi_auth_for_monitoring_enabled
    }
  }
  dynamic "service_mesh_profile" {
    for_each = var.service_mesh_profile == null ? [] : ["service_mesh_profile"]

    content {
      mode                             = var.service_mesh_profile.mode
      external_ingress_gateway_enabled = var.service_mesh_profile.external_ingress_gateway_enabled
      internal_ingress_gateway_enabled = var.service_mesh_profile.internal_ingress_gateway_enabled
    }
  }
  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []

    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }
  dynamic "storage_profile" {
    for_each = var.storage_profile_enabled ? ["storage_profile"] : []

    content {
      blob_driver_enabled         = var.storage_profile_blob_driver_enabled
      disk_driver_enabled         = var.storage_profile_disk_driver_enabled
      disk_driver_version         = var.storage_profile_disk_driver_version
      file_driver_enabled         = var.storage_profile_file_driver_enabled
      snapshot_controller_enabled = var.storage_profile_snapshot_controller_enabled
    }
  }
}


