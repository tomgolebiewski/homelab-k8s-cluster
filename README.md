# homelab-k8s-cluster in 10 steps (step by step)

1. Download, flash and install Proxmox VE on your hardware. In five minutes you'll be creating your first virtual machines and containers.

   https://www.proxmox.com/en/proxmox-ve/get-started

2. Clone this repo to your local machine.
```bash
   ~$: gitclone https://github.com/tomgolebiewski/homelab-k8s-cluster.git
```
3. SSH to your Proxmox server, copy cloudinit.sh script to create a cloud-init image and convert it to a VM template.

```bash
   root@pve:~#sh cloudinit.sh
```
4. Add "terraform_prov" user in Proxmox server.
```bash
   root@pve:~# pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.PowerMgmt"
   root@pve:~# pveum user add terraform-prov@pve --password "your password"
   root@pve:~# pveum aclmod / -user terraform-prov@pve -role TerraformProv
```
5. Instal and config Terraform and Ansible on your local machine.

   https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

6. Set up config data in files for terraform and ansible.
```bash
   ~$: cd terrafom
   ~$: nano main.tf # set password,numer of VMs, IP, vmid, etc  
   ~$: ssh-keygen -t rsa -b 4096 -N "" -C "<USERNAME@$DOMAIN>" -m pem -f "PRIVATE_KEY" # generate, if you need new ssh-key
   ~$: nano vars.tf # change to your ssh-key
   ~$: cd ansible
   ~$: nano ansible-hosts.txt # set your network IP
   ~$: nano ansible-vars.yml # change cluster ip cidr if you want
```
7. Create VM machines for your cluster witch terraform.
```bash
   ~$: cd terraform
   ~$: terraform init
   ~$: terraform plan
   ~$: terraform apply
```   
8. Build Kubernestes cluster with ansible.
```bash
   ~$: cd ansible
   ~$: ansible-playbook -i ansible-hosts.txt 001-install-kubernetes-dependencies.yml
   ~$: ansible-playbook -i ansible-hosts.txt 002-init-cluster.yml
   ~$: ansible-playbook -i ansible-hosts.txt 003-get-join-command.yml
   ~$: ansible-playbook -i ansible-hosts.txt 004-join-workers.yml
  ```   
9. Wait a few minutes, SSH to your kube server and verify nodes state in your cluster.
```bash
   ~$: kubectl version --short
   ~$: kubectl get nodes
```
10. Enjoy!

