terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Specify the desired version of the azurerm provider
    }
  }

  required_version = ">= 1.0"  # Ensure Terraform version >= 1.0
}

# Provider configuration for Azure RM (azurerm)
provider "azurerm" {
  features {}  # Required block for the provider

  # Authentication using service principal with sample values
  client_id       = "12345678-1234-1234-1234-1234567890ab"          
  client_secret   = "your-client-secret-value"                      
  subscription_id = "abcd1234-5678-9abc-def0-1234567890ab"         
  tenant_id       = "12345678-1234-1234-1234-1234567890ab"         
}
