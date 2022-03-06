#fix .yml file
#@http://www.yamllint.com/@
#download compose
#@https://docs.docker.com/compose/compose-file/compose-file-v3/@
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#apply permissions)
chmod +x /usr/local/bin/docker-compose
#
docker-compose --version
docker-compose up -d ((run services in detached mode))
docker-compose down  ((stop and remove containers created for services))
#
#What’s the difference between up, run, and start?🔗
#Typically, you want docker-compose up. 
#Use up to start or restart all the services defined in a docker-compose.yml. 
#In the default “attached” mode, you see all the logs from all the containers. 
#In “detached” mode (-d), Compose exits after starting the containers, 
#but the containers continue to run in the background.
#
#The docker-compose run command is for running “one-off” or “adhoc” tasks. 
#It requires the service name you want to run and only starts containers for services 
#that the running service depends on. 
#Use run to run tests or perform an administrative task such as removing 
#or adding data to a data volume container. 
#The run command acts like docker run -ti in 
#that it opens an interactive terminal to the container and returns an exit status
#matching the exit status of the process in the container.
#
#The docker-compose start command is useful only to restart containers that were previously created, but were stopped. It never creates new containers.
curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
#sample file
version: '3' #compose file version

services: #list of containers
	product-service: #1st container
		build: ./product #path of docker-compose file
		volumes:
			- ./product:/usr/src/app #host_path:guest_path
			ports:
			- 5001:80 #hostport:containerport
#
services: 
  product-service: 
    build: ./product
    ports: 
      - "5001:80"
    volumes: 
      - "./product:/usr/src/app"
version: "3"