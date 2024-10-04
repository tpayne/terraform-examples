resource "azurerm_api_management_api" "apis" {
  for_each            = { for k, v in var.apiDefs : k => v }
  name                = each.key
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  revision            = "1"
  display_name        = "${each.key} Sample Local YAML API"
  path                = each.key
  protocols           = each.value.protocol

  import {
    content_format = each.value.content_format
    content_value  = (strcontains(each.value.content_format, "link")) ? each.value.path : file("${each.value.path}")
  }
}

