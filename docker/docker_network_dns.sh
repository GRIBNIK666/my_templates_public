#docker_network_dns.sh
##HOW TO access docker container by dns-name
#Preparation
#
#create test network
docker network create -d bridge <network-name>
	docker network inspect <network-name>
#run nginx container in test network
docker run --name "<container-name>" \
	-d -p "<hostport>":"<containerport>" \
	--network "<network-name>" \
	nginx:latest
#display container network properties
docker network inspect <network-name> | awk '/<container-name>/,/IPv6Address/'
#
#run second nginx container in test network
docker run --name "<container-name>" \
	-d -p "<hostport>":"<containerport>" \
	--network "<network-name>" \
	nginx:latest
#
#display network properties (both instances should be present)
docker network inspect <network-name> | awk '/<container-name>/,/IPv6Address/'
#access second container by auto-assigned DNS name
docker exec -it "<container-name1>" \
	curl "<container-name2>"
#
