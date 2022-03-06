#docker_to_lvm.sh
#mandatory package
apt install lvm2
#Advanced guide (using partitions, volume groups, LVMs)
#get disk name
lsblk -o NAME,TYPE |grep disk
#create new physical volume
pvcreate /dev/"<disk_name>"
df -h |grep sdb1
#create new volume group
vgcreate dockervg /dev/sdb1
#create new lvm
lvcreate --size 8000M --name dockerlvm dockervg
lsblk && lvscan
#create fs
mkfs.ext4 /dev/dockervg/dockerlvm
#mount fs
mount -t ext4 /dev/dockervg/dockerlvm /new/docker/path
df -h
#migrate docker to new fs
systemctl stop docker && systemctl status docker
#copy info #/var/lib/docker is default root dir
rsync -avxP /var/lib/docker/ /new/docker/path
#configure new docker root directory
nano /lib/systemd/system/docker.service
#add to line
ExecStart=/usr/bin/dockerd -g /new/docker/path -H fd:// --containerd=/run/containerd/containerd.sock
#restart docker services
systemctl daemon-reload
systemctl restart docker
docker info | grep Root
#Get its unique UUID identifier, the line has the name you gave the LV:
blkid
#Edit /etc/fstab and add a line similar to this. Your UUID and mount point will be different.
echo 'UUID=fcde9bb7-4311-41e2-986a-647a672ebf83       /mnt/example    ext4    defaults        0       2' >> /etc/fstab