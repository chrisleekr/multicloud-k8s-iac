terraform {
  required_version = ">= 1.13.1"

  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = ">= 2.3.2"
    }
  }
}
