#portainer server deployment
curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o portainer-agent-stack.yml
sudo docker stack deploy -c portainer-agent-stack.yml portainer
#how to reset admin password
docker service ls
docker service scale portainer_portainer=0
docker run --rm -v portainer_portainer_data:/data portainer/helper-reset-password
sleep 5
docker service scale portainer_portainer=1
echo 'done'