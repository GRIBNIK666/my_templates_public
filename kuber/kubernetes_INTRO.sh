#"https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/" docs
#check mac address
ip link
	##cube-master 08:00:27:8c:b6:02
	##kube-node1 08:00:27:d3:ea:61
	##kube-node2 08:00:27:e8:93:2e
	
#check product_uuid
cat /sys/class/dmi/id/product_uuid

#Next, disable Selinux, as this is required to allow containers to access the host filesystem
setenforce 0 #Setting setenforce to 0 effectively sets SELinux to permissive, which effectively disables SELinux until the next reboot
	#disable Selinux permanently
	sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

#open kube ports on master and workers
yum install -y firewalld
##firewall-cmd --add-port=<port>/tcp --permanent && firewall-cmd --reload
firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=2379-2380/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=10251/tcp --permanent
firewall-cmd --add-port=10252/tcp --permanent
firewall-cmd --reload

#install docker-ce
yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
yum install -y containerd.io docker-ce
systemctl enable docker && systemctl start docker
#add kubernetes repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
#install k8s
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet #--now (to also start/stop unit)

#master init
kubeadm init --pod-network-cidr=<networkCNI> --apiserver-advertise-address=<masternodeIP>
	#for --pod-network choose CNI (container network interface):
	#- calico 192.168.0.0/16 or flannel 10.244.0.0/16
	#both use /16 mask 255.255.0.0

#change container runtime to systemd (docker is default)

	#containerd preinstall jobs
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
	# Setup required sysctl params, these persist across reboots.
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
	#configure containerd
	sudo mkdir -p /etc/containerd
	containerd config default | sudo tee /etc/containerd/config.toml
	vi /etc/containerd/config.toml
#	[plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
#		[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          #runtime_type = "io.containerd.runc.v2"
#add line SystemdCgroup = true<<
	#then restart containerd
systemctl restart containerd
#disabling swap is NOT OPTIONAL
swapoff -a 

#NOW after removing errors, run master init line ABOVE
#then create Kube config
 mkdir -p $HOME/.kube
 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 sudo chown $(id -u):$(id -g) $HOME/.kube/config

 #Apply latest container network interface Config (flannel config CASE)
kubectl apply -f https://docs.projectcalico.org/manifests/canal.yaml
	##result cube-master.mydomain   Ready    control-plane,master   4h57m   v1.21.3
#Create Kubernetes Dashboard
firewall-cmd --add-port=8001/tcp --permanent && firewall-cmd --reload
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
#start dashboard proxy
kubectl proxy --address='90.0.1.30' --accept-hosts='^localhost$,^127.0.0.1$,^90.0.1.2$,^10.244.0.0$,^[::1]$' --disable-filter=true --port=8001
#check avalibility
curl http://90.0.1.30:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
##go to kubernetes_SERVICE_DASHBOARD.sh for user configuration
#kubernetes_logs.sh
kubectl logs -f \
	-l k8s-app=test-deployment \
	--prefix=true
#