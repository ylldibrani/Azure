variable "rg_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
}

variable "environment" {
  description = "The environment in which the network is deployed"
  type        = string
}

variable "deployedby" {
    description = "By whom or via which ops system was the reources deployed"
    type        = string
}

variable "vnet_name" {
    description = "The name of the vNet ot be deployed"
    type        = string
}

variable "vnet_address_space" {
    description = "The list of CIDR ranges of the vNet"
    type        = list(string)
}

variable "tags" {
  description = "Specifies the tags to be applied to the resources"
  type = object({
        WorkloadName    = string,
        BusinessUnit    = string,
        CostCenter      = string,
        OpsTeam         = string,
        Criticality     = string,
        OpsCommitment   = string
    })
}

variable "subnets" {
  description = "Subnets configuration"
}

variable "hub_vnet_remote_state" {
  description = "The remote Terraform state config for the hub vnet deployment"
  type = object({
    key                  = string,
    resource_group_name  = string,
    storage_account_name = string,
    container_name       = string
  })
}

// vnet gateway variables

variable "gateway_subnet" {
  type = object({
    name = string
    address_prefixes = list(string)
  })
  description = "Gateway subnet configurations to create new subnet in existing virtual network"
}

variable "vnet_gateway" {
  type = object({
    public_ip_gw_zones = list(string)
    vpn_name = string
    vpn_type = string
    vpn_routing_type = string
    vpn_active_active = bool
    vpn_generation = string
    vpn_sku = string
    vpn_enable_bgp = bool
    apipa_addresses_default = list(string)
    apipa_addresses_active  = list(string)
    bgp_settings_asn = number
  })
  description = "Virtual network gateway configurations"
}

variable "vnet_gateway_connections" {
  type = map(object({
    vpn_connection_name = string
    local_network_gateway_name = string
    local_gateway_address = string
    local_gateway_address_spaces = list(string)
    local_gateway_asn = number
    local_gateway_bgp_peering_address = string
    enable_bgp_connection = bool
    ipsec_policy = optional(object({
      dh_group = string
      ike_encryption = string
      ike_integrity = string
      ipsec_encryption = string
      ipsec_integrity = string
      pfs_group = string
      sa_datasize = number
      sa_lifetime = number
    }), null)
  }))
  description = "Virtual network gateway connection and local network gateway configurations"
}

//bastion host variables
variable "enable_bastion" {
  type        = bool
  description = "Creates a Bastion Host."
}

variable "subnet_range_ba" {
  description = "(Required) Subnet range for bastion host"
  type        = list(string)
}

variable "nsg_bastion_rules" {
  description = "Network security rules for bastion host"
  type = map
}

variable "bastion_host" {
  description = "The details of the Azure Bastion Host to be created"
  type = object({
    sku                    = string // SKU of the Azure Bastion Host, either "Basic" or "Standard"
    copy_paste_enabled     = bool 
    file_copy_enabled      = bool 
    ip_connect_enabled     = bool 
    scale_units            = number /// Number of scale units for the Azure Bastion Host, between 2-50
    shareable_link_enabled = bool 
    tunneling_enabled      = bool 
  })
}