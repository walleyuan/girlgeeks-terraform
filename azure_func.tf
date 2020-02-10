# Create resource group
resource "azurerm_resource_group" "girlgeeks" {
  name     = "girlgeeks"
  location = "westus2"
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new Azure Resource Group
    rg_id = "${azurerm_resource_group.girlgeeks.name}"
  }

  byte_length = 8
}

# Create storage resource
resource "azurerm_storage_account" "girlgeeks" {
  name                     = "${random_id.server.hex}"
  resource_group_name      = "${azurerm_resource_group.girlgeeks.name}"
  location                 = "${azurerm_resource_group.girlgeeks.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create  service plan
resource "azurerm_app_service_plan" "girlgeeks" {
  name                = "girlgeeks-insights-func-service-plan"
  location            = "${azurerm_resource_group.girlgeeks.location}"
  resource_group_name = "${azurerm_resource_group.girlgeeks.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# Create app insights
resource "azurerm_application_insights" "girlgeeks" {
  name                = "girlgeeks-insights-func-insights"
  location            = "${azurerm_resource_group.girlgeeks.location}"
  resource_group_name = "${azurerm_resource_group.girlgeeks.name}"
  application_type    = "Web"
}

# Create function app
resource "azurerm_function_app" "girlgeeks" {
  name                      = "girlgeeks-insights-func"
  location                  = "${azurerm_resource_group.girlgeeks.location}"
  resource_group_name       = "${azurerm_resource_group.girlgeeks.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.girlgeeks.id}" 
  storage_connection_string = "${azurerm_storage_account.girlgeeks.primary_connection_string}"

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.girlgeeks.instrumentation_key}"
  }
}

