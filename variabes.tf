variable "tags" {
  default = {
    terraform = true
  }
}

variable "prefix" { default = "mth-aks" }
variable "location" { default = "westeurope" }

variable "admin_username" { default = "mark" }
variable "ssh_public_key" {}

variable "agent_count" { default = 1 }
variable "azurek8s_sku" { default = "Standard_DS1_v2" }

variable "client_id" {}
variable "client_secret" {}

variable "k8s_aad_server_app_id" {}
variable "k8s_aad_server_app_secret" {}
variable "k8s_aad_client_app_id" {}
