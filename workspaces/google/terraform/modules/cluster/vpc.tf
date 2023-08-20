resource "google_compute_network" "vpc" {
  depends_on = [
    google_project.project,
    null_resource.wait_for_services_to_be_enabled
  ]

  name                    = "${local.project_id}-vpc"
  project                 = local.project_id
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "private_subnet" {
  depends_on = [
    google_compute_network.vpc
  ]

  name                     = "${local.project_id}-private-subnet"
  project                  = local.project_id
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
  depends_on = [
    google_compute_network.vpc
  ]

  name    = "${local.project_id}-router"
  project = local.project_id
  region  = var.google_region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  depends_on = [
    google_compute_router.router,
    google_compute_address.nat_ip
  ]

  name    = "${local.project_id}-nat"
  project = local.project_id
  router  = google_compute_router.router.name
  region  = var.google_region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat_ip.self_link]
}

resource "google_compute_address" "nat_ip" {
  depends_on = [
    google_compute_network.vpc
  ]

  name         = "${local.project_id}-nat-ip"
  project      = local.project_id
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_address" "load_balancer_ip" {
  depends_on = [
    google_compute_network.vpc
  ]

  name         = "${local.project_id}-load-balancer-ip"
  project      = local.project_id
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}
