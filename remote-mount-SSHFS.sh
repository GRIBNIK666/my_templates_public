yum --enablerepo=powertools -y install fuse-sshfs #install sshfs client on both clients
#
sshfs -d root@90.0.1.2:/home/distrib/ /mnt/distrib
##sshfs -d root@90.0.1.2((address)):/home/distrib/((host path)) /mnt/distrib((guest path owned by root))