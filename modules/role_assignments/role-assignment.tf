resource "azurerm_role_assignment" "acr" {
  for_each = var.attached_acr_id_map

  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  scope                            = each.value
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}


data "azurerm_user_assigned_identity" "cluster_identity" {
  count = nonsensitive((var.client_id == "" || var.client_secret == "") && var.identity_type == "UserAssigned" ? 1 : 0)

  name                = split("/", var.identity_ids[0])[8]
  resource_group_name = split("/", var.identity_ids[0])[4]
}


resource "azurerm_role_assignment" "network_contributor" {
  for_each = nonsensitive(var.create_role_assignment_network_contributor && (var.client_id == "" || var.client_secret == "") ? local.subnet_ids : [])

  principal_id         = coalesce(try(data.azurerm_user_assigned_identity.cluster_identity[0].principal_id, azurerm_kubernetes_cluster.main.identity[0].principal_id), var.client_id)
  scope                = each.value
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = length(var.network_contributor_role_assigned_subnet_ids) == 0
      error_message = "Cannot set both of `var.create_role_assignment_network_contributor` and `var.network_contributor_role_assigned_subnet_ids`."
    }
  }
}

resource "azurerm_role_assignment" "network_contributor_on_subnet" {
  for_each = var.network_contributor_role_assigned_subnet_ids

  principal_id         = coalesce(try(data.azurerm_user_assigned_identity.cluster_identity[0].principal_id, azurerm_kubernetes_cluster.main.identity[0].principal_id), var.client_id)
  scope                = each.value
  role_definition_name = "Network Contributor"

  lifecycle {
    precondition {
      condition     = !var.create_role_assignment_network_contributor
      error_message = "Cannot set both of `var.create_role_assignment_network_contributor` and `var.network_contributor_role_assigned_subnet_ids`."
    }
  }
}

data "azurerm_client_config" "this" {}









