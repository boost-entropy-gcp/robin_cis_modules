# -------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# -------------------------

# variable "instance_name" {
#   description = "The name of the VM instance"
#   type        = string
# }

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "subnetwork" {
  description = "A reference (self_link) to the subnetwork to place the centos in"
  type        = string
}

variable "region" {
  description = "The region for provider"
  type        = string
}

variable "zone" {
  description = "The zone to create the centos in. Must be within the subnetwork region."
  type        = string
}

variable "centos_instance_type" {
  description = "The machine type of the instance."
  type        = string
}

variable "project" {
  description = "The project to create the centos in. Must match the subnetwork project."
  type        = string
}

variable "app_tag_value" {
  description = "Value for compute instance label."
  type        = string
}

# -------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# -------------------------

variable "tag" {
  description = "The GCP network tags to apply to the centos for firewall rules."
  type        = list
  default     = ["public", "public-restricted", "private"]
}

variable "source_image" {
  description = "The source image to build the VM using. Enter in the self link here."
  type        = string
  #default     = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20200108"
  default     = "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20200910"
}

variable "disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = number
  default     = null
}

variable "startup_script" {
  description = "The script to be executed when the centos starts. It can be used to install additional software and/or configure the host."
  type        = string
  default     = ""
}

variable "static_ip" {
  description = "A static IP address to attach to the instance. The default will allocate an ephemeral IP."
  type        = string
  default     = null
}
