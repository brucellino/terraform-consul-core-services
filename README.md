[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/terraform-consul-core-services/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/terraform-consul-core-services/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Terraform Consul Core Services

This is a terraform module for registering core services of your choice as external services in a Consul catalog, so that they are discoverable by other agents in the cluster.


## Pre-commit hooks


The [pre-commit](https://pre-commit.com) framework is used to manage pre-commit hooks for this repository.
A few well-known hooks are provided to cover correctness, security and safety in terraform.

## Examples

The `examples/` directory contains the example usage of this module.
These examples show how to use the module in your project, and are also use for testing in CI/CD.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | ~> 2.20 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3 |
| <a name="requirement_nomad"></a> [nomad](#requirement\_nomad) | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_consul"></a> [consul](#provider\_consul) | 2.20.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.3 |
| <a name="provider_nomad"></a> [nomad](#provider\_nomad) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [consul_node.egi](https://registry.terraform.io/providers/hashicorp/consul/2.20.0/docs/resources/node) | resource |
| [consul_node.sites](https://registry.terraform.io/providers/hashicorp/consul/2.20.0/docs/resources/node) | resource |
| [consul_service.accounting_portal](https://registry.terraform.io/providers/hashicorp/consul/2.20.0/docs/resources/service) | resource |
| [consul_service.goc](https://registry.terraform.io/providers/hashicorp/consul/2.20.0/docs/resources/service) | resource |
| [consul_nodes.external](https://registry.terraform.io/providers/hashicorp/consul/2.20.0/docs/data-sources/nodes) | data source |
| [external_external.bdiis](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_consul_esm_version"></a> [consul\_esm\_version](#input\_consul\_esm\_version) | variables.tf Use this file to declare the variables that the module will use. | `string` | `"0.7.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bdiis"></a> [bdiis](#output\_bdiis) | n/a |
| <a name="output_service_endpoints"></a> [service\_endpoints](#output\_service\_endpoints) | n/a |
<!-- END_TF_DOCS -->
