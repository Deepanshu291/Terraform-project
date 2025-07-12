terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Adjust the version as needed
    }
  }
}

provider "azurerm" {
  features { 
  }
  subscription_id = ""
}

resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = "East US"
}

resource "azurerm_virtual_network" "code-vnet" {
  name = "codex-vnet"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "code-subnet" {
  name = "codex-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.code-vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "code-public-ip" {
  name = "codex-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "codexdev"
}

resource "azurerm_network_interface" "code-nic" {
  name = "code-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 ip_configuration {
   name = "code-ipconfig"
   private_ip_address_allocation = "Dynamic"
   subnet_id = azurerm_subnet.code-subnet.id
   public_ip_address_id = azurerm_public_ip.code-public-ip.id
 }
}

# resource "azurerm_network_security_group" "code-nsg" {
#   name = "devxserver-nsg"
#   resource_group_name = "Coderserver-RG"
#   location = "Central India"
# }
resource "azurerm_network_security_group" "code-nsg" {
  name = "codex-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 330
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-8080PORT"
    priority                   = 350
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "code-nsg-nic" {
 network_interface_id = azurerm_network_interface.code-nic.id 
 network_security_group_id = azurerm_network_security_group.code-nsg.id
}





output "public_ip" {
  value = azurerm_public_ip.code-public-ip.ip_address
}

output "dns_name" {
  value = azurerm_public_ip.code-public-ip.fqdn
}