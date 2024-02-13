module "storagevalidation" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == "storageaccount" }
  source      = "./modules/storageaccount"
  resourceObj = each.value.resourceObj
}

module "mssqlvalidation" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == "mssql" }
  source      = "./modules/mssql"
  resourceObj = each.value.resourceObj
}