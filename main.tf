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
  }




# Создаем VPC

resource "yandex_vpc_network" "net" {
name = "net"
}

# Подсеть
resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet-d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}



# Virtual machines
## Kubernetes master
resource "yandex_compute_instance" "master" {
  name = "master"
  hostname = "master"
  zone      = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8di2mid9ojikcm93en"
      size = "30"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
  }

  scheduling_policy { preemptible = false }

## Kubernetes worker-1
resource "yandex_compute_instance" "worker-1" {
  name = "worker-1"
  hostname = "worker-1"
  zone      = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8di2mid9ojikcm93en"
      size = "30"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
  }

  scheduling_policy { preemptible = false }

## Kubernetes worker-2
resource "yandex_compute_instance" "worker-2" {
  name = "worker-2"
  hostname = "worker-2"
  zone      = "ru-central1-b"
  platform_id = "standard-v1"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8di2mid9ojikcm93en"
      size = "30"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
  }

  scheduling_policy { preemptible = false }

## Kubernetes worker-3
resource "yandex_compute_instance" "worker-3" {
  name = "worker-3"
  hostname = "worker-3"
  zone      = "ru-central1-d"
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8di2mid9ojikcm93en"
      size = "30"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-d.id
    nat       = true
  }

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
  }

  scheduling_policy { preemptible = false }

 }

















