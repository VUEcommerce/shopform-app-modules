resource "google_storage_bucket" "bucket" {
  project  = var.project
  location = var.region

  name               = local.name
  storage_class      = var.storage_class
  bucket_policy_only = var.bucket_policy_only

  labels = merge(var.labels,
    {
      name : local.name
      project : var.project_code
      environment : var.environment
    }
  )

  dynamic "encryption" {
    for_each = var.kms_key_name == null ? [] : [{}]
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  versioning {
    enabled = var.versioning
  }

  dynamic "logging" {
    for_each = var.log_bucket == null ? [] : [{}]
    content {
      log_bucket = var.log_bucket
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [{}]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }

}