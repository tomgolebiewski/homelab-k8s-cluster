terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.13"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://<PROXMOX IP>:8006/api2/json" # change this to match your own proxmox
#  pm_api_token_id = [secret]
#  pm_api_token_secret = [secret]
  pm_password = "<password>"
  pm_user = "terraform-prov@pve"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kube-server-0${count.index + 1}"
  desc = "A test for using terraform and cloudinit"
  target_node = "pve"
  # thanks to Brian on YouTube for the vmid tip
  # http://www.youtube.com/channel/UCTbqi6o_0lwdekcp-D6xmWw
  vmid = "40${count.index + 1}"

  clone = "jammy-server-cloudinit-template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = "local-zfs"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
#  network {
#    model = "virtio"
#    bridge = "vmbr20"
#  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.16${count.index + 1}/24,gw=192.168.1.1"
#  ipconfig1 = "ip=10.20.0.1${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-agent" {
  count = 2
  name = "kube-agent-0${count.index + 1}"
  target_node = "pve"
  vmid = "50${count.index + 1}"

  clone = "jammy-server-cloudinit-template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = "local-zfs"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
#  network {
#    model = "virtio"
#    bridge = "vmbr20"
#  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.18${count.index + 1}/24,gw=192.168.1.1"
#  ipconfig1 = "ip=10.20.0.2${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-storage" {
  count = 0
  name = "kube-storage-0${count.index + 1}"
  target_node = "pve"
  vmid = "60${count.index + 1}"

  clone = "jammy-server-cloudinit-template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "40G"
    type = "virtio"
    storage = "local-zfs"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
#  network {
#    model = "virtio"
#    bridge = "vmbr20"
#  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.19${count.index + 1}/24,gw=192.168.1.1"
#  ipconfig1 = "ip=10.20.0.3${count.index + 1}/24"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

