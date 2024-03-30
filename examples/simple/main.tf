# This is the default example
# customise it as you see fit for your example usage of your module

# add provider configurations here, for example:
# provider "aws" {
#
# }

# Declare your backends and other terraform configuration here
# This is an example for using the consul backend.
terraform {
  backend "consul" {
    path = "terraform-core-services/simple"
  }
}


module "example" {
  source = "../../"
}

output "test" {
  value = module.example.service_endpoints
}
