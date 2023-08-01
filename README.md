# homelab-k8s-cluster in 10 steps (step by step)

1. Download, flash and install Proxmox VE on your hardware. In five minutes you'll be creating your first virtual machines and containers.

   https://www.proxmox.com/en/proxmox-ve/get-started

2. Clone this repo to your local machine.
```bash
   git clone https://github.com/tomgolebiewski/homelab-k8s-cluster.git
```
3. SSH to your Proxmox server, copy cloudinit.sh script to create a cloud-init image and convert it to a VM template.

```bash
   sh cloudinit.sh
```
4. Add "terraform_prov" user in Proxmox server.
```bash
   pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.PowerMgmt"
   openssl rand -base64 24 # Create a random password with length 24, if you need
   pveum user add terraform-prov@pve --password "<YOUR_PASSWORD>"
   pveum aclmod / -user terraform-prov@pve -role TerraformProv
```
5. Instal and config Terraform and Ansible on your local machine.

   https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
   https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

6. Set up config data in files for terraform and ansible.
```bash
   cd terrafom
   nano main.tf # set Proxmox user password,IP, you can customize your VMs (IP, CPU, RAM, storage, vmid, etc)  
   ssh-keygen -t rsa -b 4096 -N "" -C "<USERNAME@$DOMAIN>" -m pem -f "<YOUR_KEY>" # generate, if you need new ssh-key
   nano vars.tf # change to your ssh-key
   cd ansible
   nano ansible-hosts.txt # set your VMs IP
   nano ansible-vars.yml # change internal cluster ip cidr if you need
```
7. Create VM machines for your cluster with terraform.
```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
```   
8. Build Kubernestes cluster with ansible.
```bash
   cd ansible
   sh run_kube.sh
```   
9. Wait a few minutes, SSH to your kube server and verify nodes state in your cluster.
```bash
   kubectl version --short
   kubectl get nodes
```
10. Test it
```bash
   kubectl create namespace ha
   nano ha-test.yaml # copy from repo ha-test.yaml
   kubectl apply -f ha-test.yaml -n ha # run first app for testing
```
  Set your browser http://<CLUSTER_IP>:30438

## Enjoy testing Home Assistant in Kubernetes cluster!

Tested with:
1. Proxmox VE 7.4
2. Ubuntu 22.04 jammy-server-cloudimg-amd64.iso
3. Containerd.io 1.6.18
4. Kubeadm, Kubectl, Kubelet 1.27.4
5. Terraform 1.4.2
6. Ansible 2.14.3




