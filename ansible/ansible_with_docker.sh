#ansible_with_docker.sh
#"https://docs.ansible.com/ansible/latest/collections/community/docker/index.html"
#installing additional modules
ansible --version #2.9.xx from epel-release
	#yum remove ansible
	python3 -m pip uninstall ansible #remove 2.9.xx before installing newer build
	python3 -m pip install setuptools-rust #dependency
		yum upgrade -y
  #dependency
	yum install -y redhat-rpm-config \
  gcc libffi-devel python3-devel openssl-devel
  python3 -m pip install docker docker-compose
  python3 -m pip install ansible #get 4.4.0+ via pip
	    python3 -m pip install --upgrade ansible #or move to up-to-date version
#
##
#ansible-galaxy init
ansible-galaxy collection install community.docker #get docker module
#create dir */root/test
	#inventory-file
	#ansible.cfg
		##
		[defaults]
		inventory = inventory-test #filename
		host_key_checking = false
		deprecation_warnings = false
		remote_user = root
		private_key_file = /root/.ssh/ansible_master
		##...
		##
#
##worker_dependecies1.yml
---
- name: install dependecies
  hosts: test-servers
  remote_user: root
  tasks:
    - name: install docker
      yum:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: present
        update_cache: yes
    - name: install python package manager
      yum:
        name: python3-pip
        state: present
    - name: install python sdk
      become_user: root
      pip:
        name:
          - docker
          - docker-compose
##
#execute
ansible-playbook /root/test/worker_dependencies.yml
	#verify installation on worker-node
	python -m pip list | grep docker && docker --version
#create install_portainer.yml
--- 
- hosts: test-servers
  tasks: 
    - name: Deploy Portainer 
      community.docker.docker_container: 
        name: portainer
        image: portainer/portainer-ce
        ports:
          - "9000:9000"
          - "8000:8000" 
        volumes: 
          - /var/run/docker.sock:/var/run/docker.sock 
          - /portainer_data:/data
        restart_policy: always
#
##Create deploy_watchtower.yml to enable auto-update service for containers
--- 
- hosts: test-servers
  tasks: 
    - name: Deploy Watchtower 
      community.docker.docker_container: 
        name: watchtower
        image: containrrr/watchtower
        command: --schedule "0 0 4 * * *"
        volumes: 
          - /var/run/docker.sock:/var/run/docker.sock 
        restart_policy: always
#
##Create install_wordpress.yml
--- 
- hosts: test-servers
  tasks: 
    - name: Create network 
      community.docker.docker_network: 
        name: wordpress

    - name: Deploy Wordpress
      community.docker.docker_container: 
        name: wordpress
        image: wordpress:latest
        ports:
          - "80:80"
        networks:
          - name: wordpress 
        volumes: 
          - wordpress:/var/www/html
        env: 
          WORDPRESS_DB_HOST: mysql
          WORDPRESS_DB_NAME: wp
          WORDPRESS_DB_USER: wp
          WORDPRESS_DB_PASSWORD: wp_pass
        restart_policy: always 

    - name: Deploy mysql 
      community.docker.docker_container:
        name: mysql_test
        image: mysql:5.7
        networks:
          - name: wordpress
        volumes:
          - wp:/var/lib/mysql
        env:
          MYSQL_USER: wp
          MYSQL_PASSWORD: wp_pass
          MYSQL_DATABASE: wp
          MYSQL_ROOT_PASSWORD: root
        restart_policy: always

    - name: Deploy phpmyadmin
      community.docker.docker_container: 
        name: phpmyadmin
        image: phpmyadmin:latest
        ports: 
          - "8080:80"
        env: 
          PMA_HOST: mysql
#
