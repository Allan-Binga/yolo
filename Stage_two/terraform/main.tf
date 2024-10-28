# terraform/main.tf
terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.0.0"
    }
  }
}

provider "vagrant" {}

variable "vagrantfile_dir" {
  description = "Directory containing the Vagrantfile"
  type        = string
  default     = "../"
}

resource "vagrant_vm" "server_vm" {
  vagrantfile_dir = var.vagrantfile_dir
  get_ports       = true
}

resource "null_resource" "ansible_provision" {
  depends_on = [vagrant_vm.server_vm]

  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_BECOME_PASS=${var.become_password} ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

output "machine_names" {
  value = vagrant_vm.server_vm.machine_names
}

output "ssh_config" {
  value = vagrant_vm.server_vm.ssh_config
}

output "ports" {
  value = vagrant_vm.server_vm.ports
}
