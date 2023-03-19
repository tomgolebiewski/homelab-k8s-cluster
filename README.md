# homelab-k8s-cluster in 10 steps

1. Download the ISO image and install Proxmox VE on your hardware. In five minutes you'll be creating your first virtual machines and containers.

   https://www.proxmox.com/en/proxmox-ve/get-started

2. Clone this repo to your machine.

   gitclone https://github.com/tomgolebiewski/homelab-k8s-cluster.git

3. SSH to your Proxmox server, copy cloudinit.sh script to create a cloud-init image and convert it to a VM template.

   root@pve:~# sh cloudinit.sh

4. Set up terraform user


5. Instal Terraform and Ansible on your local machine.

   https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

6. Set up config data.

7. Create VM machines for your cluster witch Terraform.

8. Build Kubernestes cluster with Ansible.

9. Wait a few minutes and verify nodes in your cluster.

10. Enjoy!

