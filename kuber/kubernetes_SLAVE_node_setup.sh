kubernetes_SLAVE_node_setup.sh
##
setenforce 0 #Setting setenforce to 0 effectively sets SELinux to permissive, which effectively disables SELinux until the next reboot 
#disable Selinux permanently
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sleep 1
##firewall-cmd --add-port=<port>/tcp --permanent && firewall-cmd --reload
swapoff -a 
#vi /etc/fstab #how to disable swap on boot: add # to /dev/mapper/cl-swap
yum install -y firewalld 
firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=2379-2380/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=10251/tcp --permanent
firewall-cmd --add-port=10252/tcp --permanent
firewall-cmd --reload
#
#firewall-cmd --add-port=30974/tcp --permanent
#firewall-cmd --add-port=31378/tcp --permanent
#firewall-cmd --add-port=30881/tcp --permanent
#firewall-cmd --add-port=8080-8081/tcp --permanent
#firewall-cmd --reload
#
sleep 1
yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
yum install -y containerd.io docker-ce
systemctl enable docker && systemctl start docker
sleep 1
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
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
sleep 1
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sleep 1
modprobe overlay
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
###########
##THEN join the cluster
##sample "kubeadm join 90.0.1.30:6443 --token sz3hou.klil0gt3y22s5jmd --discovery-token-ca-cert-hash sha256:9d6d04add1d8bd1d385a5c89623bf802c8d71fba9068302c52f1b7435fac378c"