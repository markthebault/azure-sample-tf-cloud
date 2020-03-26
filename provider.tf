terraform {
  required_version = ">= 0.12.0"

  backend "remote"{
    hostname = "app.terraform.io"
    organization = "mtcloud"

    workspaces{
      name = "test"
    }
  }
}

provider "azurerm" {
  version = "= 2.2.0"
  features {}
}
