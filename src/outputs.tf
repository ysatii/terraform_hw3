output "ubuntu_image_id" {
  description = "ID последнего доступного образа Ubuntu"
  value       = data.yandex_compute_image.ubuntu.id
}

