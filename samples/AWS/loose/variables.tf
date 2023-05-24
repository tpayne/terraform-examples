# Declare variables that can be used. They do not need to be populated...

variable "region" {
  default = "eu-west-2"
}

variable "machine_types" {
  type = map(any)
  default = {
    dev  = "t2.micro"
    test = "t2.micro"
    prod = "t2.micro"
  }
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "cidr_lists" {
  description = "List of subnet cidrs"
  type        = list(string)
  default = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24",
    "10.1.4.0/24"
  ]
}

variable "subnet_list" {
  description = "List of subnets"
  type = list(object({
    name = string
    cidr = string
  }))
  default = [
    {
      name = "subnet1"
      cidr = "10.1.5.0/24"
    },
    {
      name = "subnet2"
      cidr = "10.1.6.0/24"
    },
    {
      name = "subnet3"
      cidr = "10.1.7.0/24"
    },
    {
      name = "subnet4"
      cidr = "10.1.8.0/24"
    }
  ]
}
