output "centos_instance" {
  description = "A reference (self_link) to the centos host's VM instance"
  value       = google_compute_instance.centos.self_link
}

output "centos_public_ip" {
  description = "The public IP of the centos instance."
  value       = google_compute_instance.centos.network_interface[0].access_config[0].nat_ip
}

output "centos_private_ip" {
  description = "The private IP of the centos instance."
  value       = google_compute_instance.centos.network_interface[0].network_ip
}

output "app_tag_value" {
  description = "The tag of the centos instance."
  value       = google_compute_instance.centos.tags
}