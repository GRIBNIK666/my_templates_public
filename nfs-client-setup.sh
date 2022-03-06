#nfs-client-setup.sh
dnf install nfs-utils nfs4-acl-tools

#list remote exports
showmount -e "<server-ip/hostname>"

#create a local dir/fs for mounting remote NFS fs 
mkdir "</path>" #/mnt/backups

#mount remote NFS fs as an NTF fs
mount -t nfs "<server-ip/hostname>:</remote-path> </local-path>"
	#mount -t nfs docker1.mydomain:/mnt/backups /mnt/backups #-t nfs: file system type = NFS
#verify avaliability
mount | grep nfs
#enable the mount to be persistent
echo "nfs docker1.mydomain:/mnt/backups /mnt/backups nfs defaults 0 0" >> /etc/fstab
#verify result
cat /etc/fstab
	ssh root@docker1.mydomain
	touch /mnt/backups/readme
	exit
ls -lah /mnt/backups
#