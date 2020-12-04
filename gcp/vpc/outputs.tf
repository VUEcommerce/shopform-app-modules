output "vpc_name" {
  description = "Name of VPC"
  value       = google_compute_network.vpc_network.name
}

output "subnet_name" {
  description = "Name of subnet"
  value       = google_compute_subnetwork.subnet_network.name
}

output "subnet_cidr" {
  description = "CIDR range of subnet used"
  value       = google_compute_subnetwork.subnet_network.ip_cidr_range
}

output "connector_name" {
  description = "Name of connector"
  value       = google_vpc_access_connector.serverless_connector.name
}

output "connector_cidr" {
  description = "CIDR range of connector"
  value       = google_vpc_access_connector.serverless_connector.ip_cidr_range
}

output "firewall_names" {
  description = "All firewall names"
  value       = [for rule in google_compute_firewall.custom : rule.name]
}

output "custom_firewall_names" {
  description = "Custom firewall names"
  value       = [for rule in google_compute_firewall.custom : rule.name]
}