##############################web-dv-tac-common-vpc############################
output "network" {
  value = google_compute_network.vpc.name
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "subnet-name1" {
  value = google_compute_subnetwork.subnet1.name
}

output "subnet1-range" {
  value = "google_compute_subnetwork.subnet1.ip_cidr_range"
}

output "subnet-name2" {
  value = google_compute_subnetwork.subnet2.name
}

output "subnet2-range" {
  value = "google_compute_subnetwork.subnet2.ip_cidr_range"
}

output "subnet-name3" {
  value = google_compute_subnetwork.subnet3.name
}

output "subnet3-range" {
  value = "google_compute_subnetwork.subnet3.ip_cidr_range"
}

output "subnet-name4" {
  value = google_compute_subnetwork.subnet4.name
}

output "subnet4-range" {
  value = "google_compute_subnetwork.subnet4.ip_cidr_range"
}

output "subnet-name5" {
  value = google_compute_subnetwork.subnet5.name
}

output "subnet5-range" {
  value = "google_compute_subnetwork.subnet5.ip_cidr_range"
}
