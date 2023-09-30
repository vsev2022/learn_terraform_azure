variable "vmsize" {
  type = string
  default = "Standard_B1s"
}

resource "azurerm_linux_virtual_machine" "privatevm" {
  name                = "privatevm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
//  size                = "Standard_A1_v2"
//  size                = "Standard_F2"
  size = var.vmsize
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example_private_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "publicvm" {
  name                = "publicvm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size = var.vmsize
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example_public_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}


