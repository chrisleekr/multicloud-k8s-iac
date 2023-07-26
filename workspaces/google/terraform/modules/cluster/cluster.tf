data "google_container_engine_versions" "versions" {
  location = var.google_region
  project  = var.google_project_id
}

resource "google_container_cluster" "primary" {
  name     = "${var.google_project_id}-gke"
  location = var.google_region

  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.private_subnet.name


  logging_service    = "none"
  monitoring_service = "none"

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
      enabled = false
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  depends_on = [
    google_container_cluster.primary
  ]

  name       = "${var.google_project_id}-gke-node-pool"
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

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      preemptible = "true"
    }
  }
}
