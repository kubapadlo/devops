# 1. Definicja danych - TEGO BRAKOWAŁO W TWOIM OSTATNIM BUILDZIE
data "proxmox_virtual_environment_vms" "template" {
  node_name = "pve"
  filter {
    name   = "name"
    values = ["ubuntu-template"]
  }
}

# 2. Definicja Maszyny Wirtualnej
resource "proxmox_virtual_environment_vm" "moja_vm" {
  name      = "nextjs-server"
  node_name = "pve"
  
  # WAŻNE: Musi być false, bo Proxmox nie odpali jej z domyślnym KVM
  started   = false 

  clone {
    # Referencja do bloku data powyżej
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

# 3. Skrypt naprawczy KVM i startujący maszynę
resource "null_resource" "fix_kvm_and_start" {
  depends_on = [proxmox_virtual_environment_vm.moja_vm]

  connection {
    type     = "ssh"
    host     = "192.168.56.101"
    user     = "root"
    password = var.root_password
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wyłączam KVM dla VM ${proxmox_virtual_environment_vm.moja_vm.vm_id}...'",
      "qm set ${proxmox_virtual_environment_vm.moja_vm.vm_id} --kvm 0",
      "echo 'Startuję maszynę...'",
      "qm start ${proxmox_virtual_environment_vm.moja_vm.vm_id}"
    ]
  }
}

# 4. Outputy dla Jenkinsa
output "vm_ip" {
  value = flatten(proxmox_virtual_environment_vm.moja_vm.ipv4_addresses)[0]
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.moja_vm.vm_id
}