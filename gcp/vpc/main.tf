#-----------------#
# Local variables #
#-----------------#
locals {
  env     = var.environment
  project = var.project_code
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name    = var.network_name
  mtu     = 1500
  project = local.project
}

resource "google_compute_subnetwork" "subnet_network" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc_network.id

  region  = local.region
  project = local.project

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 1.0
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_vpc_access_connector" "serverless_connector" {
  name          = var.connector_name
  region        = local.region
  ip_cidr_range = var.connector_cidr
  network       = google_compute_subnetwork.subnet_network.name
}

resource "google_compute_firewall" "custom" {
  for_each = var.custom_rules
  project  = local.project

  name                    = "${var.firewall_name}-${each.key}"
  description             = each.value.description
  direction               = each.value.direction
  network                 = google_compute_network.vpc_network.name
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.use_service_accounts || each.value.direction == "EGRESS" ? null : each.value.sources
  source_service_accounts = each.value.use_service_accounts && each.value.direction == "INGRESS" ? each.value.sources : null
  target_tags             = each.value.use_service_accounts ? null : each.value.targets
  target_service_accounts = each.value.use_service_accounts ? each.value.targets : null
  disabled                = lookup(each.value.extra_attributes, "disabled", false)
  priority                = lookup(each.value.extra_attributes, "priority", 1000)
  enable_logging          = lookup(each.value.extra_attributes, "enable_logging", null)

  dynamic "allow" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "allow"]

    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }

  dynamic "deny" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "deny"]

    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}
