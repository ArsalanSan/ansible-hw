locals {
  subnets = [
    { zone = "${var.zone}", cidr = "10.0.1.0/24" },
    #    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    #    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}
