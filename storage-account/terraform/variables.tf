variable "tags" {
  type = map(any)
  default = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "account_kind" {
  type        = string
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
}

variable "account_tier" {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
}

variable "account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "name" {
  type = string
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
}

variable "min_tls_version" {
  type = string
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2 for new storage accounts."
}

variable "enable_https_traffic_only" {
  type = bool
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
}

variable "allow_nested_items_to_be_public" {
  type = bool
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to true."
}

variable "shared_access_key_enabled" {
  type = bool
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true."
}

variable "cross_tenant_replication_enabled" {
  type = bool
  description = "(Optional) Should cross Tenant replication be enabled? Defaults to true."
}

variable "public_network_access_enabled" {
  type       = bool
  default    = false
  description = "(Optional) Whether the public network access is enabled? Defaults to true."
}

variable "table_encryption_key_type" {
  type        = string
  default     = "Account"
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
}

variable "queue_encryption_key_type" {
  type        = string
  default     = "Account"
  description = "(Optional) The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
}