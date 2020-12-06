variable "database_name" {
  type        = string
  description = "Name of database"
}

variable "instance_name" {
  type        = string
  description = "Name of database instance"
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

# % for access from any ip
variable "user_host" {
  description = "The host for the default user"
  type        = string
  default     = "%"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "database_version" {
  type        = string
  description = "Version of database e.g. MYSQL_5_7, POSTGRES_11"
}

variable "database_tier" {
  type        = string
  description = "Instance tier used for database"
  default     = "db-n1-highmem-4"
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "availability_type" {
  description = "The availability type for the master instance. Can be either `REGIONAL` or `ZONAL`."
  type        = string
  default     = "ZONAL"
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance e.g. PD_SSD, PD_HDD"
  type        = string
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  type        = string
  default     = "PER_USE"
}

# start_time in HH:MM format
variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    binary_log_enabled = bool
    enabled            = bool
    start_time         = string
  })
  default = {
    binary_log_enabled = false
    enabled            = false
    start_time         = null
    location           = null
  }
}

variable "ip_configuration" {
  description = "The ip_configuration settings subblock"
  type = object({
    authorized_networks = list(map(string))
    ipv4_enabled        = bool
    private_network     = string
    require_ssl         = bool
  })
  default = {
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = null
  }
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "additional_users" {
  description = "A list of users to be created in your cluster"
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
  default = []
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