# Declare variables that can be used. They do not need to be populated...

variable "region" {
  default = "us-west-2"
}

variable "machine_types" {
  type = map(any)
  default = {
    dev  = "t2.micro"
    test = "t2.micro"
    prod = "t2.micro"
  }
}