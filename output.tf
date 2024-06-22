
## Outputs
output "internal_ip_address_vm_master" {
  value = yandex_compute_instance.vms["master"].network_interface[0].ip_address
}

output "fqdn_vm_master" {
  value = yandex_compute_instance.vms["master"].fqdn
}
