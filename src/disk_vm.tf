resource "yandex_compute_disk" "secondary_disks" {
  for_each = toset(var.secondary_disk_names)

  name = each.value
  zone = var.default_zone
  size = var.disk_size
  type = var.disk_type
}


resource "yandex_compute_instance" "storage" {

name = "vm-from-disks"
platform_id = "standard-v3"
zone = "ru-central1-a"
allow_stopping_for_update = "true"

resources {
cores = 2
memory = 4
}

boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.ubuntu.id
  }
}



dynamic "secondary_disk" {
  for_each = yandex_compute_disk.secondary_disks
  content {
    disk_id = secondary_disk.value.id
  }
}

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}