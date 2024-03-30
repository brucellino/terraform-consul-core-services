# Main definition
# provider "consul" {}
data "consul_nodes" "external" {
  query_options {
    datacenter = "dc1"
  }
}

data "external" "bdiis" {
  program = ["/bin/python3", "${path.module}/gocdb_parser.py"]
  query   = {}
}

resource "consul_node" "egi" {
  name    = "EGI"
  address = "https://egi.eu"
  meta = {
    "external-node" = "true"
  }
}

resource "consul_node" "sites" {
  for_each = { for i in local.service_endpoints : "${i.key}" => i }
  name     = each.value.sitename
  address  = each.value.hostname
  meta = {
    "external-node" = "true"
  }
}

resource "consul_service" "goc" {
  for_each = { for i in local.service_endpoints : "${i.key}" => i }
  node     = consul_node.sites[each.value.key].name
  address  = each.value.hostname
  port     = 2170
  name     = "top-bdii"
  tags     = concat([each.value.sitename], [each.value.roc])
  check {
    tls_skip_verify = true
    check_id        = "service:${each.value.sitename}"
    name            = "${each.value.sitename} top bdii check"
    # args     = ["ldapsearch -x -H ldap://egee-bdii.cnaf.infn.it:2170 -b o=infosys '*' modifyTimestamp"]
    # Script checks are not yet available
    interval                          = "1m"
    timeout                           = "20s"
    tcp                               = "${each.value.hostname}:2170"
    notes                             = "${each.value.sitename} TCP check"
    deregister_critical_service_after = "259200000s"
  }
  meta = {
    primary_key   = each.value.key
    ci            = each.value.configuration_item
    hostname      = each.value.hostname
    sitename      = each.value.sitename
    in_production = each.value.in_production
    # { for  s in each.value.scopes : "scope_${s}" => true }
    monitored     = each.value.monitored
    notifications = each.value.notifications
    country       = each.value.country
    roc           = each.value.roc
  }
}

locals {
  sites = [for i in jsondecode(data.external.bdiis.result.output).SERVICE_ENDPOINT :
  { (i.SITENAME) = (i.HOSTNAME) } if i.HOSTNAME != ""]

  service_endpoints = flatten([for v in jsondecode(data.external.bdiis.result.output).SERVICE_ENDPOINT : {
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
    # scopes             = { for k, v in v.SCOPES : k => v }
    }
  ])

}

resource "consul_service" "accounting_portal" {
  name    = "Accounting Portal"
  address = "accounting.egi.eu"
  port    = 8443
  node    = consul_node.egi.name
  check {
    check_id                          = "service:egi_accounting_portal"
    name                              = "EGI Accounting Portal HTTPS"
    status                            = "passing"
    http                              = "https://accounting.egi.eu"
    tls_skip_verify                   = false
    method                            = "GET"
    notes                             = "EGI Accounting portal"
    interval                          = "5s"
    timeout                           = "1s"
    deregister_critical_service_after = "30s"
  }
}

output "bdiis" {
  value = jsondecode(data.external.bdiis.result.output).SERVICE_ENDPOINT
}

output "service_endpoints" {
  value = { for v in local.service_endpoints : "${v.key}" => v... }
}
