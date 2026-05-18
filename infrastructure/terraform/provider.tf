terraform {
  backend "local" {
    path = "/var/jenkins_home/terraform-state/kanye-counter.tfstate"
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

variable "api_token" {
  description = "Proxmox API token"
  sensitive   = true
}

variable "root_password" {
  description = "Hasło root Proxmox SSH"
  sensitive   = true
}

provider "proxmox" {
  endpoint  = "https://172.31.30.52:8006/" 
  api_token = var.api_token
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.root_password
  }
}