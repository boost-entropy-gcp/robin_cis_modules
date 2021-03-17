
# -------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# -------------------------

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "project" {
  description = "The project ID for the network"
  type        = string
}

variable "region" {
  description = "The region for subnetworks in the network"
  type        = string
}


variable "local_network" {
  description = "A reference (self_link) to the local_network"
  type        = string
}

variable "peer_network" {
  description = "A reference (self_link) to the peer_network"
  type        = string
}