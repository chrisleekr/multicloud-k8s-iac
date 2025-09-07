resource "random_id" "project_suffix" {
  keepers = {
    project_name = var.google_cluster_name
  }

  byte_length = 4
}


locals {
  project_id = "${var.google_cluster_name}-${random_id.project_suffix.hex}"

  activate_apis = [
    "cloudidentity.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}

resource "google_project" "project" {
  name            = var.google_cluster_name
  project_id      = local.project_id
  org_id          = var.google_org_id
  billing_account = var.google_billing_account_id

  # See https://avd.aquasec.com/misconfig/avd-gcp-0010
  # The default network which is provided for a project contains multiple insecure firewall rules which allow ingress to the project’s infrastructure. Creation of this network should therefore be disabled.
  auto_create_network = false
}


resource "null_resource" "enable_service_usage_api" {
  depends_on = [
    google_project.project
  ]

  provisioner "local-exec" {
    command = <<EOF
      gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com --project ${local.project_id}

      while true; do
        STATUS=$(gcloud services list --project ${local.project_id} --filter="config.name:serviceusage.googleapis.com" --format="value(state)")
        if [ "$STATUS" == "ENABLED" ]; then
          echo "Service serviceusage.googleapis.com is enabled"
          break
        else
          echo "Waiting for service serviceusage.googleapis.com to be enabled"
          sleep 10
        fi
      done
    EOF
  }
}

resource "google_project_service" "activate_apis" {
  depends_on = [
    google_project.project,
    null_resource.enable_service_usage_api
  ]

  count = length(local.activate_apis)

  project = google_project.project.id
  service = local.activate_apis[count.index]

  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "null_resource" "wait_for_services_to_be_enabled" {
  depends_on = [
    google_project_service.activate_apis
  ]
}
