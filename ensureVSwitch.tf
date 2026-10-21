terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.2.1"
    }
  }
}

provider "hyperv" {
  uri      = "https://127.0.0.1:5986/wsman"
  user     = "Administrator"
  password = "deineMudda123" # Dein aktuelles Administrator-Passwort einsetzen
  https    = true
  insecure = true # Erlaubt das selbstsignierte Zertifikat
}

resource "hyperv_network_switch" "private" {
  name                = "Terraform-Demo-Bridge"
  switch_type         = "Internal"
  allow_management_os = true
}