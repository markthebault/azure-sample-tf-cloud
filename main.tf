
# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"

  tags = var.tags

}


# Create virtual network
resource "azurerm_virtual_network" "tfvnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16", "172.16.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"

  tags = var.tags
}

resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-vnet-public"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  address_prefix       = "172.16.0.0/24"
}

resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-vnet-private"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  resource_group_name  = "${azurerm_resource_group.tfrg.name}"
  address_prefix       = "10.0.0.0/24"
}






resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.prefix}-cluster"
  location            = "${azurerm_resource_group.tfrg.location}"
  resource_group_name = "${azurerm_resource_group.tfrg.name}"
  dns_prefix          = "${var.prefix}-k8s"
  kubernetes_version  = "1.16.7"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name           = "default"
    node_count     = "${var.agent_count}"
    vm_size        = "${var.azurek8s_sku}"
    vnet_subnet_id = azurerm_subnet.private.id
    #max_pods = 10
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  role_based_access_control {
    enabled = true

    #Link AAD users (maybe groups) to K8S Users 
    # !!! must extract the admin cred add update users first
    # az aks get-credentials --resource-group myResourceGroup --name $aksname --admin
    # azure_active_directory {
    #   server_app_id     = "${var.k8s_aad_server_app_id}"
    #   server_app_secret = "${var.k8s_aad_server_app_secret}"
    #   client_app_id     = "${var.k8s_aad_client_app_id}"
    # }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    service_cidr       = "10.2.0.0/24"
    dns_service_ip     = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"

  }

}


# resource "azurerm_kubernetes_cluster_node_pool" "swiming" {
#   name                  = "external"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
#   vm_size               = var.azurek8s_sku
#   node_count            = 1
#   # max_pods = 10
#   # node_taints = ["key=value:external"]
#   vnet_subnet_id = azurerm_subnet.public.id

# }
