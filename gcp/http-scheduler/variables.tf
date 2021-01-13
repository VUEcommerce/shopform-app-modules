variable "name" {
  type        = string
  description = "Name of Scheduler"
}

variable "description" {
  type        = string
  description = "Description of Scheduler"
}

variable "schedule" {
  type        = string
  description = "Cron of Scheduler"
}

variable "time_zone" {
  type        = string
  description = "Time zone of Scheduler"
}

variable "attempt_deadline" {
  type        = string
  description = "Time zone of Scheduler"
}

variable "retry_count" {
  type        = string
  description = "Time zone of Scheduler"
}

variable "http_target" {
  description = "Http settings"
  default     = {}
  type = map(object({
    http_method = string
    uri         = string
  }))
}

###########################
# Project Variables
###########################

variable "project_code" {
  description = "The project code for project."
}

variable "environment" {
  description = "The environment for project. Available types: dev, qa, stg, val, prod."
}

variable "region" {
  description = "Region for resource"
}

