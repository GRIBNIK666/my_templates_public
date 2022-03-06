#nfs-server-setup.sh
#src used: tecmint.com/install-nfs-server-on-centos-8/
##I. BASIC NFS SERVER CONFIGURATION
yum -y install nfs-utils nfs-utils-lib

dnf -y install nfs-utils

systemctl enable nfs-server.service
	systemctl start nfs-server.service
systemctl status nfs-server.service
showmount #Hosts on docker1.mydomain:

cat /etc/nfs.conf #main configuration file for the NFS daemons and tools.
cat /etc/nfsmount.conf # an NFS mount configuration file.

#create file systems #export or share on the NFS server
mkdir /mnt/nfs_shares
mkdir /mnt/backups
mkdir /mnt/nfs_shares/{dir1,dir2,dir3}
	ls -lah /mnt/nfs_shares

#export created FS in /etc/exports
cat /etc/exports
	#format: <path> <host1>(<options>) <hostN>(<options>)...
	#more: access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/s1-nfs-server-config-exports
#contents
echo \
'
/mnt/nfs_shares/dir1 *.mydomain(rw,sync) *.*.mydomain(rw,sync)
/mnt/nfs_shares/dir2 *.mydomain(rw,sync) *.*.mydomain(rw,sync)
/mnt/nfs_shares/dir3 *.mydomain(rw,sync) *.*.mydomain(rw,sync)
/mnt/backups  *.mydomain(rw,sync,no_all_squash,no_root_squash) *.*.mydomain(rw,sync,no_all_squash,root_squash)
' \
>> /etc/exports
#
#
	rw – allows both read and write access on the file system.
	sync – tells the NFS server to write operations (writing information to the disk) when requested (applies by default).
	all_squash – maps all UIDs and GIDs from client requests to the anonymous user.
	no_all_squash – used to map all UIDs and GIDs from client requests to identical UIDs and GIDs on the NFS server.
	root_squash – maps requests from root user or UID/GID 0 from the client to the anonymous UID/GID.
#

#export added filesystems 
	#-a #export or unexport all directories
	#-r #reexport all directorie
	#-v #verbose
exportfs -arv

#list current exported fs
exportfs  -s

#allow traffic to nfs svc
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload
echo "done"
#