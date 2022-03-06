##install openstack on centos8
#create openstack user
useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo yum install arptables git-core python38 -y
#change user
sudo -u stack -i
#clone installation repo (or stable/victoria for centos8legacy)
git clone --branch stable/xena https://opendev.org/openstack/devstack
#
#git clone --branch stable/xena https://opendev.org/openstack/glance.git
#git clone --branch stable/xena https://opendev.org/openstack/keystone.git
#git clone --branch stable/xena https://opendev.org/openstack/neutron.git
#git clone --branch stable/xena https://opendev.org/openstack/requirements.git
#git clone --branch stable/xena https://opendev.org/openstack/cinder.git
#git clone --branch stable/xena https://opendev.org/openstack/horizon.git
#git clone --branch stable/xena https://opendev.org/openstack/nova.git
#git clone --branch stable/xena https://opendev.org/openstack/placement.git
scp root@90.0.1.98:/home/user/Downloads/git-packages/xena-src.tar.xz /opt/stack
tar xvf xena-src.tar.xz
sudo python3.8 -m pip install --upgrade pip
sed -ie '/^_DEFAULT_PYTHON3_VERSION/ { s/"$(_get_python_version python3)"/3.8/ }' /opt/stack/devstack/stackrc
sed -ie '/export PYTHON3_VERSION/ { s/${PYTHON3_VERSION:-${_DEFAULT_PYTHON3_VERSION:-3}}/3.8/ }' /opt/stack/devstack/stackrc
#add to line 1085: sudo /usr/share/openvswitch/scripts/ovs-ctl start ((file /opt/stack/devstack/stack.sh))
cd devstack
	#generate passwords
	openssl rand -hex 8 
	#used DATABASE_PASSWORD=8cbcb72f952b43c6
	#RABBIT_PASSWORD=486fa8d260122a72
	#SERVICE_PASSWORD=bd429e581edc7851
	#keystone 3b1d36033488d685f9a3632a25ab3c582d6e7c49
rm -rf /opt/stack/devstack/local.conf
cat <<EOF | sudo tee /opt/stack/devstack/local.conf
[[local|localrc]]
ADMIN_PASSWORD=3b1d36033488d685f9a3632a25ab3c582d6e7c49
DATABASE_PASSWORD=8cbcb72f952b43c6
RABBIT_PASSWORD=486fa8d260122a72
SERVICE_PASSWORD=bd429e581edc7851
PIP_UPGRADE=True
HOST_IP=90.0.1.60
#PUBLIC NETWORK CONFIGURATION
Q_USE_PROVIDERNET_FOR_PUBLIC=False
FLOATING_RANGE=90.0.1.0/24
Q_FLOATING_ALLOCATION_POOL="start=90.0.1.150,end=90.0.1.200"
PUBLIC_NETWORK_NAME=external
PUBLIC_NETWORK_GATEWAY=90.0.1.1
PUBLIC_PHYSICAL_NETWORK=public
# Required for l3-agent to connect to external-network-bridge
PUBLIC_BRIDGE=br-ext
#PRIVATE NETWORK CONFIGURATION
EOF
su root
echo 'NETWORK_GATEWAY=${NETWORK_GATEWAY:-15.0.0.1}' >> /opt/stack/devstack/local.conf
echo 'FIXED_RANGE=${FIXED_RANGE:-15.0.0.0/24}' >> /opt/stack/devstack/local.conf
sudo -u stack -i
cd devstack
#change permissions for config path
sudo chmod -R 775 /opt/stack/
#launch installation script
./stack.sh
#