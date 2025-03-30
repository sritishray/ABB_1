resource "azurerm_log_analytics_workspace" "main" {
  count = local.create_analytics_workspace ? 1 : 0

  location                                = var.location
  name                                    = try(coalesce(var.cluster_log_analytics_workspace_name, trim("${var.prefix}-workspace", "-")), "aks-workspace")
  resource_group_name                     = coalesce(var.log_analytics_workspace_resource_group_name, var.resource_group_name)
  allow_resource_only_permissions         = var.log_analytics_workspace_allow_resource_only_permissions
  cmk_for_query_forced                    = var.log_analytics_workspace_cmk_for_query_forced
  daily_quota_gb                          = var.log_analytics_workspace_daily_quota_gb
  data_collection_rule_id                 = var.log_analytics_workspace_data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.log_analytics_workspace_immediate_data_purge_on_30_days_enabled
  internet_ingestion_enabled              = var.log_analytics_workspace_internet_ingestion_enabled
  internet_query_enabled                  = var.log_analytics_workspace_internet_query_enabled
  local_authentication_disabled           = var.log_analytics_workspace_local_authentication_disabled
  reservation_capacity_in_gb_per_day      = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  retention_in_days                       = var.log_retention_in_days
  sku                                     = var.log_analytics_workspace_sku
  dynamic "identity" {
    for_each = var.log_analytics_workspace_identity == null ? [] : [var.log_analytics_workspace_identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  lifecycle {
    precondition {
      condition     = can(coalesce(var.cluster_log_analytics_workspace_name, var.prefix))
      error_message = "You must set one of `var.cluster_log_analytics_workspace_name` and `var.prefix` to create `azurerm_log_analytics_workspace.main`."
    }
  }
}

