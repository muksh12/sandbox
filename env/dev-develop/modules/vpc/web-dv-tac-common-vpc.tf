##########################web-dv-tac-common-vpc##########################
resource "google_compute_network" "vpc" {
  name                            = var.network_name1
  routing_mode                    = "GLOBAL"
  mtu                             = 1460
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet1" {
  name                     = var.subnet_name1
  ip_cidr_range            = var.subnet_range1
  network                  = google_compute_network.vpc.self_link
  region                   = "northamerica-northeast1"
  private_ip_google_access = var.private_access1

}

resource "google_compute_subnetwork" "subnet2" {
  name                     = var.subnet_name2
  ip_cidr_range            = var.subnet_range2
  network                  = google_compute_network.vpc.self_link
  region                   = "northamerica-northeast2"
  private_ip_google_access = var.private_access2

}

resource "google_compute_subnetwork" "subnet3" {
  name                     = var.subnet_name3
  ip_cidr_range            = var.subnet_range3
  network                  = google_compute_network.vpc.self_link
  region                   = "northamerica-northeast1"
  private_ip_google_access = var.private_access3

}

resource "google_compute_subnetwork" "subnet4" {
  name                     = var.subnet_name4
  ip_cidr_range            = var.subnet_range4
  network                  = google_compute_network.vpc.self_link
  region                   = "northamerica-northeast2"
  private_ip_google_access = var.private_access4

}

resource "google_compute_subnetwork" "subnet5" {
  name                     = var.subnet_name5
  ip_cidr_range            = var.subnet_range5
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = var.private_access5

}
