resource "yandex_compute_disk" "my_disk" {
  count = var.disk_count
  name  = "disk-${count.index}"
  size     = "1"
  type  = var.disk_type
  zone  = var.zone
  labels = {
    environment = "disk-${count.index}"
  }
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
image_id = var.vms_boot-disk_id
}
}

dynamic secondary_disk {
for_each = "${yandex_compute_disk.my_disk.*.id}"
   content {
        disk_id = yandex_compute_disk.my_disk["${secondary_disk.key}"].id
   }
}


  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.ssh_key}"
  }
}