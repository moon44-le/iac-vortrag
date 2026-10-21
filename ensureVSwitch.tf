terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.2.1"
    }
  }
}

provider "hyperv" {
  # Lokaler Modus benötigt keine Remote-Parameter
}

resource "hyperv_network_switch" "private" {
  name                = "Terraform-Demo-Bridge"
  switch_type         = "Internal"
  allow_management_os = true
}