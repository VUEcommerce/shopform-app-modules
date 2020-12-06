locals {
  default_user_host        = "%"
  ip_configuration_enabled = length(keys(var.ip_configuration)) > 0 ? true : false

  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }

  users = { for u in var.additional_users : u.name => u }

  // HA method using REGIONAL availability_type requires binary logs to be enabled
  binary_log_enabled = var.availability_type == "REGIONAL" ? true : lookup(var.backup_configuration, "binary_log_enabled", null)
  backups_enabled    = var.availability_type == "REGIONAL" ? true : lookup(var.backup_configuration, "enabled", null)

  env     = var.environment
  project = var.project_code
  region  = var.region
}

resource "random_id" "suffix" {
  count = var.random_instance_name ? 1 : 0

  byte_length = 4
}

resource "google_sql_database_instance" "default" {
  project             = local.project
  region              = local.region
  name                = "${local.env}-${var.instance_name}"
  database_version    = var.database_version
  deletion_protection = var.deletion_protection
  encryption_key_name = var.encryption_key_name

  depends_on = [null_resource.module_depends_on]

  settings {
    tier              = var.database_tier
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    pricing_plan      = var.pricing_plan

    dynamic "backup_configuration" {
      for_each = [var.backup_configuration]
      content {
        binary_log_enabled = local.binary_log_enabled
        enabled            = local.backups_enabled
        start_time         = lookup(backup_configuration.value, "start_time", null)
      }
    }

    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network = lookup(ip_configuration.value, "private_network", null)
        require_ssl     = lookup(ip_configuration.value, "require_ssl", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            name  = apps.value.name
            value = apps.value.network_interface.0.access_config.0.nat_ip
          }
        }
      }

    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }
}

resource "google_sql_database" "default" {
  name       = var.database_name
  project    = local.project
  instance   = google_sql_database_instance.default.name
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource "random_id" "user-password" {
  keepers = {
    name = google_sql_database_instance.default.name
  }

  byte_length = 8
  depends_on  = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource "google_sql_user" "default" {
  name       = var.user_name
  project    = local.project
  instance   = google_sql_database_instance.default.name
  host       = var.user_host
  password   = var.user_password == "" ? random_id.user-password.hex : var.user_password
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource "google_sql_user" "additional_users" {
  for_each   = local.users
  project    = var.project_id
  name       = each.value.name
  password   = lookup(each.value, "password", random_id.user-password.hex)
  host       = lookup(each.value, "host", var.user_host)
  instance   = google_sql_database_instance.default.name
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}