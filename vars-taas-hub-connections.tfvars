rg_name                = "rg-networkinfra-hub-001"
location               = "germanywestcentral"
environment            = "Hub"

vnet_name                 = "azure-germanywestcentral-vnet-taas-hub"
vnet_address_space        = ["10.140.112.0/21"]

tags = {
    WorkloadName     = "TaaS Core Infrastructure"
    BusinessUnit     = "TaaS"
    CostCenter       = "61163"
    OpsTeam          = "MSP-CloudAstro"
    Criticality      = "Business unit-critical"
    OpsCommitment    = "Platform operations"
}

subnets = {
  vpn = {
    address_prefixes                              = ["10.140.112.0/24"]
    private_endpoint_network_policies_enabled     = false
    private_link_service_network_policies_enabled = false
    network_security_group                        = "nsg_to_be_created"
  }
  waf = {
    address_prefixes                              = ["10.140.113.0/24"]
    private_endpoint_network_policies_enabled     = false
    private_link_service_network_policies_enabled = false
    network_security_group                        = "nsg_to_be_created"
  }
  bastion = {
    address_prefixes                              = ["10.140.114.0/24"]
    private_endpoint_network_policies_enabled     = false
    private_link_service_network_policies_enabled = false
    network_security_group                        = "nsg_to_be_created"
  }
  vulnscanner = {
    address_prefixes                              = ["10.140.115.0/24"]
    private_endpoint_network_policies_enabled     = false
    private_link_service_network_policies_enabled = false
  }
}

hub_vnet_remote_state = {
  key                  = "hub-connections.tfstate"
  resource_group_name  = "rg-tfstate-hub-001"
  storage_account_name = "sttaastfstatehub359"
  container_name       = "tfstate"
}

## VPN gateway

gateway_subnet = {
  name = "GatewaySubnet"
  address_prefixes = ["10.140.112.0/24"]
}

vnet_gateway = {
  public_ip_gw_zones = ["1" , "2" , "3"]
  vpn_name = "vgw-hub-germanywestcentral-001"
  vpn_type = "Vpn"
  vpn_routing_type = "RouteBased"
  vpn_active_active = false
  vpn_generation = "Generation2"
  vpn_sku = "VpnGw2AZ"
  vpn_enable_bgp = true
  apipa_addresses_default = ["169.254.21.1"]
  apipa_addresses_active  = []
  bgp_settings_asn = 65515
}

vnet_gateway_connections = {
  fra1 = {
    vpn_connection_name = "cn-lgw-hub-germanywestcentral-fra1-001"
    local_network_gateway_name = "lgw-hub-germanywestcentral-fra1-001"
    local_gateway_address = "88.205.109.254"
    local_gateway_address_spaces = null
    local_gateway_asn = 65107
    local_gateway_bgp_peering_address = "169.254.21.2"
    enable_bgp_connection = true
  },
  dus = {
    vpn_connection_name = "cn-lgw-hub-germanywestcentral-dus-001"
    local_network_gateway_name = "lgw-hub-germanywestcentral-dus-001"
    local_gateway_address = "213.61.156.125"
    local_gateway_address_spaces = ["10.119.0.0/16"]
    local_gateway_asn = null
    local_gateway_bgp_peering_address = null
    enable_bgp_connection = false
    ipsec_policy = {
      dh_group = "ECP384"
      ike_encryption = "GCMAES256"
      ike_integrity = "SHA256"
      ipsec_encryption = "GCMAES256"
      ipsec_integrity = "GCMAES256"
      pfs_group = "ECP384"
      sa_datasize = 102400000
      sa_lifetime = 3600
    }
  },
  cem = {
    vpn_connection_name = "cn-lgw-hub-germanywestcentral-cem-001"
    local_network_gateway_name = "lgw-hub-germanywestcentral-cem-001"
    local_gateway_address = "62.90.28.33"
    local_gateway_address_spaces = ["172.17.252.0/23"]
    local_gateway_asn = null
    local_gateway_bgp_peering_address = null
    enable_bgp_connection = false
  },
  iad1 = {
    vpn_connection_name = "cn-lgw-hub-germanywestcentral-iad1-001"
    local_network_gateway_name = "lgw-hub-germanywestcentral-iad1-001"
    local_gateway_address = "198.24.43.62"
    local_gateway_address_spaces = []
    local_gateway_asn = 65001
    local_gateway_bgp_peering_address = "169.254.21.3"
    enable_bgp_connection = true
  }
}

#bastion host
subnet_range_ba       = ["10.140.116.0/26"] #subnet range for bastion host
enable_bastion        = true
bastion_host = {
  sku                    = "Standard" // SKU of the Azure Bastion Host, either "Basic" or "Standard" 
  scale_units            = 2 /// Number of scale units for the Azure Bastion Host, between 2-50
  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true
  ip_connect_enabled     = true
}
# Security rules for bastion host
nsg_bastion_rules = { 
    # inbound security rules
    AllowHttpsInbound = {
      name                       = "AllowHttpsInbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
 
    AllowGatewayManagerInbound = {
      name                       = "AllowGatewayManagerInbound"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
 
    AllowAzureLoadBalancerInbound = {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }

    AllowBastionHostCommunication8080= {
      name                       = "AllowBastionHostCommunication8080"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
   
    AllowBastionHostCommunication5701= {
      name                       = "AllowBastionHostCommunication5701"
      priority                   = 160
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "5701"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
   # outbound security rules
    AllowRdpOutbound= {
      name                       = "AllowRdpOutbound"
      priority                   = 170
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowSshOutbound= {
      name                       = "AllowSshOutbound"
      priority                   = 180
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowAzureCloudOutbound= {
      name                       = "AllowAzureCloudOutbound"
      priority                   = 190
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }

    AllowBastionCommunication8080= {
      name                       = "AllowBastionCommunication8080"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowBastionCommunication5701= {
      name                       = "AllowBastionCommunication5701"
      priority                   = 210
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5701"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    AllowHttpOutbound= {
      name                       = "AllowHttpOutbound"
      priority                   = 220
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5701"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    } 
}


