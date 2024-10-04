module "sample-apis" {
  source = "./modules/apiDefs"

  apim_name           = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.resourceGroup.name

  apiDefs = {
    sample-jsonlink = {
      content_format = "swagger-link-json"
      path           = "http://conferenceapi.azurewebsites.net/?format=json"
    }
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
