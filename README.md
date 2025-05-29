# Домашнее задание к занятию «Управляющие конструкции в коде Terraform» - Мельник Юрий Александроович 

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

------

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------

### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Теперь пишем красивый код, хардкод значения не допустимы!
------

## Задание 1

1. Изучите проект.
2. Инициализируйте проект, выполните код. 

## Решение 1

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud .
 ![рис 3](https://github.com/ysatii/terraform_hw3/blob/main/img/img_3.jpg)
 ![рис 1](https://github.com/ysatii/terraform_hw3/blob/main/img/img_1.jpg)
 ![рис 2](https://github.com/ysatii/terraform_hw3/blob/main/img/img_2.jpg)
------

## Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  
3. При желании внесите в переменную все возможные параметры.
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
6. Инициализируйте проект, выполните код.

------
## Решение 2

1. Файл  count-vm.tf создан, группа безопастности присвоена
Листинг count-vm.tf 
<details>
  <summary>Нажми, чтобы раскрыть Листинг count-vm.tf</summary>

```

resource "yandex_compute_instance" "count" {
  count = 2
  name        = "web-${count.index+1}"
  zone        = var.default_zone
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
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
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
</details>

 ![рис 3](https://github.com/ysatii/terraform_hw3/blob/main/img/img_3.jpg)
 ![рис 1](https://github.com/ysatii/terraform_hw3/blob/main/img/img_1.jpg)
 ![рис 2](https://github.com/ysatii/terraform_hw3/blob/main/img/img_2.jpg)

2. Создан фай for_each-vm.tf
Листинг for_each-vm.tf
<details>
  <summary>Листинг for_each-vm.tf</summary>

```
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
      image_id = data.yandex_compute_image.ubuntu.id
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
    ssh-keys           = "ubuntu:${local.ssh-keys}"
  }
}


```
</details>

3. Добавлено variables.tf
```
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
```
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
учтено используем 
```
 depends_on = [yandex_compute_instance.count]
```
5. Используем функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 

locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
}

6. Выполняем код
 ![рис 7](https://github.com/ysatii/terraform_hw3/blob/main/img/img_7.jpg)
 ![рис 8](https://github.com/ysatii/terraform_hw3/blob/main/img/img_8.jpg)

## Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

## Решение 3
 Листинг disk_vm.tf
<details>
<summary>Нажми, чтобы раскрыть Листинг disk_vm.tf</summary>

```
resource "yandex_compute_disk" "my_disk" {
  count    = 3
  name     = "disk-name-${count.index}"
  size     = "1"
  type     = "network-ssd"
  zone     = "ru-central1-a"
 

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
image_id = data.yandex_compute_image.ubuntu.id
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
    ssh-keys           = "ubuntu:${local.ssh-keys}"
  }
}
```

</details>  

 ![рис 9](https://github.com/ysatii/terraform_hw3/blob/main/img/img_9.jpg)
 ![рис 10](https://github.com/ysatii/terraform_hw3/blob/main/img/img_10.jpg)
 ![рис 11](https://github.com/ysatii/terraform_hw3/blob/main/img/img_11.jpg)

## Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания переменной hostname(не путать с переменной name)); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае отсутвия перменной hostname - автоматическая генерация имени,  зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.


------
## Решение 4.
Листинг ansible.tf 
```
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    { 
webservers =  yandex_compute_instance.for_each 
databases =  yandex_compute_instance.count
storage =  [yandex_compute_instance.storage]

}  )

  filename = "${abspath(path.module)}/hosts.cfg"
}
```

Листинг hosts.tftpl
```
 [webservers]
%{~ for i in webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} ${i.fqdn}
%{~ endfor ~}


[databases]
%{~ for i in databases ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}  ${i.fqdn}
%{~ endfor ~}


[storage]
%{~ for i in storage ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]}  ${i.fqdn}
%{~ endfor ~}
```

Униччтожим все ресурсы
```
terraform destroy
```

 ![рис 12](https://github.com/ysatii/terraform_hw3/blob/main/img/img_12.jpg)
 ![рис 13](https://github.com/ysatii/terraform_hw3/blob/main/img/img_13.jpg)
 ![рис 14](https://github.com/ysatii/terraform_hw3/blob/main/img/img_14.jpg)
 ![рис 15](https://github.com/ysatii/terraform_hw3/blob/main/img/img_15.jpg)
 ![рис 16](https://github.com/ysatii/terraform_hw3/blob/main/img/img_16.jpg)