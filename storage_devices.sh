##storage_devices.sh
##
#info
LVM has basically three terms:
- Physical Volume PV;
- Volume Group VG;
- Logical Volume LV;
'
PV: It’s a raw hard drive that it initialized to work with LVM
	, such as /dev/sdb, /dev/sdc, /dev/sdb1 etc.

VG: Many PV is combined into one VG. 
	You can create many VGs and each of them has a unique name.

LV: You can create many LVs from a VG. 
	You can extend, reduce the LV size on the fly. 
	The LV also has unique names. 
	You format the LV into ext4, zfs, btrfs etc filesystems, mount it
 	and use it as you do other ordinary partitions.
'
##
# sda           8:0    0   16G  0 disk     #primary disk
# ├─sda1        8:1    0    1G  0 part /boot #boot partition
# └─sda2        8:2    0   15G  0 part       #primary part
#   ├─cl-root 253:0    0 13.4G  0 lvm  /       #os part   #vg 'cl'
#   └─cl-swap 253:1    0  1.6G  0 lvm          #swap part #vg 'cl'
# sr0          11:0    1 1024M  0 rom      #cdrom dev
# nvme0n1     259:0    0    1G  0 disk     #disk1
# nvme0n2     259:1    0    1G  0 disk 	   #disk2
# nvme0n3     259:2    0    2G  0 disk     #disk3
#
#return kernel buffer to chk drive has been connected properly
	#dependencies
	yum makecache #update the YUM package repository cache
	yum install lvm
dmesg -T

#list all storage entities
lsblk -o KNAME,TYPE,SIZE,MODEL

#list hw disks info
lshw -class disk -class tape

#list partitions lvm
fdisk -l

#check existing physical volumes
pvdisplay
	#short info
	pvscan
#
##HOW TO connect physical volume to machine
#I.Easy way
	#find your unmapped disk
	lsblk 
	#create mount dir
	mkdir /"<MOUNTPOINT>"
	#create fs
	mkfs.ext4 /dev/"<disk-path>"
	#mount disk
	mount -t ext4 /dev/nvme0n2 /mnt/nvme0n2/
	#verify result
	df -h |grep "<disk-name>"
#
#II.Advanced guide (using partitions, volume groups, LVMs)
#get disk name
lsblk -o NAME,TYPE |grep disk
#create new physical volume
pvcreate /dev/"<disk_name>"
#create new partition from physical volume
pvdisplay
fdisk /dev/"<pv-name>"
	F #list free unpartitioned space
	n #add new part
		p #primary part
		1-4 #num
	t #change type
		8e #linux lvm
	w #save changes #q leave without saving

#create new VG
vgscan #list existing VGs
vgdisplay "<vg-name>"
vgcreate "<vg-name>" /dev/"<pv-name>"
#add new PV to volume group
vgextend "<vg-name>" /dev/"<pv-name>"
	#verify which PV belongs to VG
	pvscan
	#remove PV from volume group
	vgreduce "<vg-name>" /dev/"<pv-name>"
	#change qty of LVMs in VG
	vgchange -l "<num>" /dev/"<vg-name>"

#create new LVm in vg
lvcreate \
	--size 100M \
	--name "<lvm-name>" \
	"<vg-name>"

#show existing LVMs
lvscan
	fdisk -l #disks, partitions, volumes
#from <fdisk -l> copy disk/part/lvm path to format fs
mkfs.ext4 /dev/"<entity-path>"
#create new mounting point
mkdir /mnt/"<dir>"
mount -t ext4 \
	/dev/"<entity-path>" \
	/mnt/"<dir>"
		#/mnt/<dir> is SOURCE
		#/dev/<entity-path> is MOUNTPOINT
df -h #verify disk space for new mounted devices
#
#

##HOW TO extend ROOT partition 
#(allocate new DISK (1st disk) to existing root LVM (2nd disk))
#unmount disk
umount /mnt/nvme0n2
fdisk /dev/"<disk-path>" 
		#o #create dos part-table if DOESN'T exist
		#w
	#check existing LVMs
	lvmdiskscan |grep "<disk-path>"
	#check existing PVs
	pvscan && pvdisplay /dev/"<disk-path>"
