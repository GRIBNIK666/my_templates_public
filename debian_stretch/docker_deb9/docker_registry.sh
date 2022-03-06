#docker_registry.sh
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  stretch stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
iptables -A INPUT -p tcp --dport 2379:2380 -j ACCEPT && iptables-save
apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl enable docker
docker run -d -p 5000:5000 --restart=always --name registry registry:2
#
touch /etc/docker/daemon.json
#echo '{ "insecure-registries":["90.0.1.77:5000"] }' >> /etc/docker/daemon.json
#echo '{ "insecure-registries":["localhost:5000"] }' >> /etc/docker/daemon.json
#src:https://gist.github.com/melozo/6de91558242fb8ca4212e4a73fbddde6
cat <<EOF | sudo tee /etc/docker/daemon.json
{
        "insecure-registries":
                [
                "deb-repo.localdomain.local:5000",
                "90.0.1.77:5000"
                ]
}
EOF
#{
#        "registry-mirrors":
#                [
#                "deb-repo.localdomain.local:5000",
#                "90.0.1.77:5000"
#                ]
#}
#"block-registry": ["docker.io"],
#"registry-mirrors":["deb-repo.localdomain.local:5000","90.0.1.77:5000"],
#"add-registry": ["deb-repo.localdomain.local:5000","90.0.1.77:5000"],
service docker restart
#login to registry on local nodes
docker login -u root -p root deb-repo.localdomain.local:5000
