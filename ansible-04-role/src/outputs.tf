output "instance_public_ip" {
  description = "Public IP"
  value       = [for vm in yandex_compute_instance.vms : "${vm.hostname} = ${vm.network_interface[0].nat_ip_address}"]
}

output "instance_internal_ip" {
  description = "Internal IP"
  value       = [for vm in yandex_compute_instance.vms : "${vm.hostname} = ${vm.network_interface[0].ip_address}"]
}
