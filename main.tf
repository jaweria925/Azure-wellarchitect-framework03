resource "azurerm_resource_group" "fabricated_microservices_rg" {
    name     = "fabricated-microservices-rg"
    location = "australiaeast"
}

# CREATE aks CLUSTER

resource "azurerm_kubernetes_cluster" "fabricated_microservices_aks" {
    name                = "fabricated-microservices-aks"
    location            = azurerm_resource_group.fabricated_microservices_rg.location
    resource_group_name = azurerm_resource_group.fabricated_microservices_rg.name
    dns_prefix          = "fabricatedmicroservicesaks"

    default_node_pool {
        name       = "default"
        node_count = 2
        vm_size    = "Standard_A2_v2"
    }

    identity {
        type = "SystemAssigned"
    }


}


# create ACR
resource "azurerm_container_registry" "fabricated_microservices_acr" {
    name                     = "fabricatedmicroservicesacr"
    resource_group_name      = azurerm_resource_group.fabricated_microservices_rg.name
    location                 = azurerm_resource_group.fabricated_microservices_rg.location
    sku                      = "Basic"
    admin_enabled            = true
}

# create role assignment for ACR pull
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.fabricated_microservices_acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.fabricated_microservices_aks.identity[0].principal_id
}


output "kube_config" {
  value     = azurerm_kubernetes_cluster.fabricated_microservices_aks.kube_config_raw
  sensitive = true
}
