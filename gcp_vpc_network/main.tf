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
# Create the Networks & corresponding Router to attach other resources to
# Networks that preserve the default route are automatically enabled for Private Google Access to GCP services
# provided subnetworks each opt-in; in general, Private Google Access should be the default.
# -------------------------

resource "google_compute_network" "vpc" {
  name    = "${var.name_prefix}-network"
  project = var.project

  # Always define custom subnetworks
  auto_create_subnetworks = "false"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

# This network for the server side resources
resource "google_compute_network" "vpc2" {
  name    = "${var.name_prefix}-network2"
  project = var.project

  # Always define custom subnetworks
  auto_create_subnetworks = "false"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name    = "${var.name_prefix}-router"
  project = var.project
  region  = var.region
  network = google_compute_network.vpc.self_link
}

# -------------------------
# Public Subnetwork Config
# Public internet access for instances with addresses is automatically configured by the default gateway for 0.0.0.0/0
# External access is configured with Cloud NAT, which will serve as the egress NAT gateway for instances without external addresses
# -------------------------

resource "google_compute_subnetwork" "vpc_subnetwork_public" {
  name    = "${var.name_prefix}-subnetwork-public"
  project = var.project
  region  = var.region
  # Specify the self link of the VPC network created earlier
  network = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 0)

  secondary_ip_range {
    range_name = "public-services"
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      0
    )
  }

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router_nat" "vpc_nat" {
  name    = "${var.name_prefix}-nat"
  project = var.project
  region  = var.region
  # Specify the self link of the router created earlier
  router  = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  # "Manually" define the subnetworks for which the NAT is used, so that we can exclude the public subnetwork
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork_public.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# -------------------------
# Private Subnetwork Configs
# -------------------------

resource "google_compute_subnetwork" "vpc_subnetwork_private" {
  name    = "${var.name_prefix}-subnetwork-private"
  project = var.project
  region  = var.region
  # Specify the self link of the VPC network created earlier
  network = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.cidr_subnetwork_width_delta,
    1 * (1 + var.cidr_subnetwork_spacing)
  )

  secondary_ip_range {
    range_name = "private-services"
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      1 * (1 + var.secondary_cidr_subnetwork_spacing)
    )
  }

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# For server side subnetwork
resource "google_compute_subnetwork" "vpc_subnetwork2_private" {
  name    = "${var.name_prefix}-subnetwork2-private"
  project = var.project
  region  = var.region
  # Specify the self link of the VPC network created earlier
  network = google_compute_network.vpc2.self_link
  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr2_block,
    var.cidr_subnetwork_width_delta,
    1 * (1 + var.cidr_subnetwork_spacing)
  )

  secondary_ip_range {
    range_name = "private2-services"
    ip_cidr_range = cidrsubnet(
      var.secondary2_cidr_block,
      var.secondary_cidr_subnetwork_width_delta,
      1 * (1 + var.secondary_cidr_subnetwork_spacing)
    )
  }

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# -------------------------
# Peering between two networks. Both networks must create a peering with each other for the peering to be functional.
# -------------------------

resource "google_compute_network_peering" "peering1" {
  name         = "robinpeering1"
  network      = google_compute_network.vpc.id
  peer_network = google_compute_network.vpc2.id
  
}
resource "google_compute_network_peering" "peering2" {
  name         = "robinpeering2"
  network      = google_compute_network.vpc2.id
  peer_network = google_compute_network.vpc.id
}