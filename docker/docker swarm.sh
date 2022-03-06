#use STACK.yml to deploy services for convenience
docker-machine ssh manager1 #connect to master-node
#init master
docker swarm init --advertise-addr <master-node-ip>
#generate token for worker-node, then paste one to remote server
docker swarm join
#ex result: @docker swarm join --token SWMTKN-1-3k66dp4ce5di4j7vgnvv8lyj95klxhb0br15cr25yjb0pf1l2t-05yo8wtwyrftbqh0aqqz1fs09 90.0.1.20:2377@
#
netstat -ntulp | grep dockerd #check ports on master-node
#
#open crucial ports (to manage cluster) on all nodes
firewall-cmd --add-port=2377/tcp --permanent && firewall-cmd --reload
firewall-cmd --add-port=7946/tcp --permanent && firewall-cmd --reload
firewall-cmd --add-port=7946/udp --permanent && firewall-cmd --reload
firewall-cmd --add-port=4789/udp --permanent && firewall-cmd --reload
#
#Verify free ports for Swarm:
#[Port	Protocols	Description]
# 2377	TCP	      Cluster management communications
# 7946	TCP, UDP	Inter-node communication
# 4789	UDP	      Overlay network traffic
# 50	  ESP	      Encrypted IPsec overlay network (ESP) traffic
#
#deploy service-stack on master-node
docker stack deploy -c ./stack.yml wp_stack #docker stack deploy -c((for .yml file)) <path/docker-compose.file> <stack-name>
#
#main commands to overview cluster from master-node
  #list stacks
  docker stack ls
  #would ONLY show container running on current node
  docker ps
  #list services in the stack
  docker stack ps <stack_name>
  #list services in the stack v2
  docker stack services <stack_name>
#
#updating services
docker service ls
    docker service update <servicename>
#
#sample stack.yml
---
services:
    wordpress:
      image: wordpress
      ports:
        - 80:80
      environment:
        WORDPRESS_DB_HOST: mysql
        WORDPRESS_DB_NAME: wp
        WORDPRESS_DB_USER: wp
        WORDPRESS_DB_PASSWORD: wp_pass

    mysql:
        image: mysql:5.7
        environment:
          MYSQL_USER: wp
          MYSQL_PASSWORD: wp_pass
          MYSQL_DATABASE: wp
          MYSQL_ROOT_PASSWORD: root

    phpmyadmin:
      image: phpmyadmin
      ports:
        - 8080:80
        environment:
            PMA_HOST: mysql
version: "3"
##
##