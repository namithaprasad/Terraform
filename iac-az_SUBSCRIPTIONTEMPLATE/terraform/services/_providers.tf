terraform {
  backend "azurerm" {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.61.0"
    }
    # azurecaf = {
    #   source  = "aztfmod/azurecaf"
    #   version = "1.2.2"
    # }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias                      = "mgtsub"
  skip_provider_registration = true 
  subscription_id            = "Subscription ID"
  features {}
}
