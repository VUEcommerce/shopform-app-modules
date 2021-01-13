#-----------------#
# Local variables #
#-----------------#
locals {
  project = var.project_code
  region  = var.region
}

resource "google_cloud_scheduler_job" "job" {
  name             = var.name
  description      = var.description
  schedule         = var.schedule
  time_zone        = var.time_zone
  attempt_deadline = var.attempt_deadline

  retry_config {
    retry_count          = 1
    min_backoff_duration = var.min_backoff_duration
  }

  http_target {
    http_method = var.http_target.http_method
    uri         = var.http_target.uri
  }

  project = var.project
  region  = var.region
}
