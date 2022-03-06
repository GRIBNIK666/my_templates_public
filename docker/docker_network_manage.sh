#Creating NETWORK guide
  #creating Overlay network
docker network create \
 -d overlay \ #network type
 myoverlay1 #network name
docker service create \
  --name ApacheTest \ #service name
  --mode global \ #runs on every node
  -d \ #detached mode
  -p 8003:80 \ #external port:container port
  httpd #repo/image-name:tag
sleep 10
#verify avaliability
docker service ls |grep 8003 && curl node1.mydomain:8003 |grep html
#
#Creating service connected to existing network to generate SQL queries
 docker service create \
  --name webapp1 \ #service name
  -d \ #detached mode
  --network myoverlay1 \ #belongs to network
  -p 8001:80 \ #external port:container port
  hshar/webapp #repo/image-name:tag
#Creating service connected to existing network to receive SQL queries
docker service create \
  --name mysql \
  -d \
  --network myoverlay1 \
  -p 3306:3306 \
  hshar/mysql:5.5
#enter MySQL credentials to index.php
  #go to node running webapp1 service
docker ps |grep webapp
docker exec -it <containerid> bash
  nano /var/www/html/index.php
  #edit credentials to
  $servername = "mysql";
  $username = "root";
  $password = "edureka";
  $dbname = "HandsOn";
  $name=$_POST["coursename"];
  $phone=$_POST["courseid"];
  #go to node running MySQL service
docker ps |grep mysql
docker exec -it <containerid> bash
  #login to database
  mysql -u root -pedureka
  #create db and table for testing
  CREATE DATABASE HandsOn;
  USE HandsOn;
  CREATE TABLE courses(coursename VARCHAR(15), courseid VARCHAR(12));
#go to any node running webapp ex.:http://90.0.1.22:8001/
#change amount of containers running for particular service
docker service scale webapp1=6 
#remove unwanted entities))
docker service rm ApacheTest mysql webapp1 
docker system prune && docker volume prune #run for all nodes
