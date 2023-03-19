# homelab-k8s-cluster in 10 steps

1. Download the ISO image and install Proxmox VE on your hardware. In five minutes you'll be creating your first virtual machines and containers.

   https://www.proxmox.com/en/proxmox-ve/get-started

2. Clone this repo.

   gitclone https://github.com/tomgolebiewski/homelab-k8s-cluster.git

3. Create a cloud-init image and convert it to a VM template.

   root@pve:~# sh cloudinit.sh

4. Instal Terraform and Ansible on your local machine.

   https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

5. 

