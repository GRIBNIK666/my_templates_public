#ansible_tutorial_playbook.sh
#installing lamp stack using ansible:
	- installing apache server
	- installing php
	- installing mysql
#deploying website:
	- hosting a website on apache server
	- using mysql and php to insert and store data entries from webpage
#
#Create inventory (/etc/ansible/hosts)
[test-servers]
#90.0.1.21
node2.mydomain ansible_ssh_user=root ansible_ssh_pass=root

#HOW TO check ANSIBLE INVENTORY state
vi etc/ansible/ansible.cfg
#set 
[defaults]
host_key_checking = false
#if failed to
ansible -m ping '<inventory_name' #desired result: <node> | SUCCESS
#
#Provisioning playbook
	#repo:"templates.git"/ansible/sample.yml
	#Creating lampstack.yml
	###########
#works on ubuntu
---
- name: install apache & php & mysql #playbook name
  hosts: test-servers #inventory
  become: true #executing as SU
  become_user: root #using root specifically
  gather_facts: true #
  tasks: 
     - name: "install apache2" #installing software
       package: name=apache2 state=present
     - name: "install apach2-php5"
       package: name=libapache2-mod-php state=present
     - name: "install php-cli"
       package: name=php-cli state=present
     - name: "install php-mcrypt"
       package: name=php-mcrypt state=present
     - name: "install php-gd"
       package: name=php-gd state=present
     - name: "install php-mysql"
       package: name=php-mysql state=present
     - name: "install mysql server"
       package: name=mysql-server state=present
#
##Creating mysqlmodule.yml
---
- hosts: all 
  remote_user: root

  tasks:
   - name: install "pip"
     apt: name=python-pip state=present
   - name: install "libmysqlclient-dev"
     apt: name=libmysqlclient-dev state=present
   - name: install the Python MySQLB module
     pip: name=MySQL-python
   - name: Create database user edureka 
     mysql_user: user=edureka password=edureka priv=*.*:ALL state=present
   - name: Create database edu
     mysql_db: db=edu state=present
   - name: Create a Table reg
     command: mysql -u edureka -pedureka -e 'CREATE TABLE reg (name varchar(30), email(varchar(30));' edu
#
##Creating deploywebsite.yml
---
- name: copy play
  hosts: test-servers
  become: true
  become_user: root
  gather_facts: true
  tasks: 
     - name: "copy file"
       copy: src=/home/root/Documents/index.html dest=/var/www/html/index.html
     - name: "copy file"
       copy: src=/home/root/Documents/process.php dest=/var/www/html/process.php
     - name: "copy file"
       copy: src=/home/root/Documents/result.php dest=/var/www/html/result.php 
#
