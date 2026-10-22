terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.2.1"
    }
  }
}

provider "hyperv" {
  hostname = "127.0.0.1"
  port     = 5986
  tls      = true
  insecure = true
  auth     = "basic" # oder "negotiate"
  user     = "Administrator"
  password = "deineMudda123"
}

resource "hyperv_network_switch" "private" {
  name                = "Terraform-Demo-Bridge"
  switch_type         = "Internal"
  allow_management_os = true
}