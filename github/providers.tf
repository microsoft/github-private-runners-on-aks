terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {}
}

provider "github" {}
