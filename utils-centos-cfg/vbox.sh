#guiless
su root
mount /dev/cdrom /media/cdrom
#
yum install kernel-devel #kernel headers
#troubleshooting (HOW TO install for specific kernel version)
yum install "kernel-devel-unname-r == $(uname -r)"
yum install gcc perl make elfutils-libelf-devel
cd /media/cdrom && ./VboxLinuxAdditions.run