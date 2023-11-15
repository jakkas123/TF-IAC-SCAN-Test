#Retrieve Azure Key Vault tenant id
data "azurerm_client_config" "current" {}
#Create Azure Resource Group
resource "azurerm_resource_group" "example" {
name = "${var.Resource_group}"
location = "${var.location}"
tags = "${var.Resource_group_tags}"
}
#Create Azure Key Vault resource
resource "azurerm_key_vault" "example" {
name  = "${var.azkey_vault_name}"
location = azurerm_resource_group.example.location
resource_group_name = azurerm_resource_group.example.name
tenant_id = data.azurerm_client_config.current.tenant_id
soft_delete_retention_days = 7
purge_protection_enabled  = false
sku_name = "standard"
access_policy {
tenant_policy = data.azurerm_client_config.current.tenant_id
object_id = data.azurerm_client_config.current.object_id
key_permissions = [
"Get"
]
secret_permissions = [
"Get",
"Create"
]
storage_permissions = [
"Get"
]
}
}
# Generate Random password
resource "random_password" "password" {
length = 16
special = true
override_special = "_%@"
}
# Azure Key Vault Secret retrieval
resource "azurerm_key_vault_secret" "example" {
name  = "${var.azurerm_key_vault_secret_name}"
value = random_password.password.result
key_vault_id = azurerm_key_vault.example.id
}
