resource "azurerm_resource_group" "bastion_example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "bastion_example_vnet" {
  name                = "examplevnet"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.bastion_example.location
  resource_group_name = azurerm_resource_group.bastion_example.name
}

resource "azurerm_subnet" "bastion_example_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.bastion_example.name
  virtual_network_name = azurerm_virtual_network.bastion_example_vnet.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "bastion_example_public_ip" {
  name                = "publicip"
  location            = azurerm_resource_group.bastion_example.location
  resource_group_name = azurerm_resource_group.bastion_example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_example_host" {
  name                = "examplebastion"
  location            = azurerm_resource_group.bastion_example.location
  resource_group_name = azurerm_resource_group.bastion_example.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_example_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_example_public_ip.id
  }
}

