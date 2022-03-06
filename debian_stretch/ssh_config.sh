#ssh_config.sh
#change root password
sudo passwd root

#allow ssh connection
sudo systemctl status ssh
sudo systemctl enable ssh
sudo systemctl start ssh

#update ssh-server config
cat /etc/ssh/sshd_config |grep PermitRoot
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl restart sshd.service
#
