terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 2.2.0" # oder deine aktuell verwendete Version
    }
  }
}

provider "hyperv" {
  # Für lokale Ausführung auf dem Hyper-V Server werden 
  # keine Remote-Argumente benötigt. Der Provider greift 
  # direkt auf die lokale WMI/Hyper-V-Schnittstelle zu.
}

resource "hyperv_network_switch" "private" {
  name                = "Terraform-Demo-Bridge"
  switch_type         = "Internal"
  allow_management_os = true
}