#https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#registering-variables
##HOW TO configure remote environment using Ansible
#goto home dir
cd /root && ls -lah
	#looking for:
	.bash_history
	.bash_logout
	.bash_profile
	.bashrc
#
cat .bash_profile
#
##send_env_vars.yml
--- 
- hosts: apache-app
  tasks: 
    - name: Add persistent environment variable to the user shell. 
      lineinfile: 
      # file to edit
        dest: "~/.bash_profile"
      # line to edit:
      	# if exists then replace with CHANGED value
      	# if abscent then add new line
        regexp: '^ENV_VAR='
      # value to add at EOF
        line: 'ENV_VAR=value'
      become: true
     - name: Add system-wide environment variable.
       lineinfile:
         dest: "/etc/environment"
         regexp: '^ENV_VAR='
         line: 'ENV_VAR=value'
       become: true

    - name: Get the value of an ENV variable.
    # catch variable value from file
      shell: 'source ~/.bash_profile && echo $ENV_VAR'
    # save as temporary playbook variable <foo>
      register: foo
    # echo the value from playbook variable
    - debug: msg='The varible is {{ foo.stdout }}'
#
#TASK-based environment setting #1st example
---
- hosts: apache-app

  tasks: 
    - name: Download a file 
      get_url:
       url: 'http://ipv4.download.thinkbroadband.com/20MB.zip'
       dest: /tmp
      environment:
        http_proxy: http://example-proxy:80/
        https_proxy: https://example-proxy:80/
#
#2and example USING VARS
---
- hosts: apache-app

  vars:
    proxy_vars:
      http_proxy: http://example-proxy:80/
      https_proxy: https://example-proxy:80/

  tasks: 
    - name: Download a file 
      get_url:
       url: 'http://ipv4.download.thinkbroadband.com/20MB.zip'
       dest: /tmp
      environment: proxy_vars
#
#Define ENV varible for all tasks in playbook
	# non-persistent
---
- hosts: apache-app
  environment:
    http_proxy: http://example-proxy:80/
    https_proxy: https://example-proxy:80/

  tasks: 
    - name: Download a file 
      get_url:
       url: 'http://ipv4.download.thinkbroadband.com/20MB.zip'
       dest: /tmp
#
#recap on vars examples
---
- hosts: apache-app
  
  vars:
    key: value

  vars_files:
    - vars/vars.yml
    #contents-vars.yml
	---
	key1: value1
	key2: value2
    #contents-vars.yml
#
#HOW TO make playbook cross-compatible
##centos-compatible playbook
	#https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html
	#using ansible built-in variable:
	<ansible_os_family>
	#gathering fact manually
	ansible -i <inventory-file> <group> \
		-m ansible.builtin.setup \
		|grep 'ansible_distribution":'
#create additional files
	mkdir vars
	touch /vars/apache_default.yml
		#
		---
		apache_package: apache2
		apache_service: apache2
		apache_config_dir: /etc/apache2/sites_enabled
		#
	touch /vars/apache_CentOS.yml
		#
		---
		apache_package: httpd
		apache_service: httpd
		apache_config_dir: /etc/httpd/conf.d
		#
	touch inventory-test.yml
		#
		[ubuntu]
		90.0.1.21 ansible_ssh_user=root ansible_ssh_pass=root
		[centos]
		90.0.1.22 ansible_ssh_user=root ansible_ssh_pass=root
	#
#
---
- name: Install Apache
  hosts: 
   - centos
   - ubuntu
  become: true
  
  #1st way to load variables
  vars_files:
   - vars/apache_default.yml
   - vars/apache_{{ ansible_distribution }}.yml
  
  #2nd way to load variables using array
  pre_tasks:
    - debug: var=ansible_os_family
    - debug: var=ansible_distribution

    - name: Load variable files.
      include_vars: "{{ item }}"
      #using loop for loading files
      with_first_found:
      #will load CentOS file on CentOS, otherwise default
       - "vars/apache_{{ ansible_distribution }}.yml"
       - "vars/apache_default.yml"

  tasks:
    - name: Ensure Apache is installed
      package: 
        name: "{{ apache_package }}"
        state: present 
      register: foo
    #output collected facts
    - debug: var=foo
    #output specific value from facts
    - debug: var=foo.msg
    #output specific value from facts
    - debug: var=foo['msg']

    - import_tasks: tasks/copy_task.yml

    - name: Ensure Apache is started now and on boot.
      service: 
        name: "{{ apache_service }}"
        state: started 
        enabled: true
      #add tags to task
      tags:
       - api
       - echo
      ##USING CONDITIONS for playbook execution
      when: <>
      changed_when: <>
      failed_when: <>
      ignore_errors: true #false #won't stop if error occurs
#exec
ansible-playbook install_apache_multi-distrib.yml
  #ansible -i inventory-test all -a 'yum remove httpd -y'
#
