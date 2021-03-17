# Configure the Google Cloud provider
provider "google" {
  project     = var.project
  region      = var.region
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}

  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

# -------------------------
# Peering between two networks. Both networks must create a peering with each other for the peering to be functional.
# -------------------------

resource "google_compute_network_peering" "peering1" {
  name         = "${var.prefix}-peering1"
  network      = var.local_network
  peer_network = var.peer_network
  
}
resource "google_compute_network_peering" "peering2" {
  name         = "${var.prefix}-peering2"
  network      = var.peer_network
  peer_network = var.local_network
}