/*
Example:

custom_data = ${file("serverconfig/jumpbox-init.ps1")}

*/

variable "custom_data" {
  description = "Specifies custom data to supply to the machine. On Linux-based systems, this can be used as a cloud-init script. On other systems, this will be copied as a file on disk. Internally, Terraform will base64 encode this value before sending it to the API. The maximum length of the binary array is 65535 bytes."
  default     = null
}

resource "azurerm_virtual_machine_extension" "CustomScriptExtension" {

  count                = "${var.custom_data == null ? 0 : 1}"
  name                 = "CustomScriptExtension"
  location             = "${var.location}"
  resource_group_name  = "${var.resourceGroupName}"
  virtual_machine_name = "${azurerm_virtual_machine.dc1.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
        {
        "commandToExecute": "powershell -command copy-item \"c:\\AzureData\\CustomData.bin\" \"c:\\AzureData\\CustomData.ps1\";\"c:\\AzureData\\CustomData.ps1\""
        }
SETTINGS

  tags = "${var.tags}"
  depends_on = [azurerm_virtual_machine_extension.createMgmtADForest]
}
