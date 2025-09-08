data "google_container_engine_versions" "versions" {
  depends_on = [
    google_project.project,
    null_resource.wait_for_services_to_be_enabled
  ]

  location = var.google_region
  project  = local.project_id
}

resource "google_container_cluster" "primary" {
  depends_on = [
    google_project.project,
    null_resource.wait_for_services_to_be_enabled
  ]
  name     = "${local.project_id}-gke"
  project  = local.project_id
  location = var.google_region

  resource_labels = {
    "env" = var.environment
  }

  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.private_subnet.name

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  release_channel {
    channel = "STABLE"
  }
  min_master_version = data.google_container_engine_versions.versions.release_channel_default_version.STABLE

  addons_config {


    horizontal_pod_autoscaling {
      disabled = false
    }

    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

    http_load_balancing {
      disabled = true
    }

    network_policy_config {
      disabled = true
    }

    gcp_filestore_csi_driver_config {
      enabled = true
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  # See https://avd.aquasec.com/misconfig/avd-gcp-0056
  network_policy {
    enabled = true
  }

  # See https://avd.aquasec.com/misconfig/avd-gcp-0059
  private_cluster_config {
    enable_private_nodes = true
  }

  # See https://avd.aquasec.com/misconfig/avd-gcp-0061
  # Enabling authorized networks means you can restrict master access to a fixed set of CIDR ranges
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.10.128.0/24"
      display_name = "internal"
    }
  }
}

resource "google_service_account" "gke_node_pool_sa" {
  depends_on = [
    google_container_cluster.primary
  ]
  account_id   = "${local.project_id}-sa"
  display_name = "Service Account"
  project      = local.project_id
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  depends_on = [
    google_container_cluster.primary,
    google_service_account.gke_node_pool_sa

  ]

  name       = "${local.project_id}-gke-node-pool"
  project    = local.project_id
  location   = var.google_region
  cluster    = google_container_cluster.primary.name
  node_count = 1


  autoscaling {
    min_node_count  = 1
    max_node_count  = var.google_node_pool_max_nodes
    location_policy = "ANY"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    # See https://avd.aquasec.com/misconfig/avd-gcp-0054
    image_type = "COS"

    service_account = google_service_account.gke_node_pool_sa.email

    # See https://avd.aquasec.com/misconfig/avd-gcp-0048
    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      preemptible = "true"
    }

    # See https://avd.aquasec.com/misconfig/avd-gcp-0057
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

# Set up logging bucket retention days to 3 days
resource "google_logging_project_bucket_config" "logging_bucket" {
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
  project        = local.project_id
  location       = "global"
  bucket_id      = "_Default"
  retention_days = 3
}
