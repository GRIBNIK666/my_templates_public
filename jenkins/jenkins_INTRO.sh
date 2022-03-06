#install (ltsr)
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
	#import repo key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins java-11-openjdk-devel
sudo systemctl daemon-reload

#OPEN PORTS FOR SUCCESSFUL WEBHOOKS
firewall-cmd --add-port=80/tcp --permanent && firewall-cmd --reload
firewall-cmd --add-port=8080/tcp --permanent && firewall-cmd --reload
#1
sudo systemctl start jenkins
	#verify
sudo systemctl status jenkins
#2 add firewall rule for 8080:tcp
YOURPORT=8080
PERM="--permanent"
SERV="$PERM --service=jenkins"
	firewall-cmd $PERM --new-service=jenkins
	firewall-cmd $SERV --set-short="Jenkins ports"
	firewall-cmd $SERV --set-description="Jenkins port exceptions"
	firewall-cmd $SERV --add-port=$YOURPORT/tcp
	firewall-cmd $PERM --add-service=jenkins
	firewall-cmd --zone=public --add-service=http --permanent
	firewall-cmd --reload
#3 unlock & postinstall cfg
cat /var/lib/jenkins/secrets/initialAdminPassword
	#or for docker
docker exec <containerid/name> cat /var/jenkins_home/secrets/initialAdminPassword
#check completed jobs
cd /var/lib/jenkins/jobs && ls -a

###RESET PASSWORD
sudo cp /var/lib/jenkins/config.xml /var/lib/jenkins/config.xml.back
vi /var/lib/jenkins/config.xml #change to "<useSecurity>false</useSecurity>"
systemctl restart jenkins
#change password for admin
	#then
mv /var/lib/jenkins/config.xml.back /var/lib/jenkins/config.xml
systemctl restart jenkins


#adding agent
ssh-keygen -f ~/.ssh/jenkins_agent_key
	#Your identification has been saved in /root/.ssh/jenkins_agent_key
sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" <containerid/name> #get ip address for ssh connection
	#docker default network 172.17.0.*(1=host)(2+=containers)
#shell command for my first job (test)
echo 'Starting job...'
sleep 1
export USE_TTY="--tty"
echo 'create export var'
sleep 2
echo '/bin/sh done (Deleted)'
sleep 2
hostnamectl
sleep 1
docker version |grep Version:
sleep 5
docker exec ${USE_TTY} samp_test bash && echo 'executed docker container'
sleep 5
cd /home/samp03
sleep 2
sampctl -V
sleep 2
git pull http://gitlab.mydomain:8080/samp03/samp03.git test
sleep 5
sampctl package build

#exec sh
echo 'Starting job...'
docker exec samp_test rm -rf /home/exec.sh
sleep 1
docker exec samp_test touch /home/exec.sh && docker exec samp_test chmod 775 /home/exec.sh
docker exec samp_test bash -c "echo 'cd /home/samp03 && sleep 2 && sampctl -V && sleep 2 && git pull http://gitlab.mydomain:8080/samp03/samp03.git test && sleep 5 && sampctl package build' > /home/exec.sh"
sleep 30
docker exec samp_test bash -c "./home/exec.sh"
sleep 10
docker logs -t -n 20 samp_test
sleep 1