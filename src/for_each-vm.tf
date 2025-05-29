resource "yandex_compute_instance" "for_each" {

  depends_on = [yandex_compute_instance.count]

  for_each = {for env in var.wm_resources : env.vm_name => env}
  platform_id = "standard-v1"
  name = each.value.vm_name
  
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
}     
  boot_disk {
    initialize_params {
      image_id = var.vms_boot-disk_id
      size = each.value.disk_size
    }
  }

    scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [ 
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}

output "SSH"{
value = local.ssh_key
}