## https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/#performing-role-assignments
## https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/#obtaining-the-id-of-the-managed-identity--service-principal

resource "azurerm_user_assigned_identity" "runners" {
  name                = "github-runners"
  resource_group_name = azurerm_resource_group.github_runners.name
  location            = var.location
}

output "runners_identity" {
  value = {
    resource_id = azurerm_user_assigned_identity.runners.id
    client_id   = azurerm_user_assigned_identity.runners.client_id
  }
  description = "The runners managed identity informations (client_id and resource_id)."
}

data "azurerm_resource_group" "nodes" {
  name = azurerm_kubernetes_cluster.github_runners.node_resource_group
}

resource "azurerm_role_assignment" "kubelet_mi_operator_on_runners_identity" {
  scope                            = azurerm_user_assigned_identity.runners.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_kubernetes_cluster.github_runners.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "kubelet_mi_vm_contributor" {
  scope                            = data.azurerm_resource_group.nodes.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = azurerm_kubernetes_cluster.github_runners.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

data "azurerm_subscription" "current" {
}

# For this example, the identity we use will have contributor access on the subscription
# but this can be adjusted to fit your needs
resource "azurerm_role_assignment" "runners_identity_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.runners.principal_id
}
