#ansible_kubernetes.info
##
	#other templates
	#https://github.com/learnitguide/kubernetes-and-ansible.git
cd /root/ansible-kubectl
#Ensure that dependecies are installed (ansible/ansible_with_docker.sh>>installing additional modules)
#1) Add current cluster nodes to /etc/hosts #
cat /etc/hosts
	#contents
	90.0.1.30 cube-master.mydomain
	90.0.1.31 cube-node1.mydomain
	90.0.1.32 cube-node2.mydomain
	90.0.1.33 cube-node3.mydomain
	#
cat /root/ansible-kubectl/inventory
	#contents
	[master]
	cube-master.mydomain ansible_ssh_user=root ansible_ssh_pass=root

	[app]
	cube-node1.mydomain ansible_ssh_user=root ansible_ssh_pass=root
	cube-node2.mydomain ansible_ssh_user=root ansible_ssh_pass=root
	cube-node3.mydomain ansible_ssh_user=root ansible_ssh_pass=root
	#
ansible -i inventory all \
	-m shell \
	-a \
	'cat /etc/hosts |grep cube'
ansible -i inventory all \
	-m shell \
	-a \
	"echo '<ip> <hostname>' >> /etc/hosts"
	#or use copy/get_url modules
#2) Ensure that nodes are reachable between each other
ansible -i inventory all \
	-m shell \
	-a \
	'ping -c 1 90.0.1.31 && ping -c 1 90.0.1.32 && ping -c 1 90.0.1.33'|grep packet

#Optional) Clone other templates to master-node local dir
yum install git-core -y &&\
git clone 'https://github.com/learnitguide/kubernetes-and-ansible.git'

#3) Add master-node public to authorized_keys for every node
	#on master-node
cd /root/.ssh
ssh-keygen -t rsa -m PEM -f kube-key
cat /root/.ssh/kube-key.pub
ansible -i /root/ansible-kubectl/inventory all \
	-m shell \
	-a \
	"echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCazsXbyNFXdpq7Dn3UpjlMippFSrvyJ1F6iiL6SdX5LKiesaf09H0/1sYWdkdcZQSd37cspSpkt2mJ3TuRRsh6U2nQ6sh8/nktgTPgsn54qrHTkNWapYG+bywigO1RRX7/CQ2VuydQmusQ2WUj+hJdS8uGWQMAl1tSxmvhIZCULHP2k1Q2kKOI97BslI5t4bDqmT2PtSWhyqnCYKuzJMGajCzzVyWktjx4V5LSIytyEbakYAC2upAYnWt1xyNZLHimUbQi3iq7+g8wFJjB9sI2dY67dqYeqgkWI14HvOPRF1iSKkhmVaUjymTuBDqzSCRbUB3TCGgy6WRlkUFm/GEADKa5cnQIUtZp+zSNiuSgDajZ7E97bNZ3Tsy3G3YB3hMR8huk3WV6LO7AlsQZItdpGoJP+jx91gEuZGik+/kAR1+uOBPsrDHtw8X6Qqv6lXZhw6/MSGq+WBNjjF/itcfzv/+j9QUU0nTRkyFGQUm5WEznHfnq/YFrPdXQAoTSRdk= root@cube-master.mydomain' >> /root/.ssh/authorized_keys"

#Optinal) Setup kubernetes cluster /templates/kubernetes_INTRO.sh, kubernetes_SLAVE_node_setup.sh
# or use playbooks included at "kubernetes-and-ansible" dir

#4) Verify inventory
cat /root/ansible-kubectl inventory
kubectl get nodes

#Optional) Deploy sample deployment and service
##httpd-deployment.yml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: my-apache-deployment
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: my-apache
    spec:
      containers:
      - name: my-apache-container1
        image: httpd
        ports:
        - containerPort: 80
#EOF

##httpd-service.yml
apiVersion: v1
kind: Service
metadata:
  name: my-apache-service
spec:
  selector:
    app: my-apache
  type: LoadBalancer
  ports:
    - name: my-apache-port
      port: 8080
      targetPort: 80
#EOF
