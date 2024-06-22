

variable "cloud_id" {
  type        = string
  default     = "b1g73ga4p1hchrvctbgo"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gcms0oj5ro6jjsgqdg"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "var.zone" {
  default = "ru-central1-a"
}

variable "subnet_names" {
  type    = list(string)
  default = ["subnet-a", "subnet-b", "subnet-d"]
}

variable "zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
}

variable "instances" {
  type = map(object({
    name      = string
    hostname  = string
    zone      = string
    cores     = number
    memory    = number
    subnet_id = number
  }))
  default = {
    "vm-master"  = { name = "master", hostname = "master", zone = "ru-central1-a", cores = 4, memory = 4, subnet_id = 0 },
    "vm-worker-1" = { name = "worker-1", hostname = "worker-1", zone = "ru-central1-a", cores = 4, memory = 4, subnet_id = 0 },
    "vm-worker-2" = { name = "worker-2", hostname = "worker-2", zone = "ru-central1-b", cores = 4, memory = 4, subnet_id = 1 },
    "vm-worker-3" = { name = "worker-3", hostname = "worker-3", zone = "ru-central1-d", cores = 4, memory = 4, subnet_id = 2 },
  }
}
