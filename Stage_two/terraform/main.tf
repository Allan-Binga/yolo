terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.0.0"
    }
  }
}

provider "vagrant" {}

resource "vagrant_vm" "simple_vm" {
  vagrantfile_dir = "../" 
  get_ports = true
}

resource "null_resource" "ansible_provision" {
  depends_on = [vagrant_vm.simple_vm]

  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_BECOME_PASS=${var.password} ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml
    EOT
  }
}

output "vm_ip" {
  value = vagrant_vm.simple_vm.network_interface[0].ip_address
}

