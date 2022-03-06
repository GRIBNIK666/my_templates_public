#fetch device name
ip addr
nmtui #centos networkconfig ui
#
#D key for delete, I key for insert, ESC to stop editing
#:; key + SHIFT to leave editor 
#		THEN type "wq" after : to save changes
#		type "q!" after : to leave without saving
#
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3 #adapter config by device-name
#
#after altering settings manage network svc
systemctl restart NetworkManager.service 
#
#enable/disable network connectivity
	#dependency
	yum install net-tools
nmcli networking off(on) 
#enable disable adapter
ifconfig <adapter> up #or <down<
#temporarily assign ip, need 
ifconfig <adapter> 90.0.1.2 netmask 255.255.255.0 broadcast 90.0.1.255
	yum install net-tools #dependency
#
ping - $ ping -c 5 google.com
#list adapters
ifconfig -a 
#
#add virtual network switch (virbr0 adapter)
yum install libvirt
	chkconfig libvirtd ff
	systemctl disable libvirtd.service
#
#then edit hostname
	hostnamectl set-hostname <name>
#in order to access by HOSTNAME inside vlan, add lines to /etc/hosts 
echo "<ip><blank_><hostname>" >> /etc/hosts
#resolve DNS-name into ip-address
	#dependency
	yum install bind-utils
nslookup "<dns-name>"
#