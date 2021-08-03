# The Azure Provider can be used to configure infrastructure in Microsoft Azure using the Azure Resource Manager API's.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.1.0"
    }
  }

  backend "local" {
    path = ".terraform/terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
