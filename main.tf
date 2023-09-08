
# ## VPN Gateway
resource "azurerm_subnet" "gateway-subnet" {
  name                                           = var.gateway_subnet.name
  resource_group_name                            = data.azurerm_virtual_network.hub.resource_group_name
  virtual_network_name                           = data.azurerm_virtual_network.hub.name
  address_prefixes                               = var.gateway_subnet.address_prefixes
}

module "vpn_gateway" {
  source = "../../modules/tf-azure-vnet-gateway"
  location = var.location
  resource_group_name = data.azurerm_virtual_network.hub.resource_group_name
  public_ip_gw_zones = var.vnet_gateway.public_ip_gw_zones
    
  vpn_name = var.vnet_gateway.vpn_name
  vpn_type = var.vnet_gateway.vpn_type
  vpn_routing_type = var.vnet_gateway.vpn_routing_type
  vpn_active_active = var.vnet_gateway.vpn_active_active
  vpn_generation = var.vnet_gateway.vpn_generation
  vpn_sku = var.vnet_gateway.vpn_sku
  subnet_id = azurerm_subnet.gateway-subnet.id
  vpn_enable_bgp = var.vnet_gateway.vpn_enable_bgp
  apipa_addresses_default = var.vnet_gateway.apipa_addresses_default
  apipa_addresses_active = var.vnet_gateway.apipa_addresses_active
  bgp_settings_asn = var.vnet_gateway.bgp_settings_asn

  tags = local.tags

  vpn_connections = {
    fra1 = {
      vpn_connection_name = "${var.vnet_gateway_connections.fra1.vpn_connection_name}-to-${var.vnet_gateway.vpn_name}"
      local_network_gateway_name = var.vnet_gateway_connections.fra1.local_network_gateway_name
      local_gateway_address = var.vnet_gateway_connections.fra1.local_gateway_address
      local_gateway_address_spaces = var.vnet_gateway_connections.fra1.local_gateway_address_spaces
      local_network_gateway_tags =  local.tags
      local_gateway_asn =  var.vnet_gateway_connections.fra1.local_gateway_asn
      local_gateway_bgp_peering_address = var.vnet_gateway_connections.fra1.local_gateway_bgp_peering_address
      enable_bgp_connection = var.vnet_gateway_connections.fra1.enable_bgp_connection
      shared_key_secret = data.azurerm_key_vault_secret.shared_key_secret_fra1.value
      ipsec_policy = null
    },
    dus = {
      vpn_connection_name = "${var.vnet_gateway_connections.dus.vpn_connection_name}-to-${var.vnet_gateway.vpn_name}"
      local_network_gateway_name = var.vnet_gateway_connections.dus.local_network_gateway_name
      local_gateway_address = var.vnet_gateway_connections.dus.local_gateway_address
      local_gateway_address_spaces = var.vnet_gateway_connections.dus.local_gateway_address_spaces
      local_network_gateway_tags =  local.tags
      local_gateway_asn =  var.vnet_gateway_connections.dus.local_gateway_asn
      local_gateway_bgp_peering_address = var.vnet_gateway_connections.dus.local_gateway_bgp_peering_address
      enable_bgp_connection = var.vnet_gateway_connections.dus.enable_bgp_connection
      shared_key_secret = data.azurerm_key_vault_secret.shared_key_secret_dus.value
      ipsec_policy = var.vnet_gateway_connections.dus.ipsec_policy
    },
    cem = {
      vpn_connection_name = "${var.vnet_gateway_connections.cem.vpn_connection_name}-to-${var.vnet_gateway.vpn_name}"
      local_network_gateway_name = var.vnet_gateway_connections.cem.local_network_gateway_name
      local_gateway_address = var.vnet_gateway_connections.cem.local_gateway_address
      local_gateway_address_spaces = var.vnet_gateway_connections.cem.local_gateway_address_spaces
      local_network_gateway_tags =  local.tags
      local_gateway_asn =  var.vnet_gateway_connections.cem.local_gateway_asn
      local_gateway_bgp_peering_address = var.vnet_gateway_connections.cem.local_gateway_bgp_peering_address
      enable_bgp_connection = var.vnet_gateway_connections.cem.enable_bgp_connection
      shared_key_secret = data.azurerm_key_vault_secret.shared_key_secret_cem.value
      ipsec_policy = null
    },
    iad1 = {
      vpn_connection_name = "${var.vnet_gateway_connections.iad1.vpn_connection_name}-to-${var.vnet_gateway.vpn_name}"
      local_network_gateway_name = var.vnet_gateway_connections.iad1.local_network_gateway_name
      local_gateway_address = var.vnet_gateway_connections.iad1.local_gateway_address
      local_gateway_address_spaces = var.vnet_gateway_connections.iad1.local_gateway_address_spaces
      local_network_gateway_tags =  local.tags
      local_gateway_asn =  var.vnet_gateway_connections.iad1.local_gateway_asn
      local_gateway_bgp_peering_address = var.vnet_gateway_connections.iad1.local_gateway_bgp_peering_address
      enable_bgp_connection = var.vnet_gateway_connections.iad1.enable_bgp_connection
      shared_key_secret = data.azurerm_key_vault_secret.shared_key_secret_iad1.value
      ipsec_policy = null
    }
  }
}


## Bastion

## Bastion
data "azurerm_virtual_network" "hub" {
  #provider = azurerm.hub
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-bastion-001"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = local.tags
}

module "nsg_security_rules_bastion" {
   source                         = "../../modules/tf-azure-nsg-security-rules"
   nsg_name                       = azurerm_network_security_group.nsg.name
   nsg-rules                      = var.nsg_bastion_rules
   resource_group_name            = var.rg_name
   tags                           = local.tags
}

resource "azurerm_subnet_network_security_group_association" "bastion_subnet_assoc" {
  subnet_id                 = module.bastion.subnet_ba_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

module "bastion" {
   source                         = "../../modules/tf-azure-bastion"
   rg_name_vnet                   = var.rg_name
   enable_bastion                 = var.enable_bastion
   location                       = var.location
   environment                    = var.environment
   subnet_range_ba                = var.subnet_range_ba
   vnet_name                      = data.azurerm_virtual_network.hub.name
   tags                           = local.tags
   bastion_host                   = var.bastion_host
}


## Application Gateway

## Firewall
