###cloud vars

variable "public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ/8nl4RWFm+0oXUDpUSjuOP3AHCl2E/af1CpzwhtO6 lamer@lamer-VirtualBox"
}


variable "cloud_id" {
  type        = string
  default         = "b1ggavufohr5p1bfj10e"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default         = "b1g0hcgpsog92sjluneq"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}