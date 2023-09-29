# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = "b69985b8-36e1-43b4-a5fc-bec3406e0d79"
  client_id = "d4bd4432-d40a-4eba-b224-1d9e937c9a3d"
  client_secret = "V1e8Q~ZKkpzAhWbgK_.AZ.t_YLfJNYQsEuM8Fc~y"
  tenant_id = "fd331275-31f5-402e-9b39-e688905ca73e"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westeurope"
}

