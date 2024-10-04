resource "azurerm_api_management_api" "sample-jsonlink" {
  name                = "sample-jsonlink"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Sample JSON link API"
  path                = "sample-jsonlink"
  protocols           = ["https"]

  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}

module "sample-apis" {
  source = "./modules/apiDefs"

  apim_name           = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.resourceGroup.name

  apiDefs = {
    getVersion = {
      path = "openApiDefs/getVersion.yaml"
    },
    callbackSample = {
      path = "openApiDefs/callback.yaml"
    },
    petstore = {
      path = "openApiDefs/petstore.yaml"
    }
  }
}
