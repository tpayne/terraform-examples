locals {
  cidrBlock = "10.2.0.0/16"
  subnets = [
    {
      subnetCidr = "10.2.1.0/24"
      region     = "eu-west-2a"
    },
    {
      subnetCidr = "10.2.2.0/24"
      region     = "eu-west-2b"
    }
  ]
  region = "eu-west-2"
}
