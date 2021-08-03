locals {
    prefix = join("-", [var.resource_tags.project, var.resource_tags.region, var.resource_tags.environment])
}
resource "azurerm_resource_group" "test-migration-maria" {
    name     = "${local.prefix}-rg"
    location = var.resource_tags.region
    tags = var.resource_tags
}

resource "azurerm_virtual_network" "test-migration-maria" {
    name                = "${local.prefix}-vnet"
    address_space       = var.vnet_address_space
    location            = azurerm_resource_group.test-migration-maria.location
    resource_group_name = azurerm_resource_group.test-migration-maria.name
    tags = var.resource_tags

}

resource "azurerm_subnet" "test-migration-maria" {
    name                 = "${local.prefix}-subnet"
    resource_group_name  = azurerm_resource_group.test-migration-maria.name
    virtual_network_name = azurerm_virtual_network.test-migration-maria.name
    address_prefixes     = var.subnet_address_prefixes

}

resource "azurerm_template_deployment" "test-migration-maria" {
    name = "${local.prefix}-migrate-project"
    resource_group_name  = azurerm_resource_group.test-migration-maria.name
    template_body       = <<DEPLOY

{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "migrateProjectName": {
            "type": "string",
            "maxLength": 13,
            "metadata": {
                "description": "Specifies a name for creating the migrate project."
            }
        },
        "location": {
            "type": "string",
            "allowedValues": [
                "centralus",
                "eastasia",
                "northeurope",
                "westeurope",
                "westus2",
                "australiasoutheast",
                "uksouth",
                "ukwest",
                "canadacentral",
                "centralindia",
                "southindia",
                "japaneast",
                "japanwest",
                "brazilsouth",
                "koreasouth",
                "koreacentral",
                "francecentral",
                "switzerlandnorth",
                "australiaeast",
                "southeastasia",
                "centraluseuap",
                "eastus2euap",
                "canadaeast",
                "southcentralus",
                "usgovvirginia",
                "usgovarizona"
            ],
            "metadata": {
                "description": "Specifies the location for all resources."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Migrate/MigrateProjects",
            "apiVersion": "2020-05-01",
            "name": "[parameters('migrateProjectName')]",
            "location": "[parameters('location')]",
            "tags": {
                "Migrate Project": "[parameters('migrateProjectName')]"
            },
            "properties": {}
        },
        {
            "type": "Microsoft.Migrate/MigrateProjects/Solutions",
            "apiVersion": "2020-05-01",
            "name": "[concat(parameters('migrateProjectName'), '/Servers-Assessment-ServerAssessment')]",
            "dependsOn": [
                "[resourceId('Microsoft.Migrate/MigrateProjects', parameters('migrateProjectName'))]"
            ],
            "properties": {
                "tool": "ServerAssessment",
                "purpose": "Assessment",
                "goal": "Servers",
                "status": "Active"
            }
        },
        {
            "type": "Microsoft.Migrate/MigrateProjects/Solutions",
            "apiVersion": "2020-05-01",
            "name": "[concat(parameters('migrateProjectName'), '/Servers-Discovery-ServerDiscovery')]",
            "dependsOn": [
                "[resourceId('Microsoft.Migrate/MigrateProjects', parameters('migrateProjectName'))]"
            ],
            "properties": {
                "tool": "ServerDiscovery",
                "purpose": "Discovery",
                "goal": "Servers",
                "status": "Inactive"
            }
        },
        {
            "type": "Microsoft.Migrate/MigrateProjects/Solutions",
            "apiVersion": "2020-05-01",
            "name": "[concat(parameters('migrateProjectName'), '/Servers-Migration-ServerMigration')]",
            "dependsOn": [
                "[resourceId('Microsoft.Migrate/MigrateProjects', parameters('migrateProjectName'))]"
            ],
            "properties": {
                "tool": "ServerMigration",
                "purpose": "Migration",
                "goal": "Servers",
                "status": "Active"
            }
        }
    ]
}

DEPLOY
    parameters = {
        "migrateProjectName" = var.migrateProjectName

        "location" = var.location
        }
    deployment_mode = "Incremental"
    }
