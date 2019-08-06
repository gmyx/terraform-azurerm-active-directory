


resource azurerm_availability_set availabilityset {
  name                         = "${var.ad_prefix}-AvailabilitySet"
  location                     = "${var.location}"
  resource_group_name          = "${var.resourceGroupName}"
  platform_fault_domain_count  = "2"
  platform_update_domain_count = "3"
  managed                      = "true"
  tags                         = "${var.tags}"
}

resource azurerm_network_security_group NSG-dc1 {
  name                = "${var.ad_prefix}1-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resourceGroupName}"
  security_rule {
    name                       = "AllowAllInbound"
    description                = "Allow all in"
    access                     = "Allow"
    priority                   = "100"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    description                = "Allow all out"
    access                     = "Allow"
    priority                   = "105"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  tags = "${var.tags}"
}

resource azurerm_network_interface NIC-dc1 {
  name                          = "${var.ad_prefix}1-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.resourceGroupName}"
  enable_ip_forwarding          = "${var.nic_enable_ip_forwarding}"
  enable_accelerated_networking = "${var.nic_enable_accelerated_networking}"
  network_security_group_id     = "${azurerm_network_security_group.NSG-dc1.id}"
  dns_servers                   = "${var.dnsServers}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address            = "${var.rootDC1IPAddress}"
    private_ip_address_allocation = "${var.rootDC1IPAddress_allocation}"
    primary                       = true
  }
}

resource azurerm_virtual_machine dc1 {
  name                             = "${var.ad_prefix}1"
  location                         = "${var.location}"
  resource_group_name              = "${var.resourceGroupName}"
  availability_set_id              = "${azurerm_availability_set.availabilityset.id}"
  vm_size                          = "${var.vm_size}"
  network_interface_ids            = ["${azurerm_network_interface.NIC-dc1.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.NIC-dc1.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${var.ad_prefix}1"
    admin_username = "${var.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.secretPassword.value}"
  }
  storage_image_reference {
    publisher = "${var.storage_image_reference.publisher}"
    offer     = "${var.storage_image_reference.offer}"
    sku       = "${var.storage_image_reference.sku}"
    version   = "${var.storage_image_reference.version}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  storage_os_disk {
    name          = "${var.ad_prefix}1-OsDisk_1"
    caching       = "${var.storage_os_disk.caching}"
    create_option = "${var.storage_os_disk.create_option}"
    os_type       = "${var.storage_os_disk.os_type}"
  }
  storage_data_disk {
    name          = "${var.ad_prefix}1-DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "10"
  }
  tags = "${var.tags}"
}

resource azurerm_network_security_group NSG-dc2 {
  name                = "${var.ad_prefix}2-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resourceGroupName}"
  security_rule {
    name                       = "AllowAllInbound"
    description                = "Allow all in"
    access                     = "Allow"
    priority                   = "100"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    description                = "Allow all out"
    access                     = "Allow"
    priority                   = "105"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  tags = "${var.tags}"
}

resource azurerm_network_interface NIC-dc2 {
  name                          = "${var.ad_prefix}2-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.resourceGroupName}"
  enable_ip_forwarding          = "${var.nic_enable_ip_forwarding}"
  enable_accelerated_networking = "${var.nic_enable_accelerated_networking}"
  network_security_group_id     = "${azurerm_network_security_group.NSG-dc2.id}"
  dns_servers                   = "${var.dnsServers}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address            = "${var.rootDC2IPAddress}"
    private_ip_address_allocation = "${var.rootDC2IPAddress_allocation}"
    primary                       = true
  }
}

resource azurerm_virtual_machine dc2 {
  name                         = "${var.ad_prefix}2"
  location                     = "${var.location}"
  resource_group_name          = "${var.resourceGroupName}"
  availability_set_id          = "${azurerm_availability_set.availabilityset.id}"
  vm_size                      = "${var.vm_size}"
  network_interface_ids        = ["${azurerm_network_interface.NIC-dc2.id}"]
  primary_network_interface_id = "${azurerm_network_interface.NIC-dc2.id}"

  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${var.ad_prefix}2"
    admin_username = "${var.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.secretPassword.value}"
  }
  storage_image_reference {
    publisher = "${var.storage_image_reference.publisher}"
    offer     = "${var.storage_image_reference.offer}"
    sku       = "${var.storage_image_reference.sku}"
    version   = "${var.storage_image_reference.version}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  storage_os_disk {
    name          = "${var.ad_prefix}2-OsDisk_1"
    caching       = "${var.storage_os_disk.caching}"
    create_option = "${var.storage_os_disk.create_option}"
    os_type       = "${var.storage_os_disk.os_type}"
  }
  storage_data_disk {
    name          = "${var.ad_prefix}2-DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "10"
  }
  tags = "${var.tags}"
}

resource "azurerm_virtual_machine_extension" "createMgmtADForest" {
  name                 = "createMgmtADForest"
  location             = "${var.location}"
  resource_group_name  = "${var.resourceGroupName}"
  virtual_machine_name = "${azurerm_virtual_machine.dc1.name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"

  settings = <<SETTINGS
            {
                "WmfVersion": "latest",
                "configuration": {
                    "url": "https://raw.githubusercontent.com/canada-ca-terraform-modules/terraform-azurerm-active-directory/20190731.1/DSC/CreateADRootDC1.ps1.zip",
                    "script": "CreateADRootDC1.ps1",
                    "function": "CreateADRootDC1"
                },
                "configurationArguments": {
                    "DomainName": "${var.ad_domain_name}",
                    "DnsForwarder": "168.63.129.16",
                    "DnsAlternate": "${azurerm_network_interface.NIC-dc1.ip_configuration.0.private_ip_address}",
                    "ReverseZoneObject": "${var.reverse_Zone_Object}"
                }
            }
            SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
        {
            "configurationArguments": {
                "adminCreds": {
                    "UserName": "${var.admin_username}",
                    "Password": "${data.azurerm_key_vault_secret.secretPassword.value}"
                }
            }
        }
    PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "addMgmtADSecondaryDC" {
  name                 = "addMgmtADSecondaryDC"
  location             = "${var.location}"
  resource_group_name  = "${var.resourceGroupName}"
  virtual_machine_name = "${azurerm_virtual_machine.dc2.name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.77"
  depends_on           = ["azurerm_virtual_machine_extension.createMgmtADForest"]

  settings = <<SETTINGS
            {
                "WmfVersion": "latest",
                "configuration": {
                    "url": "https://raw.githubusercontent.com/canada-ca-terraform-modules/terraform-azurerm-active-directory/20190731.1/DSC/ConfigureADNextDC.ps1.zip",
                    "script": "ConfigureADNextDC.ps1",
                    "function": "ConfigureADNextDC"
                },
                "configurationArguments": {
                    "DomainName": "${var.ad_domain_name}",
                    "DNSServer": "${azurerm_network_interface.NIC-dc1.ip_configuration.0.private_ip_address}",
                    "DnsForwarder": "${azurerm_network_interface.NIC-dc1.ip_configuration.0.private_ip_address}",
                    "ReverseZoneObject": "${var.reverse_Zone_Object}"
                }
            }
            SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
        {
            "configurationArguments": {
                "adminCreds": {
                    "UserName": "${var.admin_username}",
                    "Password": "${data.azurerm_key_vault_secret.secretPassword.value}"
                }
            }
        }
    PROTECTED_SETTINGS
}
