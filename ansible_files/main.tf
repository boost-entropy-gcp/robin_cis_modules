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
    gcp_F51_public_ip                   = var.bigip1_public_ip
    // gcp_F52_public_ip                   = var.bigip2_public_ip
    // gcp_F53_public_ip                   = var.bigip3_public_ip
    gcp_F51_private_ip                  = var.bigip1_private_ip
    // gcp_F52_private_ip                  = var.bigip2_private_ip
    // gcp_F53_private_ip                  = var.bigip3_private_ip
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