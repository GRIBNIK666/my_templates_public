##ansible_intro.sh
#install ansible
yum install -y epel-release && yum install -y ansible
#
vi /etc/ansible/hosts #is ANSIBLE INVENTORY
	#create client group with user credentials
	[ansible_client]
	90.0.1.21 ansible_ssh_user=root ansible_ssh_pass=root
	90.0.1.22 ansible_ssh_user=root ansible_ssh_pass=root
#
#creating playbook .yml #is ANSIBLE PLAYBOOK
#check sample.yml
#Verifying playbook
ansible-playbook sample.yml --syntax-check
	#output: playbook: sample.yml - #ok
#execute playbook
ansible-playbook sample.yml
	#master need to be "known_host" for slave nodes
	cd root/.ssh
	ssh-keygen -t rsa -m PEM -f ansible_master
	ssh-copy-id -i ansible_master root@90.0.1.21 
	ssh-copy-id -i ansible_master root@90.0.1.22
##output
#PLAY RECAP **********************************************************************************************
#90.0.1.21                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
#90.0.1.22                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
##
curl localhost #(on slave node) verify result
#Run commands on your hosts
ansible -i inventory-test test1 -m ping -u root
	ansible \
		#specify inventory file <path/file.ext>
		-i inventory-test \ 
		#inventory group
		test1 \
		#module <ping>
		-m ping \
		#executed by user
		-u root
#SET ansible.cfg
[defaults]
inventory = inventory-test
#SET inventory-test (file)
[test1]
90.0.1.21 ansible_ssh_user=root ansible_ssh_pass=root
#then use
ansible test1 -m ping #--ask-pass to provide password
#need to know
#!(spoiler)
	#usage: ansible [-h] [--version] [-v] [-b] [--become-method BECOME_METHOD]
	               [--become-user BECOME_USER] [-K] [-i INVENTORY] [--list-hosts]
	               [-l SUBSET] [-P POLL_INTERVAL] [-B SECONDS] [-o] [-t TREE] [-k]
	               [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER]
	               [-c CONNECTION] [-T TIMEOUT]
	               [--ssh-common-args SSH_COMMON_ARGS]
	               [--sftp-extra-args SFTP_EXTRA_ARGS]
	               [--scp-extra-args SCP_EXTRA_ARGS]
	               [--ssh-extra-args SSH_EXTRA_ARGS] [-C] [--syntax-check] [-D]
	               [-e EXTRA_VARS] [--vault-id VAULT_IDS]
	               [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES]
	               [-f FORKS] [-M MODULE_PATH] [--playbook-dir BASEDIR]
	               [--task-timeout TASK_TIMEOUT] [-a MODULE_ARGS] [-m MODULE_NAME]
	               pattern

		Define and run a single task 'playbook' against a set of hosts

		positional arguments:
		  pattern               host pattern

		optional arguments:
		  --ask-vault-password, --ask-vault-pass
		                        ask for vault password
		  --list-hosts          outputs a list of matching hosts; does not execute
		                        anything else
		  --playbook-dir BASEDIR
		                        Since this tool does not use playbooks, use this as a
		                        substitute playbook directory.This sets the relative
		                        path for many features including roles/ group_vars/
		                        etc.
		  --syntax-check        perform a syntax check on the playbook, but do not
		                        execute it
		  --task-timeout TASK_TIMEOUT
		                        set task timeout limit in seconds, must be positive
		                        integer.
		  --vault-id VAULT_IDS  the vault identity to use
		  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
		                        vault password file
		  --version             show program's version number, config file location,
		                        configured module search path, module location,
		                        executable location and exit
		  -B SECONDS, --background SECONDS
		                        run asynchronously, failing after X seconds
		                        (default=N/A)
		  -C, --check           don't make any changes; instead, try to predict some
		                        of the changes that may occur
		  -D, --diff            when changing (small) files and templates, show the
		                        differences in those files; works great with --check
		  -M MODULE_PATH, --module-path MODULE_PATH
		                        prepend colon-separated path(s) to module library (def
		                        ault=~/.ansible/plugins/modules:/usr/share/ansible/plu
		                        gins/modules)
		  -P POLL_INTERVAL, --poll POLL_INTERVAL
		                        set the poll interval if using -B (default=15)
		  -a MODULE_ARGS, --args MODULE_ARGS
		                        The action's options in space separated k=v format: -a
		                        'opt1=val1 opt2=val2'
		  -e EXTRA_VARS, --extra-vars EXTRA_VARS
		                        set additional variables as key=value or YAML/JSON, if
		                        filename prepend with @
		  -f FORKS, --forks FORKS
		                        specify number of parallel processes to use
		                        (default=5)
		  -h, --help            show this help message and exit
		  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
		                        specify inventory host path or comma separated host
		                        list. --inventory-file is deprecated
		  -l SUBSET, --limit SUBSET
		                        further limit selected hosts to an additional pattern
		  -m MODULE_NAME, --module-name MODULE_NAME
		                        Name of the action to execute (default=command)
		  -o, --one-line        condense output
		  -t TREE, --tree TREE  log output to this directory
		  -v, --verbose         verbose mode (-vvv for more, -vvvv to enable
		                        connection debugging)

		Privilege Escalation Options:
		  control how and which user you become as on target hosts

		  --become-method BECOME_METHOD
		                        privilege escalation method to use (default=sudo), use
		                        `ansible-doc -t become -l` to list valid choices.
		  --become-user BECOME_USER
		                        run operations as this user (default=root)
		  -K, --ask-become-pass
		                        ask for privilege escalation password
		  -b, --become          run operations with become (does not imply password
		                        prompting)

		Connection Options:
		  control as whom and how to connect to hosts

		  --private-key PRIVATE_KEY_FILE, --key-file PRIVATE_KEY_FILE
		                        use this file to authenticate the connection
		  --scp-extra-args SCP_EXTRA_ARGS
		                        specify extra arguments to pass to scp only (e.g. -l)
		  --sftp-extra-args SFTP_EXTRA_ARGS
		                        specify extra arguments to pass to sftp only (e.g. -f,
		                        -l)
		  --ssh-common-args SSH_COMMON_ARGS
		                        specify common arguments to pass to sftp/scp/ssh (e.g.
		                        ProxyCommand)
		  --ssh-extra-args SSH_EXTRA_ARGS
		                        specify extra arguments to pass to ssh only (e.g. -R)
		  -T TIMEOUT, --timeout TIMEOUT
		                        override the connection timeout in seconds
		                        (default=10)
		  -c CONNECTION, --connection CONNECTION
		                        connection type to use (default=smart)
		  -k, --ask-pass        ask for connection password
		  -u REMOTE_USER, --user REMOTE_USER
		                        connect as this user (default=root)
		                        --'
