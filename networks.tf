resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example_VNET" {
  name                = "example-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_private_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_VNET.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "example_public_subnet" {
  name                 = "external"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_VNET.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example_public_ip" {
  name                = "publicip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "test-publicvm-111"
}

resource "azurerm_network_security_group" "allow_ssh_nsg" {
  name                = "allow_ssh_nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "example_private_nic" {
  name                = "example-private-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_private_subnet.id
    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_interface" "example_public_nic" {
  name                = "example-public-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_private_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_public_ip.id

  }
}

resource "azurerm_network_interface_security_group_association" "public_nic_association" {
  network_interface_id      = azurerm_network_interface.example_public_nic.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_nsg.id
}

resource "azurerm_network_interface_security_group_association" "private_nic_association" {
  network_interface_id      = azurerm_network_interface.example_private_nic.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_nsg.id
}

