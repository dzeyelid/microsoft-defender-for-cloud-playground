terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.workload}"
  location = var.location
}

resource "random_string" "func_storage" {
  length  = 22
  special = false
  upper   = false
  keepers = {
    resource_group_id = azurerm_resource_group.main.id
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.func_storage.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_0"
}
