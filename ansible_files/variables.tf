# -------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# -------------------------

variable "terragrunt_path" {
  description = "Path to the terragrunt working directory."
  type        = string
}

variable "zone" {
  description = "The zone to create the F5 in. Must be within the subnetwork region."
  type        = string
}

variable "project" {
  description = "The project to create the F5 in. Must match the subnetwork project."
  type        = string
}

variable "region" {
  description = "The region for provider"
  type        = string
}

variable "app_tag_value" {
  description = "Value for compute instance label."
  type        = string
}

# BIG-IP Variables
variable "bigip1_public_ip" {
  description = "The public IP the first F5 VM instance."
  type        = string
}

variable "bigip2_public_ip" {
  description = "The public IP the second F5 VM instance."
  type        = string
}

variable "bigip3_public_ip" {
  description = "The public IP the third F5 VM instance."
  type        = string
}

variable "bigip1_private_ip" {
  description = "The private IP the first F5 VM instance."
  type        = string
}

variable "bigip2_private_ip" {
  description = "The private IP the first F5 VM instance."
  type        = string
}

variable "bigip3_private_ip" {
  description = "The private IP the first F5 VM instance."
  type        = string
}

#Centos Variables
variable "robin1_endpoint" {
  description = "IP of the first Robin node"
  type        = string
}

variable "robin2_endpoint" {
  description = "IP of the second Robin node"
  type        = string
}

variable "robin3_endpoint" {
  description = "IP of the third Robin node"
  type        = string
}


# GKE Variables
// variable "gke1_cluster_name" {
//   description = "Name of first GKE cluster"
//   type        = string
// }

// variable "gke2_cluster_name" {
//   description = "Name of second GKE cluster"
//   type        = string
// }

// variable "gke3_cluster_name" {
//   description = "Name of third GKE cluster"
//   type        = string
// }

// variable "gke1_endpoint" {
//   description = "IP of the first gke cluster"
//   type        = string
// }

// variable "gke2_endpoint" {
//   description = "IP of the second gke cluster"
//   type        = string
// }

// variable "gke3_endpoint" {
//   description = "IP of the third gke cluster"
//   type        = string
// }


// variable "cluster1_username" {
//   description = "username of first GKE cluster"
//   type        = string
// }

// variable "cluster2_username" {
//   description = "username of second GKE cluster"
//   type        = string
// }

// variable "cluster3_username" {
//   description = "username of third GKE cluster"
//   type        = string
// }

// variable "cluster1_password" {
//   description = "password of first GKE cluster"
//   type        = string
// }

// variable "cluster2_password" {
//   description = "password of second GKE cluster"
//   type        = string
// }

// variable "cluster3_password" {
//   description = "password of third GKE cluster"
//   type        = string
// }