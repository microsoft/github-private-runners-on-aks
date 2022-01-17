resource "azurerm_virtual_network" "aks" {
  name                = "aks"
  address_space       = ["10.240.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.github_runners.name
}

resource "azurerm_subnet" "cluster" {
  name                 = "aks_nodes"
  address_prefixes     = ["10.240.0.0/24"]
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.github_runners.name
}

resource "azurerm_subnet" "app_gw" {
  name                 = "agic"
  address_prefixes     = ["10.240.1.0/24"]
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.github_runners.name
}
