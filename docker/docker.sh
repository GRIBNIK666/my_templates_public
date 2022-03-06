#INSTALLATION
#remove old ver)
sudo yum remove docker-ce \
                  docker-ce-cli \
                  containerd.io
#
    yum install -y yum-utils #dependency
bash -c "yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo"
#Install Docker Engine
yum install -y docker-ce docker-ce-cli containerd.io --allowerasing #regular install
	#yum list docker-ce --showduplicates | sort -r (show versions)
	#yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
systemctl start docker
docker version
#after install
docker version 
systemctl start docker #start docker daemon
##
    #adding linux group and user
    groupadd docker
    usermod -aG docker user #usermod -aG(ADD to GROUP) <group> <username>
    id -g docker #call to check
#managing images
docker rmi -f <imageid> #docker rmi(remove image) -f(forced option) <imageid>
#
#docker run <imagename> <cmd>
    docker run alpine <echo "Hello world">
    docker run --name <container_name> <image_name> <cmd> (start with custom name)
#managing containers
docker ps #show running detached containers
docker ps -a #all containers
docker container rename <containerid> <new_containername>
#start/stop/pause container
    docker stop <containerid>
    docker start <containerid>
    docker pause <containerid>
#prune
    #remove all stopped containers
    docker container prune 
    #prune system, volume
    docker system prune && docker volume prune
#
#running image (with published port)
docker run -p 80:80 <image_name>
#run in detached mode
docker run -d -p 80:80 <image_name>
#
#LOGS
docker logs <containerid>
    #-f(following log) -n(number of entries)
    docker logs -f -n % <containerid> 
#start new process inside container/execute command from shell 
docker exec <options> <containerid/container_name> <cmd>
    #leave process using "CTRL+D" or type "exit"
    #docker exec -i(interactive shell)t <7a4951775d15/my_container1> </bin/sh>
#
#ATTACHING to running container shell #if you exit then container stops
docker attach <containerid/container_name>
    #To detach press CTRL+P+Q (leave without stopping container)
    #