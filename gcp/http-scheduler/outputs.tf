output "name" {
  description = "Name of scheduler"
  value       = google_cloud_scheduler_job.job.name
}

output "schedule" {
  description = "Schedule of scheduler"
  value       = google_cloud_scheduler_job.job.schedule
}

output "http_target_uri" {
  description = "Uri of scheduler"
  value       = google_cloud_scheduler_job.job.http_target
}