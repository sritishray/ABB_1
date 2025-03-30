resource "azurerm_kubernetes_cluster_node_pool" "node_pool_create_before_destroy" {
  for_each = local.node_pools_create_before_destroy

  kubernetes_cluster_id         = azurerm_kubernetes_cluster.main.id
  name                          = "${each.value.name}${substr(md5(uuid()), 0, 4)}"
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  eviction_policy               = each.value.eviction_policy
  fips_enabled                  = each.value.fips_enabled
  gpu_instance                  = each.value.gpu_instance
  host_group_id                 = each.value.host_group_id
  kubelet_disk_type             = each.value.kubelet_disk_type
  max_count                     = each.value.max_count
  max_pods                      = each.value.max_pods
  min_count                     = each.value.min_count
  mode                          = each.value.mode
  node_count                    = each.value.node_count
  node_labels                   = each.value.node_labels
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  node_taints                   = each.value.node_taints
  orchestrator_version          = each.value.orchestrator_version
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  pod_subnet_id                 = each.value.pod_subnet_id
  priority                      = each.value.priority
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode               = each.value.scale_down_mode
  snapshot_id                   = each.value.snapshot_id
  spot_max_price                = each.value.spot_max_price
  ultra_ssd_enabled = each.value.ultra_ssd_enabled
  vnet_subnet_id    = each.value.vnet_subnet_id
  workload_runtime  = each.value.workload_runtime
  zones             = each.value.zones
}


resource "null_resource" "pool_name_keeper" {
  for_each = var.node_pools

  triggers = {
    pool_name = each.value.name
  }
}