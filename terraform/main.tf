resource "random_string" "example" {
  length  = "3"
  special = false
  upper   = false
}

resource "azurerm_resource_group" "example" {
  name     = "node-az-fnc-tf-${random_string.example.result}-example"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "nodeazfnctf${random_string.example.result}"
  location                 = "${azurerm_resource_group.example.location}"
  resource_group_name      = "${azurerm_resource_group.example.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "node-az-fnc-tf-${random_string.example.result}-example-plan"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "node-az-fnc-tf-${random_string.example.result}-example"
  location                   = "${azurerm_resource_group.example.location}"
  resource_group_name        = "${azurerm_resource_group.example.name}"
  app_service_plan_id        = "${azurerm_app_service_plan.example.id}"
  storage_connection_string  = "${azurerm_storage_account.example.primary_connection_string}"

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.example.instrumentation_key}"
  }

  provisioner "local-exec" {
    command     = "git remote add azure https://\\${self.site_credential.0.username}:${self.site_credential.0.password}@${self.name}.scm.azurewebsites.net:443/${self.name}.git"
    working_dir = ".."
    on_failure  = "continue"
  }

  provisioner "local-exec" {
    command     = "git push azure"
    working_dir = ".."
  }

  
}

resource "azurerm_application_insights" "example" {
  name                = "node-az-fnc-tf-${random_string.example.result}-example"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  application_type    = "web"
}

