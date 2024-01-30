resource "azurerm_storage_account" "storage_account" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  min_tls_version                  = var.min_tls_version
  location                         = var.location
  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  tags                             = var.tags
  enable_https_traffic_only        = var.enable_https_traffic_only
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  shared_access_key_enabled        = var.shared_access_key_enabled
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  table_encryption_key_type        = var.table_encryption_key_type
  queue_encryption_key_type        = var.queue_encryption_key_type
}