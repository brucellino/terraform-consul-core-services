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
