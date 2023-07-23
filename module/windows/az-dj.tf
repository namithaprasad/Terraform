resource "azurerm_virtual_machine_extension" "domainjoin" {
  count                      = var.domain_join == true ? 1 : 0
  name                       = "${var.name}-dj"
  virtual_machine_id         = var.enable_legacy_vm_module == false ? azurerm_windows_virtual_machine.vm[0].id : azurerm_virtual_machine.vm[0].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = false
  settings = <<SETTINGS
    {
        "Name": "${var.domain}",
        "User": "${var.domain_join_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.domain_join_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }
}
