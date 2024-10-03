data "external" "routerip" {
  program = ["bash", "-c", "curl -s 'https://api64.ipify.org?format=json'"]
}

data "azurerm_client_config" "client" {}

data "azuread_user" "terraform_user" {
  object_id = data.azurerm_client_config.client.object_id
}
