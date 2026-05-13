data "proxmox_virtual_environment_vms" "template" {
  node_name = "pve"
  tags      = []

  filter {
    name   = "name"
    values = ["ubuntu-template"]
  }
}

resource "proxmox_virtual_environment_vm" "moja_vm" {
  name      = "nextjs-server"
  node_name = "pve"
  started   = true
  
  # KLUCZOWA POPRAWKA: Wyłączenie KVM na poziomie konfiguracji
  kvm       = false 

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
    full  = false
  }

  cpu {
    cores = 2
    type  = "qemu64"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/eOJZJzV4dgnK+mLmWUbUZN9l6ar8oxr1P9W1tBwEI jpadlo@student.agh.edu.pl"]
    }
  }
}

output "vm_ip" {
  value = flatten(proxmox_virtual_environment_vm.moja_vm.ipv4_addresses)[0]
}