terraform {
  required_version = "~> 1.14.0"
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.20"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.2"
    }
  }
}
