# Main definition
# provider "consul" {}

data "external" "bdiis" {
  program = ["/bin/python3", "${path.module}/gocdb_parser.py"]
  query   = {}
}

locals {
  service_endpoints = { for v in jsondecode(data.external.bdiis.result.output).SERVICE_ENDPOINT : v["@PRIMARY_KEY"] => {
    key                = v["@PRIMARY_KEY"]
    configuration_item = v.GOCDB_PORTAL_URL
    hostname           = v.HOSTNAME
    sitename           = v.SITENAME
    in_production      = v.IN_PRODUCTION
    scopes             = v.SCOPES
    monitored          = v.NODE_MONITORED
    notifications      = v.NOTIFICATIONS
    country            = v.COUNTRY_NAME
    roc                = v.ROC_NAME
    scopes             = [v.SCOPES.SCOPE]
    }
  }
}

resource "consul_node" "egi" {
  name    = "EGI"
  address = "https://egi.eu"
  meta = {
    "external-node" = "true"
  }
}

resource "consul_service" "top-bdii" {
  # node       = consul_node.sites[each.value.sitename].name
  for_each   = { for i in local.service_endpoints : "${i.sitename}-${i.key}" => i }
  node       = consul_node.egi.name
  address    = each.value.hostname
  port       = 2170
  name       = "top-bdii"
  service_id = "top-bdii_${each.key}"
  tags = concat(
    [each.value.sitename],
    [each.value.roc],
    flatten([each.value.scopes])
  )
  check {
    tls_skip_verify                   = true
    check_id                          = "service:${each.value.sitename}-${each.value.key}"
    name                              = "${each.value.sitename} top bdii check"
    interval                          = "1m0s"
    timeout                           = "20s"
    tcp                               = "${each.value.hostname}:2170"
    notes                             = "${each.value.sitename} TCP check"
    deregister_critical_service_after = "720h0m0s"
    # args     = ["ldapsearch -x -H ldap://egee-bdii.cnaf.infn.it:2170 -b o=infosys '*' modifyTimestamp"]
    # Script checks are not yet available
  }
  meta = {
    primary_key   = each.value.key
    ci            = each.value.configuration_item
    hostname      = each.value.hostname
    sitename      = each.value.sitename
    in_production = each.value.in_production
    monitored     = each.value.monitored
    notifications = each.value.notifications
    country       = each.value.country
    roc           = each.value.roc
  }
}

resource "nomad_job" "consul_esm" {
  jobspec = templatefile("${path.module}/consul-esm.jobspec.hcl", {
    consul_esm_version = var.consul_esm_version,
    # spread over available nodes
    count = 5
  })
  rerun_if_dead = true
}


output "bdiis" {
  value = jsondecode(data.external.bdiis.result.output).SERVICE_ENDPOINT
}


output "service_endpoints" {
  value = { for v in local.service_endpoints : "${v.key}" => v... }
}
