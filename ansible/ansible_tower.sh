##ansible_tower.info
#Ansible tower is a framework for Ansible. Provides GUI, that reduces the dependency on the command promt window.
-- not present in Self Support Edition.
Consists of:
	#control
		- Control (maintains scheduled and centralized jobs).
		- Job Scheduling.
		- Pull from source control.
		- Visual inventory management.
		- Run-time job promting.
		- Built-in notifications.
		-- Multiple build workflows.
	#knowledge
		- Role-bases access control;
		- Credential security;
		-- Integration with network/enterprise accounts;
		-- Audit trail;
		-- Multi-tenancy;
		-- Logging and Analytics;
	#delegation
		- role-bases access control;
		- push button runs;
		- portal mode;
		-- quickly build forms;
	#support
		-- installation support;
		-- enterprise support;
		-- premium support;
		-- ansible engine bundle;
	#maintenance
	Offers full access to bug fixes and requirements
Features:
- Ansible tower dashboard;
- Real-time job status updates;
- Multi-playbook workflows;
- Logging jobs;
- Scale to ansible tower-cluster;
- Integrates notifications;
- Job scheduling;
- Managing and tracking inventory;
- Self-service;
- Rest API & tower cli control;
- Remote commands execution;
#
#ansible_tower.sh
#
#Update system and add EPEL repository
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible curl #vim
#Download Ansible Tower archive
mkdir /tmp/tower && cd  /tmp/tower
curl -k -O https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz
#Extract downloaded archive
tar xvf ansible-tower-setup-latest.tar.gz
#Install Ansible Tower
cd ansible-tower-setup*/
vi inventory
#Edit inventory file to set required credentials.
#
	...........................
	[tower]
	localhost ansible_connection=local

	[database]

	[all:vars]
	admin_password='AdminPassword'

	pg_host=''
	pg_port=''

	pg_database='awx'
	pg_username='awx'
	pg_password='PgStrongPassword'

	rabbitmq_username=tower
	rabbitmq_password='RabbitmqPassword'
	rabbitmq_cookie=cookiemonster

	# Isolated Tower nodes automatically generate an RSA key for authentication;
	# To disable this behavior, set this value to false
	# isolated_key_generation=true
#
#Start installation
pwd && ./setup.sh
#