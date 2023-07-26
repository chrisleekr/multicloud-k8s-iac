resource "google_compute_network" "vpc" {
  name                    = "${var.google_project_id}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.google_project_id}-private-subnet"
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.google_region
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = "10.16.0.0/12"
  }

  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = "10.80.0.0/15"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.google_project_id}-router"
  region  = var.google_region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.google_project_id}-nat"
  router = google_compute_router.router.name
  region = var.google_region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat_ip.self_link]
}

resource "google_compute_address" "nat_ip" {
  name         = "${var.google_project_id}-nat-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_address" "load_balancer_ip" {
  name         = "${var.google_project_id}-load-balancer-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
