terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version =  ">=0.13"
    }
  }
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone

}

# Создаем сервисный аккаунт
resource "yandex_iam_service_account" "diman-diplom" {
  folder_id   = var.folder_id
  name        = "diman-diplom"
  description = "Service account"
}

# Создаем роль "editor"
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.diman-diplom.id}"
  ]
}

# Создаем  роль  "storage-admin"
resource "yandex_resourcemanager_folder_iam_binding" "storage-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.diman-diplom.id}"
  ]
}
# VPC
resource "yandex_vpc_network" "network-diplom" {
  name = "network-diplom"
  folder_id = var.folder_id
}

# Подсети
resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet-d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

# Машинки:
## Kubernetes master
resource "yandex_compute_instance" "vm-master" {
  name = "vm-master"
  hostname = "vm-master"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8n7dushkonnbvt3lpc"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

## Kubernetes worker-1
resource "yandex_compute_instance" "vm-worker-1" {
  name = "vm-worker-1"
  hostname = "vm-worker-1"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8n7dushkonnbvt3lpc"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

## Kubernetes worker-2
resource "yandex_compute_instance" "vm-worker-2" {
  name = "vm-worker-2"
  hostname = "vm-worker-2"
  zone      = "ru-central1-b"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8n7dushkonnbvt3lpc"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

## Kubernetes worker-3
resource "yandex_compute_instance" "vm-worker-3" {
  name = "vm-worker-3"
  hostname = "vm-worker-3"
  zone      = "ru-central1-d"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8n7dushkonnbvt3lpc"
      size = "10"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-d.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

# Создаем хранилище образов  Docker
resource "yandex_container_registry" "docker" {
name = "docker"
folder_id = var.folder_id
labels = {
my-label = "my-label-value"
}
}



