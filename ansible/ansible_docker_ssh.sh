#WIP#


#ansible_docker_ssh.sh
# HOW TO configure SSH access for Bridge (default) network driver
#configure <inventory> file
[ubuntu]
172.17.0.4 ansible_ssh_user=root ansible_ssh_pass=root
172.17.0.5 ansible_ssh_user=root ansible_ssh_pass=root

[centos]
172.17.0.2 ansible_ssh_user=root ansible_ssh_pass=root
172.17.0.3 ansible_ssh_user=root ansible_ssh_pass=root
#
yum install net-tools -y
yum install openssh-server -y
ssh-keygen -A

#
#ssh enabled image
docker run -d \
	--name centos8_2 -p 0.0.0.0:2222:22 \
	-e ROOT_PASS="root" tutum/centos
#


#setup IPvlan network
#
ip addr show enp0s10
docker network create -d ipvlan \
	--subnet=90.0.1.0/24 \
	-o ipvlan_mode=l2 \
	-o parent=enp0s10 ansible_test_ipvlan \
	#--gateway=0.0.0.0 \


 # Start a container on the db_net network
docker run --net=ansible_test_ipvlan \
 	-itd \
 	--ip 90.0.1.120 \
 	-e ROOT_PASS="root" \
 	tutum/centos