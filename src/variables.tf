variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/8nl4RWFm+0oXUDpUSjuOP3AHCl2E/af1CpzwhtO6 lamer@lamer-VirtualBox"
  description = "ssh-keygen -t ed25519"
}

#variable "vms_boot-disk_id" {
#  type        = string
#  default     = "fd8aus3bfglr6dg9hsbk"
#  description = "https://yandex.cloud/ru/docs/compute/operations/images-with-pre-installed-software/get-list"
# }

variable "token" {
  description = "IAM token for Yandex Cloud"
  type        = string
}

variable "cloud_id" {
  description = "Yandex Cloud cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "wm_resources" {
  type        = list(object({ vm_name=string, cpu=number, ram=number, disk_size=number, core_fraction=number, disk_volume=number}))
  default     = [
    {vm_name="main", 
     cpu=2, 
     ram=4, 
     disk_size=10
     core_fraction=5
     disk_volume=1

},
    {vm_name="replica", 
     cpu=2, 
     ram=2, 
     disk_size=20
     core_fraction=5
     disk_volume=1
  }
]
}

variable "disk_count" {
  type        = number
  description = "Количество создаваемых дисков"
  default     = 3
}

variable "disk_type" {
  type        = string
  description = "Тип дисков (например, network-ssd)"
  default     = "network-ssd"
}

variable "zone" {
  type        = string
  description = "Зона размещения дисков"
  default     = "ru-central1-a"
}

variable "ssh_key" {
  type        = string
  description = "Публичный SSH-ключ для доступа к ВМ"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/8nl4RWFm+0oXUDpUSjuOP3AHCl2E/af1CpzwhtO6 lamer@lamer-VirtualBox"
}

variable "secondary_disk_names" {
  description = "Список имён дополнительных дисков"
  type        = list(string)
}

 

variable "disk_size" {
  description = "Размер дисков в GB"
  type        = number
  default     = 1
}


data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