#!(spoiler)
#diplay local inventory file
ansible-inventory --list -i inventory 
#run command against server (ad-hoc)
ansible test1 -a "free -m -t" #ansible <group> "<command>"
	ansible test1 -a "date"
#create playbook101.yml
---
- hosts: test1
  become_user: root
  tasks:
    - name: Ensure service is installed.
      yum: name=firewalld state=present
    - command: docker version
    - shell: |
        if ! rpm -qa |grep -qw firewalld; then
           yum install -y firewalld
    - name: Ensure service is running
      service: name=firewalld state=started enable=yes
#
ansible-playbook playbook101.yml
#setup new inventory
	# Application servers
	[app] 
	90.0.1.21 ansible_ssh_user=root ansible_ssh_pass=root
	90.0.1.22 ansible_ssh_user=root ansible_ssh_pass=root

	# Database servers
	[db]
	90.0.1.21 ansible_ssh_user=root ansible_ssh_pass=root
	# Group has all the servers 
	[multi:children]
	app
	db

	# Variables for all the servers
	[multi:vars]
	ansible_user=root
    #ansible_ssh_private_key_file=~/.ssh/*key
#
#setup new ansible.cfg
	[defaults]
	inventory = inventory
	host_key_checking = false
	deprecation_warnings = false
	remote_user = root
#
ansible multi -a "hostname" -f 1 
	#-f 1 #single threaded query
ansible multi -i inventory -a "df -h" #check disk space
ansible multi -i inventory -a "free -h" #check RAM/swap space
ansible multi -i inventory -a "date" #check date sync
	#ansible multi -i inventory -a "ntpdate -q 0.rhel.pool.ntp.org"
	#OUTPUT: <IP/HOSTNAME> | CHANGED #outputs "changed" due to shell/command
