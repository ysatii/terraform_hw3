resource "yandex_compute_disk" "default" {
  count    = 3
  name     = "disk-name-${count.index}"
  size     = "1"
  type     = "network-ssd"
  zone     = "ru-central1-a"
 

  labels = {
    environment = "disk-${count.index}"
  }
}