# Use this file to declare the terraform configuration
# Add things like:
# - required version
# - required providers
# Do not add things like:
# - provider configuration
# - backend configuration
# These will be declared in the terraform document which consumes the module.

terraform {
  required_version = "~> 1.7.0"
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "2.20.0"
    }
  }
}
