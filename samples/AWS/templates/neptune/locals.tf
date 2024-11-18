locals {
  cidrBlock = "10.2.0.0/16"
  subnets = [
    {
      subnetCidr = "10.2.1.0/24"
      region     = "${local.region}a"
    },
    {
      subnetCidr = "10.2.2.0/24"
      region     = "${local.region}b"
    }
  ]
  region = "eu-west-2"
}
