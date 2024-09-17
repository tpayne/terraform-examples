module "http-endpoint" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == local.http-endpoint }
  source      = "./modules/http-endpoint"
  resourceObj = each.value.resourceObj
  assertError = var.assertError
}

module "github-repo" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == local.github-repo }
  source      = "./modules/github-repo"
  resourceObj = each.value.resourceObj
  assertError = var.assertError
}

module "gcp-project" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == local.gcp-project }
  source      = "./modules/gcp-project"
  resourceObj = each.value.resourceObj
  assertError = var.assertError
}

module "storage-bucket" {
  for_each    = { for k, v in var.objectsToValidate : k => v if v.resourceType == local.storage-bucket }
  source      = "./modules/storage-bucket"
  resourceObj = each.value.resourceObj
  assertError = var.assertError
}
