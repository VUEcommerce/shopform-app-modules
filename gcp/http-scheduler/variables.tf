variable "name" {
  type        = string
  description = "Name of Scheduler"
}

variable "description" {
  type        = string
  description = "Description of Scheduler"
  default     = "A http scheduler"
}

variable "schedule" {
  type        = string
  description = "Cron of Scheduler"
}

variable "time_zone" {
  type        = string
  description = "Time zone of Scheduler"
  default     = "Asia/Singapore"
}

variable "attempt_deadline" {
  type        = string
  description = "Time zone of Scheduler"
  default     = "10s"
}

variable "retry_count" {
  type        = number
  description = "Time zone of Scheduler"
  default     = 0
}

variable "min_backoff_duration" {
  type        = string
  description = "Time before next attempt"
  default     = "10s"
}

variable "http_target" {
  description = "Http settings"
  type = object({
    http_method = string
    uri         = string
  })
}

###########################
# Project Variables
###########################

variable "project" {
  description = "The project id for project."
}

variable "region" {
  description = "Region for resource"
}