#
ansible multi -i inventory -m "setup" #query server setup
ansible multi 
	-b #become sudo 
	-m yum #module <yum>
	-a "name=firewalld state=present" #mode arguments
	#ansible multi -b -m yum -a "name=firewalld state=present"
#check service state via shell
	#https://docs.ansible.com/ansible/2.5/modules/service_module.html
	#ansible-doc service #get documentation locally
ansible multi -m service -a "name=firewalld state=started enabled=yes"
#restart filewalld service for "multi" group
ansible -i inventory multi -b -a "systemctl restart firewalld" -f 1
#setup mysql user via shell
ansible -i inventory db -b -m mysql_user -a "name=django host=% password=12345 priv=*.* ALL state=present"
#run on single address/matching IPs or inventory group
ansible app -i inventory -a "free -h" \
	--limit "90.0.1.21"
	#--limit app #group
	#--limit "*.21" #matching ip
	ansible app -i inventory -a "free -h" --limit "*.21"
#
'MODULES to look into:
	- user group 
	- yum (package)
	- step ??
	- copy 
	- fetch
	- file 
#'
#running task in background
ansible multi -i inventory -b -a "yum -y update"
	-B 3600 #run in backgroung for 3600 sec
	-P 0 #return nothing on exit
ansible multi -i inventory -b -m 
	async_status -a "jid=851169717136.10950" #return job log
	--limit "90.0.1.22" #from single server (job_id is unique)
#gather server logs
ansible -i inventory multi -b \
	-a "tail -n 10 /var/log/messages"
#in order to pass multiple commands call "shell" module
##default command module doesn't support "|" #folded scaler
ansible -i inventory multi -b \
	 -m shell -a \
	 "tail -n 10 /var/log/messages \
	 | grep ansible-command \
	 | wc -l"
#manage CRON jobs using "cron" module
ansible -i inventory multi \
	-m cron -a "name=<job-name> hour=<hours> job=/path/to/script.sh"
	#manage git using "git" module
	ansible -i inventory multi \
		-m git \
		-a "repo=github_url dest=/opt/app update=yes version=1.2.4"
#add to ansible.cfg to reuse existing SSH connection
	[defaults]
	pipelining = True
#
##Part 3
#Create playbook101-3-2.yml (templates/ansible/sample.yml)
  touch httpd.conf
  touch httpd-vhosts.conf #files mentioned in playbook.yml
#execute playbook
ansible-playbook \
	playbook101-3-2.yml \
	-i inventory \
	-f 1 --limit "*.22"
#verify httpd status
ansible -i inventory app -a "systemctl status httpd"
#
#Part 4 (installing apache solar using ansible YAML files)
#Create main.yml & vars.yml (templates/ansible/sample.yml)
#execute playbook
	ansible-playbook main.yml --syntax-check
	ansible-playbook varls.yml --syntax-check
	ansible-playbook -i inventory main.yml
#
#Part 5
##Create ep4_apache_handler.yml (templates/ansible/sample.yml)
#execute playbook
	ansible-playbook ep4_apache_handler.yml --syntax-check
	# call handler for all cases
	ansible-playbook ep4_apache_handler.yml --force-handlers
	'
	#call handler if file changes
  notify: restart apache 
  #apply to immediately call handlers
  tasks:
    - name: Ensure handlers are flushed immediately.
      meta: flush_handlers 
	'
#
##HOW TO use yamllint
pip3 install yamllint
#verify file by name
yamllint ./playbook101.yml
#or verify all files in subdirs
yamllint .
##create '.yamllint' to define rules #ignore boolean values
---
extends: default

rules:
  truthy:
     allowed-values:
      - 'true'
      - 'false'
      - 'yes'
      - 'no'
#
pip3 install yamllint
#verify using ansible-lint tool
ansible-lint install_apache_multi-distrib.yml
#
##INSTALL molecule
pip3 install molecule
	pip3 install molecule-docker #docker driver
#
cd /<dir>
#create role for molecule testing
molecude init role <name>
#specify driver and instances
vi ./<role-name>/molecule/default/molecule.yml
#add role YAML
vi ./<role-name>/tasks/main.yml
#specify roles and tasks used for testing
vi ./molecule/default/converge.yml
#lauch test based on converge.yml by default
molecule test
