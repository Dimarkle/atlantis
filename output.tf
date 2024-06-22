
## Outputs
output "internal_ip_address_vm_master" {
value = yandex_compute_instance.vms["master"].network_interface[0].ip_address
}

output "master_ip_address_nat-master" {
value = yandex_compute_instance.vms["master"].fqdn
}


