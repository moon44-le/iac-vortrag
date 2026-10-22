terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "~> 1.2.0"
    }
  }
}
 
provider "hyperv" {
  user     = var.hyperv_user
  password = var.hyperv_password
  host     = "127.0.0.1"
  port     = 5985
  https    = false
  insecure = true
  use_ntlm = true
  timeout  = "30s"
}
 
variable "hyperv_user" {}
 
variable "hyperv_password" {
  sensitive = true
}
 
variable "switch_name" {
  default = "MeinSwitch"
}
 
variable "vm_ordner" {
  default = "C:\\VMs"
}
 
# variable "vorlage" {
#  default = "C:\\Vorlagen\\vorlage.vhdx"
#}
 
resource "hyperv_vhd" "disk" {
  count     = 3
  path      = "${var.vm_ordner}\\server-${count.index + 1}.vhdx"
  size_bytes = 68719476736 # Entspricht 60 GB (60 * 1024 * 1024 * 1024)
  
}
 
resource "hyperv_machine_instance" "server" {
  count                = 3
  name                 = "server-${count.index + 1}"
  generation           = 2
  processor_count      = 2
  static_memory        = true
  memory_startup_bytes = 2147483648
 
  network_adaptors {
    name        = "netzwerk"
    switch_name = var.switch_name
  }
 
  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = 0
    controller_location = 0
    path                = hyperv_vhd.disk[count.index].path
  }
}