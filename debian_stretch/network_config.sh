#network_config.sh
##
#SAMPLE '/etc/network/interfaces'
	auto lo
	iface lo inet loopback
	pre-up /sbin/iptables-restore < /var/lib/iptables/rules

	allow-hotplug eth1
	iface eth1 inet static
	address IP
	netmask 255.255.255.X
	hwaddress ether 00:E0:4C:A2:C4:48
	network Х.Х.Х.0
	broadcast Х.Х.Х.255
	gateway Х.Х.Х.Х 
	dns-nameservers Х.Х.Х.X Х.Х.Х.Х
	up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.17.254 eth0
	auto eth1

	iface eth0 inet static
	address 192.168.Х.Х
	netmask 255.255.255.0
	up route add -net 10.0.10.0 netmask 255.255.255.0 gw 10.0.0.1 dev $IFACE
	up route add -net 10.0.20.0 netmask 255.255.255.0 gw 10.0.0.1 dev $IFACE
	up echo Interface $IFACE going up | /usr/bin/logger -t ifup
	down echo Interface $IFACE going down | /usr/bin/logger -t ifdown
	auto eth0
EOF
##
ip addr
#temporary config
sudo ifconfig eth1 90.0.1.10 up netmask 255.255.255.0 broadcast 0.0.0.0
#sudo ufw allow ssh #doesnt work
#persistent settings
cd /etc/network
cp interfaces interfaces.backuproot
#if you want to configure interfaces using script /etc/init.d/networking - then replace allow-hotplug to auto

#configure localnat interface
echo 'allow-hotplug eth1' >> /etc/network/interfaces
echo 'iface eth1 inet static' >> /etc/network/interfaces.d/eth1
echo 'address 90.0.1.10/24' >> /etc/network/interfaces.d/eth1
echo 'netmask 255.255.255.0' >> /etc/network/interfaces.d/eth1
	echo 'gateway 0.0.0.0' >> /etc/network/interfaces.d/eth1
ifup eth1
service networking restart
