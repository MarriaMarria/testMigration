variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    project     = "testmigration",
    environment = "dev"
    region      = "westeurope"
    cuid        = "VBKY2268"
    owner       = "maria.kononevskaya@orange.com"
  }
}

variable "resource_group_name" {
  description = "This variable sets the resource group name"
  type = string   
  default     = "Test-AzureMigrate-Maria"

}


variable "resource_group_location" {
  description = "This variable sets the resource group location"
  type        = string
  default     = "westeurope"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.8.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "This variable sets subnet address prefixes array"
  type        = list(string)
  default     = ["10.8.0.0/24"]
}

variable "migrateProjectName" {
  description = "The name of Azure Migrate Project created with arm template, can be max 13 letters"
  default = "mariamigr"
  
}

variable "location" {
  description = "The variable sets the location of azure migrate project"
  default = "westeurope"
  
}
# variable "azure_tenant_id" {
#   description = "This variable sets the tenant id"
#   type        = string
#   sensitive   = true
# }

# variable "azure_subscription_id" {
#   description = "This variable sets the subscription id"
#   type        = string
#   sensitive   = true
# }

# variable "azure_client_id" {  #compte utilisé pour le depmoyment 
#   description = "This variable sets the client id"
#   type        = string
# }

# variable "azure_client_secret" {
#   description = "This variable sets the client secret"
#   type        = string
#   sensitive   = true
# }