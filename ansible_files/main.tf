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
# Setup variables for the Ansible inventory
# -------------------------
resource "local_file" "ansible_inventory_file" {
  content  = templatefile("./templates/ansible_inventory.tpl", {
    gcp_robin1_endpoint                 = var.robin1_endpoint
    gcp_robin2_endpoint                 = var.robin2_endpoint
    gcp_robin3_endpoint                 = var.robin3_endpoint
  })
  filename = "${var.terragrunt_path}/../../ansible/playbooks/inventory/hosts"
}

#Putting F5 inventory specific vars in a separate group vars file. Add for more BIG-IP systems
resource "local_file" "ansible_f5_vars_file" {
  content  = templatefile("./templates/ansible_f5_vars.tpl", {
    gcp_tag_value         = var.app_tag_value
  })
  filename = "${var.terragrunt_path}/../../ansible/playbooks/group_vars/F5_systems"
}