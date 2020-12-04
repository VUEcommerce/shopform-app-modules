variable "network_name" {
  type        = string
  description = "Name of VPC Network"
}

variable "subnet_name" {
  type        = string
  description = "Name of subnet network"
}

variable "subnet_cidr" {
  type        = string
  description = "IP CIDR Range of Subnet"
}

variable "firewall_name" {
  type        = string
  description = "Name of firewall"
}

variable "connector_name" {
  type        = string
  description = "Serverless connector name"
}

variable "connector_cidr" {
  type        = string
  description = "IP CIDR Range of Connector"
}


variable "enable_logging" {
  description = "This field denotes whether to enable logging for a particular firewall rule"
  default     = false
}

variable "source_ranges" {
  type        = list(string)
  description = "If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply. Only IPv4 is supported"
  default     = []
}

variable "source_service_accounts" {
  type        = list(string)
  description = "If source service accounts are specified, the firewall will apply only to traffic originating from an instance with a service account in this list. Source service accounts cannot be used to control traffic to an instance's external IP address because service accounts are associated with an instance, not an IP address. sourceRanges can be set at the same time as sourceServiceAccounts. If both are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP belongs to an instance with service account listed in sourceServiceAccount. The connection does not need to match both properties for the firewall to apply. sourceServiceAccounts cannot be used at the same time as sourceTags or targetTags"
  default     = []
}

variable "target_service_accounts" {
  type        = list(string)
  description = "A list of service accounts indicating sets of instances located in the network that may make network connections as specified in allowed[]. targetServiceAccounts cannot be used at the same time as targetTags or sourceTags. If neither targetServiceAccounts nor targetTags are specified, the firewall rule applies to all instances on the specified network"
  default     = []
}

variable "source_tags" {
  type        = list(string)
  description = "If source tags are specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. Source tags cannot be used to control traffic to an instance's external IP address. Because tags are associated with an instance, not an IP address. One or both of sourceRanges and sourceTags may be set. If both properties are set, the firewall will apply to traffic that has source IP address within sourceRanges OR the source IP that belongs to a tag listed in the sourceTags property. The connection does not need to match both properties for the firewall to apply"
  default     = []
}

variable "target_tags" {
  type        = list(string)
  description = "A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. If no targetTags are specified, the firewall rule applies to all instances on the specified network."
  default     = []
}

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = {}
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
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

