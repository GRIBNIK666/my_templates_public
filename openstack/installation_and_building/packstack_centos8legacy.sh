#packstack_centos8legacy.sh
#prerequisites
#network
dnf install network-scripts -y
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network
#installation
dnf update -y
dnf config-manager --enable powertools
dnf install -y centos-release-openstack-xena
dnf install -y openstack-packstack
packstack --allinone
	#
	#configure answers file
	CONFIG_SERVICE_WORKERS=1
	#install with answers file
	packstack --answer-file ~/packstack-answers-20211126-094234.txt
#
vi /etc/selinux/config
#Set SELINUX line to following:
SELINUX=permissive