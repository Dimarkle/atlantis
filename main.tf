terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
         }
  }
  required_version = ">=0.13"
}
provider "yandex" {
  
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone = var.yc_zone
  }

# Создаем VPC

resource "yandex_vpc_network" "net" {
name = "net"
}

# Подсеть

resource "yandex_vpc_subnet" "subnets" {
  count = length(var.subnet_names)

  name           = var.subnet_names[count.index]
  zone           = var.zones[count.index]
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.cidr_blocks[count.index]]
}


# Virtual machines
resource "yandex_compute_instance" "vms" {
  for_each = var.instances

  name = each.value.name
  hostname = each.value.hostname
  zone = each.value.zone
  platform_id = "standard-v3"

  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = "fd8di2mid9ojikcm93en"
      size     = "30"
    }
  }

 network_interface {
#    subnet_id = each.value.subnet_id    
    subnet_id = yandex_vpc_subnet.subnets[each.value.subnet_id].id
# subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }
}




