#format new disk
mkfs.ext4 /dev/"<disk-path>"
#create new physical volume on formatted disk
pvcreate /dev/"<disk-path>"
#find which volume group has root LVM
vgscan
#add disk to system volume group
vgextend cl /dev/"<disk-path>"
#verify free disk space, that can be utilized by resizing
vgdisplay cl
	#fdisk -l |grep cl
#extend root LVM size
lvextend -l +100%FREE /dev/mapper/cl-root
#extend root filesystem size
xfs_growfs /dev/mapper/cl-root
	#resize2fs /dev/mapper/cl-root #use if primary option doesn't suit the case
#verify result
df -h
	#if system won't load, boot up in rescue mode and apply this
	dracut --regenerate-all -f && grub2-mkconfig -o /boot/grub2/grub.cfg
	#BOOT PROBLEMS: https://unix.stackexchange.com/questions/516895/system-boots-into-dracut-mode-in-centos-7

###Mediocre guides:
##HOW TO RESIZE LVM (data loss is a risk)
	#unmount used lvm
	umount /<MOUNTPOINT>
	#size lvm and filesystem
	lvresize --resizefs -L "<size-mb>" /dev/"<entity-path>"
	#mount lvm to system
	mount /dev/"<entity-path>" /"<MOUNTPOINT>"
		#verify new FS size
		df -h |grep /"<MOUNTPOINT>"
	#
##HOW TO resize lvm, using free space in partition/disk (losing data)
	#unmount used lvm
	umount /"<MOUNTPOINT>"
	#check lvm's integrity
	e2fsck -f /dev/"<entity-path>"
	#change file system size
	resize2fs /dev/"<entity-path>" 256M
	#change lvm size (should be more than FS size)
	lvresize -L "<size-mb>" /dev/"<entity-path>"
		#lvresize -l +100%FREE /dev/mapper/aboba-nvme_test1_lvm
	#format lvm to apply new size
	mkfs.ext4 /dev/"<entity-path>"
	#mount lvm to system
	mount -t ext4 /dev/"<entity-path>" /"<MOUNTPOINT>"

###Add:
##HOW TO merge 2 LVMs (1 mounted&&formatted and 1 unmounted&&unformatted)

#SOME INFO
#https://christitus.com/lvm-guide/
'
LVM Commands
LVM Layer 1 – Hard Drives, Partitions, and Physical Volumes
lvmdiskscan – system readout of volumes and partitions
pvdisplay – display detailed info on physical volumes
pvscan – display disks with physical volumes
pvcreate /dev/sda1 – create a physical volume from sda1
pvchange -x n /dev/sda1 – Disallow using a disk partition
pvresize /dev/sda1 – resize sda1 PV to use all of the partition
pvresize --setphysicalvolumesize 140G /dev/sda1 – resize sda1 to 140g
pvmove /dev/sda1 – can move data out of sda1 to other PVs in VG. Note: Free disk space equivalent to data moved is needed elsewhere.
pvremove /dev/sda1 – delete Physical volume

LVM Layer 2 – Volume Groups
vgcreate vg1 /dev/sda1 /dev/sdb1 – create a volume group from two drives
vgextend vg1 /dev/sdb1 – add PV to the volume group
vgdisplay vg1 – Display details on a volume group
vgscan – list volume groups
vgreduce vg1 /dev/sda1 – Removes the drive from vg1
Note: use pvmove /dev/sda1 before removing the drive from vg1
vgchange – you can activate/deactive and change perameteres
vgremove vg1 – Remove volume group vg1
vgsplit and vgmerge can split and merge volume groups
vgrename– renames a volume group

LVM Layer 3 – Logical Volumes and File Systems
lvcreate -L 10G vg1 – create a 10 GB logical volume on volume group vg1
lvchange and lvreduce are commands that typically aren’t used
lvrename– rename logical volume
lvremove – removes a logical volume
lvscan – shows logical volumes
lvdisplay – shows details on logical volumes
lvextend -l +100%FREE /dev/vg1/lv1– One of the most common commands used to extend logical volume lv1 that takes up ALL of the remaining free space on the volume group vg1.
resize2fs /dev/vg1/lv1 – resize the file system to the size of the logical volume lv1.
'
#WIP