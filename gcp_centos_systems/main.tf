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
# Create disk for Robin, Todo: make this dynamic only when boolean true for "use_secondary_disk"
# -------------------------

resource "google_compute_disk" "robin_storage" {
  name            = "${var.name_prefix}-robin-storage"
  type            = "pd-standard"
  zone            = var.zone
  size            = 80
  lifecycle {
    prevent_destroy = false
  }
}

# -------------------------
# Create centos instance 
# -------------------------

resource "google_compute_instance" "centos" {
  project             = var.project
  name                = "${var.name_prefix}-centos"
  machine_type        = var.centos_instance_type
  zone                = var.zone
  # Instance labels to apply to the instance
  labels = {
    app = var.app_tag_value
  }
  # tag to use for applying firewall rules 
  tags = var.tag

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.source_image
      size  = var.disk_size
    }
  }

  attached_disk {
    source = google_compute_disk.robin_storage.self_link
  }

  metadata = {
    enable-oslogin = "FALSE"
  }

  network_interface {
    subnetwork = var.subnetwork

    # If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
      nat_ip = var.static_ip
    }
  }

 network_interface {
    subnetwork = var.subnetwork2

    # If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
      nat_ip = var.static_ip2
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  metadata_startup_script  = var.startup_script
     
}