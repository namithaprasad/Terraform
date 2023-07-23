terraform {
  backend "azurerm" {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.61.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
  alias                      = "XXXXXXXXXXX"
  skip_provider_registration = true
  subscription_id            = "Subscription ID"
  features {}
}
