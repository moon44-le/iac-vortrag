terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.2"
    }
  }
}

provider "hyperv" {
  host     = "172.28.31.79"
  port     = 5986
  https    = false
  insecure = true # Nur für Testumgebungen empfohlen
  user     = "Administrator"
  password = "deineMudda123"
}

# Deklaration des virtuellen Switches
resource "hyperv_network_switch" "private" {
  name                = "vSwitch-Private"
  switch_type         = "Private"
  net_adapter_names   = ["Ethernet"]
  allow_management_os = true
  notes               = "Erstellt via Terraform"
}