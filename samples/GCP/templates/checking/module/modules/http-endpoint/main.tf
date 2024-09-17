locals {
  response_codes = [
    200,
    201,
    203,
    204,
    205,
    206,
    207,
    208,
    226
  ]
  codesToCheck = [
    "200",
    "201",
    "203",
    "204",
    "205",
    "206",
    "207",
    "208",
    "226"
  ]
}

// Assert checks
//
check "assertCheckHTTPS" {
  data "terracurl_request" "toCheckHTTPS" {
    name           = "toCheckHTTPS"
    url            = var.resourceObj
    method         = "GET"
    response_codes = local.response_codes
  }

  assert {
    condition = alltrue([
      contains(local.codesToCheck, data.terracurl_request.toCheckHTTPS.status_code)
    ])
    error_message = "${var.resourceObj} returned an unhealthy status code"
  }
}

//
// Error check
//
data "terracurl_request" "toErrorHTTPS" {
  count          = (var.assertError) ? 1 : 0
  name           = "toErrorHTTPS"
  url            = var.resourceObj
  method         = "GET"
  response_codes = local.response_codes

  lifecycle {
    postcondition {
      condition = alltrue([
        contains(local.codesToCheck, self.status_code)
      ])
      error_message = "${var.resourceObj} returned an unhealthy status code"
    }
  }
}
