module "storagevalidation" {
  for_each    = { for k,v in var.objectsToValidate : k => v if v.resourceType == "storageaccount" }
  source      = "./modules/storageaccount"
  resourceObj = each.value.resourceObj
}