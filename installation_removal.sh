#return repo list
yum repolist
#return repo files
ls -lah /etc/yum.repos.d/
##
systemctl stop <service>
yum remove <service/repository link>
yum install/update <service/repository link>
yum install /<path>/<file.rpm>
rpm -e file.rpm #-e=delete #(also -q(query) -p(package) -R(requirements))
#
#download rpm from repository to work dir
yumdownloader <package name>
	yum install yum-utils #dependency 
#
#download multiple packages to dir
yumdownloader <package name> <package name> --destdir <path> --resolve
#download packages from certain group
yumdownloader "<group title>"--destdir <path> --resolve
#
#download file by link
wget <link>
	yum install wget #dependency
#download rpm installation file
#
wget <link.rpm>
#
##manage kernels
#search for avaliable kernels
yum list --showduplicates kernel
#check installed kernels
rpm -q kernel
#remove kernel
yum list installed kernel*
yum remove \
	kernel-'<version>'.x86_64 \
	kernel-core-'<version>'.x86_64 \
	kernel-devel-'<version>'.x86_64 \
	kernel-headers-'<version>'.x86_64 \
	kernel-modules-'<version>'.x86_64 \
	kernel-tools-'<version>'.x86_64 \
	kernel-tools-libs-'<version>'.x86_64
#