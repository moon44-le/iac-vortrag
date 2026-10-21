terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 2.2.0"
    }
  }
}

provider "hyperv" {
  # Zwingt den Provider auf den lokalen Rechner
  hostname   = "localhost"
  port       = 5985
  tls        = false
  # Nutzt Standard-Authentifizierung für den lokalen Test
  auth       = "negotiate" # oder "basic" falls negotiate hakt
  transport  = "http"
}

resource "hyperv_network_switch" "private" {
  name                = "Terraform-Demo-Bridge"
  switch_type         = "Internal"
  allow_management_os = true
}