terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
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
  endpoint  = "https://192.168.56.101:8006/"
  api_token = var.api_token
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = var.root_password
  }
}