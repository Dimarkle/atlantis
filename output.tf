
## Outputs
output "internal_ip_address_master" {
value = yandex_compute_instance.vms["master"].network_interface[0].ip_address
}

output "master_ip_address_nat-master" {
value = yandex_compute_instance.vms["master"].fqdn
}


output "internal-ip-address_worker-1" {
value = yandex_compute_instance.vms["worker-1"].network_interface[0].ip_address
}



