#create keys by default: id_rsa and id_rsa.pub in the /home/your_username/.ssh or /root/.ssh
ssh-keygen -b 8192 #8192 = length
#
#copy public key to other server
		ssh-copy-id root@90.0.1.2 #remote server ip
		#copy public identity file to remote host
		ssh-copy-id -i "<path/file>" root@90.0.1.77
ssh-copy-id "<user>"@"<ip-address>"
#generate jenkins-friendly key
ssh-keygen -t rsa -m PEM -f "<file>"