##ansible_roles.sh
#https://docs.ansible.com/ansible/latest/reference_appendices/config.html
#Separating big playbook
#HOW TO create <include>
   - name: Copy configuration files.
     copy:
       src: files/test.conf
       dest: "{{ apache_config_dir }}/test.conf"
 #replace with
   - import_tasks: tasks/copy_task.yml

#contents "tasks/copy_task.yml"
---
- name: Copy configuration files.
  copy:
    src: files/test.conf
    dest: "{{ apache_config_dir }}/test.conf"
#
#Possible scenario
---
- name: Install Apache
  hosts: 
   - centos
   - ubuntu
  become: true

  pre_tasks:
    - import_tasks: pre_tasks/load_vars.yml

  tasks:
    - import_tasks: tasks/apache_install.yml
    # override loaded variable from "load_vars.yml"
      vars:
       - apache_package: apache3
    - debug: var=foo['msg']

    - import_tasks: tasks/copy_task.yml

    - import_tasks: tasks/apache_boot.yml
#USING include tasks for dynamic variables (CHANGES during task execution)
    - include_tasks: tasks/log.yml
    #content
    - name: Check for existing log files in dymanic log_file_paths variable.
      find:
        paths: "{{ item }}"
        patterns: '*.log'
      register: found_log_file_paths
      with_items: "{{ log_file_paths }}"
    #
- import_playbook: playbooks/test_playbook.yml
#
##INTRO
#Package parts of YAML code used for multiple playbooks
---
- name: Install Apache
  hosts: 
   - centos
   - ubuntu
  become: true
  vars_files:
   - vars/apache_default.yml
   - vars/apache_{{ ansible_distribution }}.yml

  tasks:
    - name: Ensure Apache is installed
      package: 
        name: "{{ apache_package }}"
        state: present 
      register: foo
    - debug: var=foo['msg']

    - import_tasks: tasks/copy_task.yml

    - name: Ensure Apache is started now and on boot.
      service: 
        name: "{{ apache_service }}"
        state: started 
        enabled: true
#HOW TO create ansible role
	#possible roles paths: #can be changed via ansible.cfg 'DEFAULT_ROLES_PATH' or env var 'ANSIBLE_ROLES_PATH'
	'./roles' #playbook local path
	'~/.ansible/roles:'
	'/etc/ansible/roles' #global roles path
	'/usr/share/ansible/roles'
mkdir roles
mkdir roles/myrole
#role description file
	#contains dependencies (roles required to run this role)
mkdir roles/myrole/meta
#for yaml scripts
mkdir roles/myrole/tasks
touch ./roles/myrole/tasks/main.yml
#contents
	---
	- name: Ensure Apache is installed
	  package:     
	    name: "{{ apache_package }}"
	    state: present     
	  register: foo
	- debug: var=foo['msg']
	#
touch ./roles/myrole/meta/main.yml
#contents
	---
	dependencies: []
	#
ls -lah ./roles/myrole/
#example playbook #ok
---
- name: Install Apache
  hosts: 
   - centos
   - ubuntu
  become: true
  vars_files:
   - vars/apache_default.yml
   - vars/apache_{{ ansible_distribution }}.yml
  roles:
   - myrole
  tasks:
    - import_tasks: tasks/copy_task.yml
    #TO EXEC at specific step use <include>
    - include_role: myrole

    - name: Ensure Apache is started now and on boot.
      service: 
        name: "{{ apache_service }}"
        state: started 
        enabled: true
#
ansible-playbook install_apache_role.yml
	#role adds ROLE prefix to playbook log:
	#TASK [<role_name> : <task_name>]
#
#create required dir using ansible galaxy
ansible-galaxy role init myrole2
#tree
	myrole2/
	myrole2/.travis.yml
	myrole2/README.md
	myrole2/defaults
	myrole2/defaults/main.yml
	myrole2/files
	myrole2/handlers
	myrole2/handlers/main.yml
	myrole2/meta
	myrole2/meta/main.yml
	myrole2/tasks
	myrole2/tasks/main.yml
	myrole2/templates
	myrole2/tests
	myrole2/tests/inventory
	myrole2/tests/test.yml
	myrole2/vars
	myrole2/vars/main.yml
#
