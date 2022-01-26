resource "azurerm_resource_group" "github_runners" {
  name     = "github-runners"
  location = var.location
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-github-runners"
  resource_group_name = azurerm_resource_group.github_runners.name
  location            = var.location
}

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  scope                            = azurerm_virtual_network.aks.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "github_runners" {
  name                = "github-runners"
  location            = var.location
  resource_group_name = azurerm_resource_group.github_runners.name
  dns_prefix          = "githubrunners"
  kubernetes_version  = "1.21.2"
  node_resource_group = "${azurerm_resource_group.github_runners.name}-nodes"

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks.id
  }

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  addon_profile {
    ingress_application_gateway {
      enabled   = var.enable_agic
      subnet_id = azurerm_subnet.app_gw.id
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "Standard"
  }
}

resource "local_file" "kube_config" {
  sensitive_content = azurerm_kubernetes_cluster.github_runners.kube_config_raw
  filename          = "${path.module}/kubeconfig_${azurerm_kubernetes_cluster.github_runners.name}"
}

output "kube_config_path" {
  value       = abspath(local_file.kube_config.filename)
  description = "The kube config file path."
}
