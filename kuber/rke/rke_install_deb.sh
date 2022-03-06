#rke_install_deb.sh
#src1:https://github.com/rancher/rke/releases/
#src2:https://github.com/odytrice/kubernetes/blob/master/rke.md
mkdir -p /opt/rke && cd /opt/rke 
wget 'https://github.com/rancher/rke/releases/download/v'<version>'/rke_linux-amd64' #'<version>'=1.3.1
mv rke_linux-amd64 rke
chmod +x rke
./rke --version
#create the Cluster Configuration File 'cluster.yml' (use full_cluster.yml or base_cluster.yml)
./rke config --name cluster.yml
#generate key foreach node
ssh-keygen -t rsa -m PEM -f ~/.ssh/id_rsa
#download to repo #version=2.6.1
wget 'https://github.com/rancher/rancher/releases/download/v2.6.3/rancher-images.txt' \ 
wget 'https://github.com/rancher/rancher/releases/download/v2.6.3/rancher-save-images.sh' \ 
wget 'https://github.com/rancher/rancher/releases/download/v2.6.3/rancher-load-images.sh' \ 
echo 'downloaded' \ 
chmod +x rancher-save-images.sh rancher-load-images.sh
#save images from rancher-images.txt to overlay2 and create rancher-images.tar.gz
./rancher-save-images.sh --image-list ./rancher-images.txt
#populate registry from rancher-images.tar.gz
./rancher-load-images.sh --image-list ./rancher-images.txt --registry localhost:5000 #deb-repo.localdomain.local:5000
#add repo to cluster.yml
private_registries:
  - url: 90.0.1.77:5000
    user: root
    password: root
    is_default: true
#add docker dns servers to fix error: Error response from daemon: read /etc/resolv.conf: is a directory
cat /etc/resolv.conf
rm -rf /etc/resolv.conf
cat <<EOF | tee /etc/resolv.conf
nameserver 192.168.2.1
nameserver 8.8.8.8
nameserver 8.8.8.4
EOF
#add cluster ssh keys to every client
ssh-copy-id -i /root/.ssh/id_rsa root@90.0.1.70
...
ssh-copy-id -i /root/.ssh/id_rsa root@90.0.1.72
#remove kube services if exists
./rke remove
      #kubeadm reset
      #apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* -y
      #apt-get autoremove -y
      #rm -rf ~/.kube
#sync time on local nodes if ntp is not present
timedatectl set-timezone Europe/Moscow
date --set="$(ssh root@90.0.1.77 date)"
#on localnodes
docker network create --driver=bridge --subnet=10.43.0.0/16 br0_rke #workaround for: "Failed to get job complete status for job rke-network-plugin-deploy-job in namespace kube-system"
#TRY to)) initialize new cluster (requires "rke" binary and "cluster.yml" file in workdir)
./rke up
#copy generated (by rke) cluster config
ssh user@90.0.1.70 mkdir /home/user/.kube/
ssh user@90.0.1.71 mkdir /home/user/.kube/
ssh user@90.0.1.72 mkdir /home/user/.kube/
scp /opt/rke/kube_config_cluster.yml user@90.0.1.70:/home/user/.kube/config
scp /opt/rke/kube_config_cluster.yml user@90.0.1.71:/home/user/.kube/config
scp /opt/rke/kube_config_cluster.yml user@90.0.1.72:/home/user/.kube/config
ssh user@90.0.1.70 chmod 775 /home/user/.kube/config
ssh user@90.0.1.71 chmod 775 /home/user/.kube/config
ssh user@90.0.1.72 chmod 775 /home/user/.kube/config
########