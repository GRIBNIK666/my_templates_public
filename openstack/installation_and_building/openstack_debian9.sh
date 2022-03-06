##install openstack on debian9
#src1:https://www.server-world.info/en/note?os=Debian_9&p=openstack_newton&f=1
#src2:https://docs.openstack.org/newton/install-guide-debian/environment-packages.html
#src3:https://docs.openstack.org/newton/install-guide-debian/environment-security.html
#verify firewall presence
systemctl status firewalld #ufw
	systemctl disable firewalld
#after configuring vm network
	#disable network
	systemctl disable networking.service
	systemctl stop networking.service
	#enable network
	systemctl enable networking.service
	systemctl start networking.service
#
echo "deb http://http.debian.net/debian stretch-backports main contrib" >>/etc/apt/sources.list
echo "deb http://http.debian.net/debian stretch main contrib" >>/etc/apt/sources.list
echo "deb http://http.debian.net/debian stretch-updates main contrib" >>/etc/apt/sources.list
apt update
#dependencies
apt install python3-pip
apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex \
python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test \
libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev python3-dev
apt-get install gcc libpq-dev libssl-dev libffi-dev
pip3 install --upgrade setuptools wheel bcrypt
#install CLIENT
pip3 install python-openstackclient
#configure NTP server
apt install chrony
systemctl enable chronyd
	chronyc tracking
	chronyc sources
#configure SQL DB (MySQL
#remove previous db installations
service mysql stop && apt-get --purge remove "mysql*"
export LC_ALL="en_US.UTF-8"
wget http://repo.mysql.com/mysql-apt-config_0.8.10-1_all.deb
apt install ./mysql-apt-config_0.8.10-1_all.deb
rm -rf /etc/apt/sources.list.d/mysql.list
touch /etc/apt/sources.list.d/mysql.list
cat <<EOF | tee /etc/apt/sources.list.d/mysql.list
# Use command 'dpkg-reconfigure mysql-apt-config' as root for modifications.
deb [trusted=yes] http://repo.mysql.com/apt/debian/ stretch mysql-apt-config
deb [trusted=yes] http://repo.mysql.com/apt/debian/ stretch mysql-8.0
deb [trusted=yes] http://repo.mysql.com/apt/debian/ stretch mysql-tools
deb-src [trusted=yes] http://repo.mysql.com/apt/debian/ stretch mysql-8.0
EOF
apt update
apt-get install mysql-server python-pymysql #used root root
#
rm -rf /etc/mysql/conf.d/openstack.cnf
touch /etc/mysql/conf.d/openstack.cnf
cat <<EOF | tee /etc/mysql/conf.d/openstack.cnf
[mysqld]
bind-address = 90.0.1.50

default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
	#used address bind-address = 90.0.1.50
service mysql restart
#
#
#
#
#
#
#
#
#confgure Rabbit MESSAGE QUEUE service
apt install rabbitmq-server
	#generate rabbit password
	openssl rand -hex 10 
		#used e9e4815ab386b936dfd6
#add rabbit user
rabbitmqctl add_user openstack <RABBIT_PASS>
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
#
#
#
#
#
#
#
#
#
#
#
#
#
#configure memcached service (memory object caching system)
apt install memcached python-memcache
	#set service to use the management IP of the controller node
	sed -i 's/-l 127.0.0.1/-l 90.0.1.50/g' /etc/memcached.conf
service memcached restart
#
#
#
#
#
#
#
#
#
#
#
#configure openstack IDENTITY service
mysql -u root -p
	#provide root password
#create db (execute in db)
CREATE DATABASE keystone;
	#generate database password
	openssl rand -hex 15
		#used e1f2c4b098172c13d15d743be56d18
#grant access(mysql8)
use mysql;
CREATE USER 'keystone'@'localhost' IDENTIFIED BY '<KEYSTONE_DBPASS>';
GRANT ALL ON keystone.* TO 'keystone'@'localhost';
CREATE USER 'keystone'@'%' IDENTIFIED BY '<KEYSTONE_DBPASS>';
GRANT ALL ON keystone.* TO 'keystone'@'%';
flush privileges;
#example: 
		CREATE USER 'keystone'@'localhost' IDENTIFIED BY 'e1f2c4b098172c13d15d743be56d18';
		GRANT ALL ON keystone.* TO 'keystone'@'localhost';
		CREATE USER 'keystone'@'%' IDENTIFIED BY 'e1f2c4b098172c13d15d743be56d18';
		GRANT ALL ON keystone.* TO 'keystone'@'%';
		flush privileges;
#obsolete(mariadb10)
	#GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
	#  IDENTIFIED BY '<KEYSTONE_DBPASS>';
	#GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
	#  IDENTIFIED BY '<KEYSTONE_DBPASS>';
	#example: GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'e1f2c4b098172c13d15d743be56d18';
	#					GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'e1f2c4b098172c13d15d743be56d18';
#configure KEYSTONE service
apt install keystone
	#generate ADMINISTRATION token
	openssl rand -hex 32
		#used 801dd09c8ea444737d78d29bf402159d37328b29e0bb95513dbae782d2fba022
#Edit /etc/keystone/keystone.conf file
	#add after [database]
	connection = mysql+pymysql://keystone:<KEYSTONE_DBPASS>@controller/keystone
		#used e1f2c4b098172c13d15d743be56d18
	#add after [token]
	provider = fernet
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
echo '90.0.1.50 controller' >> /etc/hosts #controller nodeip
#Populate the Identity service database:
rm -rf /var/log/keystone/keystone.log #solves IOError: [Errno 13] Permission denied: '/var/log/keystone/keystone.log'
su -s /bin/sh -c "keystone-manage db_sync" keystone
#
#
#
#
#
#
#
#bootstrap keystone service
keystone-manage bootstrap --bootstrap-password e1f2c4b098172c13d15d743be56d18 \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:35357/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
#
#
#
#
#
#
#
#
##WIP##
#check:https://wiki.autosys.tk/linux_faq/openstack_on_ubuntu_16.04

#iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
#iptables-save
#systemctl daemon-reload


nano /etc/mysql/my.cnf
#change
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
#to
#!includedir /etc/mysql/conf.d/
#!includedir /etc/mysql/mysql.conf.d/



mysql -u root -p
	#provide root password
DROP DATABASE keystone;
#grant access(mysql8)
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'keystone'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'keystone'@'controller';
DROP USER 'keystone'@'%';
QUIT
#create db (execute in db)
CREATE DATABASE keystone;
	#generate database password
	openssl rand -hex 15
		#used e1f2c4b098172c13d15d743be56d18
#grant access(mysql8)
use mysql;
CREATE USER 'keystone'@'%' IDENTIFIED BY 'e1f2c4b098172c13d15d743be56d18';
GRANT ALL ON keystone.* TO 'keystone'@'%';
flush privileges;


CREATE USER 'keystone'@'localhost' IDENTIFIED BY 'secretpass';
GRANT ALL ON keystone.* TO 'keystone'@'localhost';
CREATE USER 'keystone'@'%' IDENTIFIED BY 'secretpass';
GRANT ALL ON keystone.* TO 'keystone'@'%';
FLUSH PRIVILEGES;
#WIP