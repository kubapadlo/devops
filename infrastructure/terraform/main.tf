data "proxmox_virtual_environment_vms" "template" {
  node_name = "pve"
  filter {
    name   = "name"
    values = ["ubuntu-template"]
  }
}

resource "proxmox_virtual_environment_vm" "moja_vm" {
  name      = "nextjs-server"
  node_name = "pve"
  
  started   = true 

  clone {
    vm_id = 9000
    full  = true
    retries = 2
  }

  cpu {
    cores = 2
    type  = "host"
  }

  disk {
    datastore_id = "local-lvm"  
    interface    = "scsi0"
    size         = 10            
  }

  memory {
    dedicated = 2048
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # To jest kluczowe dla pobierania IP przez Jenkinsa
  agent {
    enabled = true
    timeout = "15m"
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
  value = try(
    [for addr in flatten(proxmox_virtual_environment_vm.moja_vm.ipv4_addresses) : 
      addr if addr != "127.0.0.1" && !can(regex(":", addr))
    ][0], 
    ""
  )
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.moja_vm.vm_id
}