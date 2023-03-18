  GNU nano 6.2                                                        cloud_init.sh
# installing libguestfs-tools only required once, prior to first run
apt update -y
apt install libguestfs-tools -y
# remove existing image in case last execution did not complete successfully
rm jammy-server-cloudimg-amd64.img
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
qm create 9000 --name "jammy-server-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-zfs
qm set 9000 --scsihw virtio-scsi-single --scsi0 local-zfs:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-zfs:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000
rm jammy-server-cloudimg-amd64.img
echo "done."
echo "..next up, clone VM, then expand the disk"
echo "...you also still need to copy ssh keys to the newly cloned VM"

