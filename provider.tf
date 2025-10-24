terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"   # change to 3.x if 5.x not supported
    }
  }

  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}
