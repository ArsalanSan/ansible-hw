####----------------------------
#### Calling the vpc module ####
####----------------------------

module "vpc" {
  source  = "git::https://github.com/ArsalanSan/networks.git"
  name    = var.name
  subnets = local.subnets
}


####----------------------------
####     Create VMs        ####
####----------------------------

resource "yandex_compute_instance" "vms" {

  count = length(var.vm_hostnames)

  name        = var.vm_hostnames["${count.index}"]
  hostname    = var.vm_hostnames["${count.index}"]
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.custom_centos7
      type     = "network-hdd"
      size     = 20
    }
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = module.vpc.subnets_id[0]
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = var.ssh_key
  }

  depends_on = [module.vpc]
}

data "yandex_compute_instance" "clickhouse" {
  name = "clickhouse"
  depends_on = [yandex_compute_instance.vms]
}

data "yandex_compute_instance" "lighthouse" {
  name = "lighthouse"
  depends_on = [yandex_compute_instance.vms]
}

resource "local_file" "ansible_inventory" {
  depends_on = [yandex_compute_instance.vms]
  content    = templatefile("${path.module}/hosts.tftpl",
               { vms = yandex_compute_instance.vms })
  filename   = "${abspath(path.module)}/playbook/inventory/prod.yml"
}

resource "local_file" "ansible_cfg_vector" {
  depends_on = [yandex_compute_instance.vms]
  content    = templatefile("${path.module}/vector.tftpl",
               { clickhouse_ip = data.yandex_compute_instance.clickhouse.network_interface.0.ip_address })
  filename   = "${abspath(path.module)}/playbook/templates/vector.toml.j2"
}

resource "local_file" "web_cfg_lighthouse" {
  depends_on = [yandex_compute_instance.vms]
  content    = templatefile("${path.module}/lighthouse.tftpl",
               { lighthouse_ip = data.yandex_compute_instance.lighthouse.network_interface.0.nat_ip_address })
  filename   = "${abspath(path.module)}/playbook/templates/lighthouse.conf.j2"
}