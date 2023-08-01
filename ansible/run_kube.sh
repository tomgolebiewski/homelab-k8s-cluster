echo "Pinging VM..."
ansible -i ansible-hosts.txt  all -u ubuntu -m ping
echo "ok."
sleep 2s
echo "Installing kubernetes dependencies..."
ansible-playbook -i ansible-hosts.txt 001-install-kubernetes-dependencies.yml
echo "done."
sleep 2s
echo "Init cluster..."
ansible-playbook -i ansible-hosts.txt 002-init-cluster.yml
echo "done."
sleep 2s
echo "Get join command..."
ansible-playbook -i ansible-hosts.txt 003-get-join-command.yml
echo "done."
sleep 2s
echo "Join workers..."
ansible-playbook -i ansible-hosts.txt 004-join-workers.yml
sleep 2s
echo "done."
echo "Try ssh ubuntu@<kube-server> and  kubectl get nodes ..."
